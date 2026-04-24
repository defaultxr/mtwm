;;;; mtwm.lisp - A Wayland window manager in Common Lisp, for the River compositor.

(in-package #:mtwm)

;;; Global state

(defvar *display* nil)
(defvar *registry* nil)
(defvar *seat* nil)
(defvar *window-manager* nil)
(defvar *xkb-bindings* nil)

;;; Utility

(defun info (control-string &rest args)
  "Print an informational message. Like `format' but includes the newlines and destination for you."
  (apply #'format t (concat "~&" control-string "~%") args))

;;; Window

(defvar *windows* nil)

(defclass window ()
  ((proxy :initarg :proxy :accessor window-proxy)
   (node :initarg :node :accessor window-node)
   (x :initarg :x :accessor window-x)
   (y :initarg :y :accessor window-y)))

;; Define our registry class to handle global bindings
(defclass recording-registry (wl-registry)
  ((globals :type list :accessor globals :initform ())))

(defmethod wl-registry-global ((self recording-registry) name interface version)
  (push (list name interface version) (globals self)))

(defmethod wl-registry-global-remove ((self recording-registry) name)
  (setf (globals self) (delete name (globals self) :key #'first)))

(defun find-interface (registry interface &optional (min-version 0))
  "Helper to find an interface."
  (let ((info (gethash interface (interfaces registry))))
    (when info
      (destructuring-bind (name version) info
        (when (>= version min-version)
          (return-from find-interface (values name version))))))
  (error "Interface ~S not found (min version ~D)" interface min-version))

(defclass mtwm-window-manager (river-window-manager-v1)
  ())

;; Window manager callbacks
(defmethod river-window-manager-v1-unavailable ((self mtwm-window-manager))
  (error "Another window manager is already running"))

(defmethod river-window-manager-v1-finished ((self mtwm-window-manager))
  (info "Window manager finished")
  (sb-ext:exit :code 0))

#+(or)
(defmethod river-window-manager-v1-manage-start ((self mtwm-window-manager))
  (info "Manage start")
  (let ((xkb-binding (wl-registry-bind *registry*
                                       (wl-registry-find-or-lose *registry* "river_xkb_bindings_v1" 1)
                                       (make-instance 'mtwm-xkb-binding :version 1))))
    (river-xkb-bindings-v1-get-xkb-binding xkb-binding *seat* 0 "a" 0)
    (setf *xkb-binding* xkb-binding)
    (river-xkb-binding-v1-enable xkb-binding))
  (river-window-manager-v1-manage-finish self))

(defmethod river-window-manager-v1-manage-start ((self mtwm-window-manager))
  (format t "Manage start~%")
  #+(or)
  (let ((xkb-binding (make-instance 'mtwm-xkb-binding)))
    (river-xkb-bindings-v1-get-xkb-binding *xkb-bindings* *seat* xkb-binding (xkbcommon:keysym-from-name "a") :none)
    (river-xkb-binding-v1-enable xkb-binding))
  (river-window-manager-v1-manage-finish self))

(defmethod river-window-manager-v1-render-start ((self mtwm-window-manager))
  (info "Render start")
  (river-window-manager-v1-render-finish self))

(defmethod river-window-manager-v1-session-locked ((self mtwm-window-manager))
  (info "Session locked"))

(defmethod river-window-manager-v1-session-unlocked ((self mtwm-window-manager))
  (info "Session unlocked"))

(defmethod river-window-manager-v1-window ((self mtwm-window-manager) window-proxy)
  (info "New window created! Moving to 500,500")
  ;; Create window object
  (let ((window (make-instance 'window :proxy window-proxy)))
    (push window *windows*)
    ;; TODO: Get node and move window
    ;; (let ((node (river-window-v1-get-node window-proxy)))
    ;;   (wl-node-v1-set-position node 500 500))
    ))

(defmethod river-window-manager-v1-output ((self mtwm-window-manager) output)
  (info "New output"))

(defmethod river-window-manager-v1-seat ((self mtwm-window-manager) seat)
  (info "New seat")
  (setf *seat* seat))

(defvar *xkb-binding* nil)

(defclass mtwm-xkb-bindings (river-xkb-bindings-v1)
  ()
  (:documentation "Class handling bindings."))

(defclass mtwm-xkb-binding (river-xkb-binding-v1)
  ()
  (:documentation "Class representing a binding."))

;; Handle key press events
(defmethod river-xkb-binding-v1-pressed ((self mtwm-xkb-binding)) ; keymap modifiers state
  ;; (info "Key pressed: keymap=~a modifiers=~a state=~a" keymap modifiers state)
  (info "Key pressed: ~S" self)
  ;; Handle the key press here
  )

;; Handle key release events
(defmethod river-xkb-binding-v1-released ((self mtwm-xkb-binding)) ; keymap modifiers state
  (info "Key released: ~S" self))

(defun wl-registry-find-or-lose (registry interface &optional version)
  (or (dolist (global (globals registry))
        (destructuring-bind (gname ginterface gversion) global
          (when (and (equal ginterface interface)
                     (or (null version) (>= gversion version)))
            (return (values gname gversion)))))
      (error "Wayland: could not find interface ~A~@[ version ~A~] in registry"
             interface version)))

;;; Create a xdg_wm_base subclass which responds to pings
(defclass xdg-wm-base-pingpong (xdg-wm-base) ())

;;; Every time we receive a ping, send back a pong
(defmethod xdg-wm-base-ping ((self xdg-wm-base-pingpong) serial)
  (xdg-wm-base-pong self serial))

(defclass invoking-callback (wl-callback)
  ((fun :type (function ((unsigned-byte 32)) *) :accessor fun :initarg :fun)))

(defmethod wl-callback-done ((self invoking-callback) data)
  (funcall (fun self) data))

(defun roundtrip (display)
  "Wait for all previous requests to be processed by the wayland compositor"
  (let (callback done-p)
    (unwind-protect
         (flet ((set-done (x)
                  (declare (ignore x))
                  (setf done-p t)))
           ;; This request simply invokes the provided callback as
           ;; soon as it's processed. Since Wayland processes requests
           ;; in order, it won't be processed until all prior requests
           ;; are done being processed.
           (setf callback (wl-display-sync display (make-instance 'invoking-callback :fun #'set-done)))
           (loop until done-p do (wl-display-dispatch display)))
      (when callback (wayland-destroy callback)))))

;; Main entry point
;; #+(or)
(defun main (&optional (wayland-display "wayland-1"))
  ;; (info "MTWM - River Window Manager")
  (info "Connecting to Wayland...")

  ;; Connect to display
  (setf *display* (wl-display-connect wayland-display))
  ;; (when (null-pointer-p *display*)
  ;;   (error "Failed to connect to River"))

  ;; Create registry and get it from the display
  (setf *registry* (wl-display-get-registry *display* (make-instance 'recording-registry)))
  ;; (setf *registry* (wayland-client-core::wl-display-get-registry *display*))

  ;; Roundtrip to get all globals
  ;; (wl-display-roundtrip *display*)
  (roundtrip *display*)

  ;; Find and bind to River window manager
  ;; (multiple-value-bind (name version) (find-interface *registry* "river_window_manager_v1" 4))
  ;; (info "Binding river_window_manager_v1 v~d" version)
  (setf *window-manager* (wl-registry-bind *registry*
                                           (wl-registry-find-or-lose *registry* "river_window_manager_v1" 4)
                                           (make-instance 'mtwm-window-manager :version 1)))

  (setf *xkb-bindings* (make-instance 'mtwm-xkb-bindings))

  (info "Connected! Entering event loop...")

  (loop :for ret := (wl-display-dispatch *display*)
        :when (< ret 0)
          :do (error "Dispatch failed")))
