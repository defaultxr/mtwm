;;;; generate-protocols.lisp - Generate River protocol bindings.
;; ACTUALLY WORKING VERSION!!!
;; FIX: use `asdf:perform' to generate the protocols instead of calling `generate-from-xml'

;; (eval-when (:compile-toplevel :load-toplevel :execute)
;;   (require :asdf)
;;   (asdf:load-system :com.andrewsoutar.cl-wayland-client.generator))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(#:alexandria
                  #:mutility
                  #:com.andrewsoutar.cl-wayland-client.generator)))

(uiop:define-package #:mtwm/generator
  (:mix #:cl
        #:alexandria
        #:mutility
        #:com.andrewsoutar.cl-wayland-client.generator)
  (:export #:generate))

(in-package #:mtwm/generator)

(defun generate-binding (protocol &optional use)
  "Generate the specified protocol binding."
  (let ((output-file (concat "/home/modula/misc/lisp/mtwm/src/" protocol ".lisp"))
        (package-name (concat "MTWM." (string-upcase protocol))))
    (with-open-file (protocol-out output-file :direction :output :if-exists :overwrite :if-does-not-exist :create)
      (format protocol-out ";;;; ~A - Generated River protocol binding~%~%" (file-namestring output-file))
      ;; (format protocol-out "(uiop:define-package #:~A~%  (:use #:cl)~%  (:use #:com.andrewsoutar.cl-wayland-client/core))~%~%" package-name)
      (pprint `(uiop:define-package ,package-name
                 (:use #:cl
                       "COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE"
                       ,@use))
              protocol-out)
      (format protocol-out "(in-package #:~A)~%~%" package-name)
      (pprint (com.andrewsoutar.cl-wayland-client.generator::generate-from-xml
               (concat "/home/modula/misc/lisp/mtwm/protocols/" protocol ".xml")
               package-name
               (list* "COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE"
                      use))
              protocol-out))))

(defun generate ()
  "Actually generate the protocol bindings."
  (generate-binding "river-window-management-v1")
  (generate-binding "river-xkb-bindings-v1" (list "MTWM.RIVER-WINDOW-MANAGEMENT-V1")))
