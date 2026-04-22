;;;; generate-bindings.lisp - Generate the Lisp bindings for River's protocols.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(#:alexandria
                  #:com.andrewsoutar.cl-wayland-client.generator)))

(uiop:define-package #:mtwm/generator
  (:mix #:cl
        #:alexandria
        #:com.andrewsoutar.cl-wayland-client.generator)
  (:export #:generate))

(in-package #:mtwm/generator)

(defun generate-binding (protocol &optional use)
  "Generate the specified protocol binding."
  (let* ((system (asdf:find-system "mtwm"))
         (output-file (asdf:system-relative-pathname system (format nil "src/protocols/~A.lisp" protocol)))
         (package-name (format nil "MTWM.~A" (string-upcase protocol))))
    (with-open-file (protocol-out output-file :direction :output :if-exists :rename-and-delete :if-does-not-exist :create)
      (format protocol-out ";;;; ~A - Auto-generated binding for River's ~S protocol.~%" (file-namestring output-file) protocol)
      (pprint `(uiop:define-package ,package-name
                 (:use #:cl
                       #:com.andrewsoutar.cl-wayland-client/core
                       ,@use))
              protocol-out)
      (format protocol-out "~2&(in-package #:~A)~%" package-name)
      (pprint (com.andrewsoutar.cl-wayland-client.generator::generate-from-xml
               (asdf:system-relative-pathname system (format nil "protocols/~A.xml" protocol))
               package-name
               (list* "COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE"
                      use))
              protocol-out))))

(defun generate ()
  "Generate bindings for all the necessary River protocols."
  (generate-binding "river-window-management-v1")
  (generate-binding "river-xkb-bindings-v1" (list "MTWM.RIVER-WINDOW-MANAGEMENT-V1")))
