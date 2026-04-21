;;;; mtwm.asd

(defsystem #:mtwm
  :name "mtwm"
  :description "River window manager in Common Lisp"
  :version "0.1"
  :author "modula t."
  :license "MIT"
  :homepage "https://github.com/defaultxr/mtwm"
  :bug-tracker "https://github.com/defaultxr/mtwm/issues"
  :mailto "modula-t at pm dot me"
  :source-control (:git "git@github.com:defaultxr/mtwm.git")
  :depends-on (#:alexandria
               #:mutility
               #:cffi
               #:com.andrewsoutar.asdf-generated-system
               #:com.andrewsoutar.cl-wayland-client.generator
               #:com.andrewsoutar.cl-wayland-client
               #:xkbcommon)
  :pathname "src/"
  :serial t
  :components ((:module protocols
                :components ((:file "river-window-management-v1")
                             (:file "river-xkb-bindings-v1")))
               (:file "package")
               (:file "mtwm"))
  :in-order-to ((test-op (test-op "mtwm/tests"))))

(defsystem #:mtwm/tests
  :name "mtwm/tests"
  :description "FiveAM-based test suite for mtwm."
  :author "modula t."
  :license "MIT"
  :depends-on (#:mtwm
               #:fiveam
               #:mutility/test-helpers)
  :pathname "t/"
  :serial t
  :components ((:file "test")
               (:file "mtwm"))
  :perform (test-op (op c)
                    (uiop:symbol-call :fiveam :run!
                                      (uiop:find-symbol* '#:mtwm-tests
                                                         :mtwm/tests))))
