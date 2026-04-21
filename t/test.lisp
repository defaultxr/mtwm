;;;; t/test.lisp - basic tests and test utilities/fixtures/etc for the #| TMPL_VAR name |# test suite.

(defpackage #:mtwm/tests
  (:use #:cl
        #:mtwm
        #:alexandria
        #:mutility
        #:fiveam))

(in-package #:mtwm/tests)

(def-suite mtwm-tests
  :description "mtwm tests suite.")

(in-suite mtwm-tests)

(test system-attributes
  "Check that the system has all the standard attributes"
  (let ((missing (system-missing-attributes '#:#| TMPL_VAR name |#)))
    (is-false missing
              "The system definition is missing attributes: ~S" missing)))

(test undocumented-symbols
  "Check for any undocumented exported symbols"
  (let ((undocumented (package-undocumented-symbols '#:#| TMPL_VAR name |#)))
    (is-false undocumented
              "some exported symbols do not have docstrings: ~S" undocumented)))

(test docstrings-broken-links
  "Check for any broken links in docstrings of exported symbols"
  (let ((symbols (package-docstrings-with-broken-links '#:#| TMPL_VAR name |#)))
    (is-false symbols
              "some exported symbols have docstrings that contain broken links: ~S" symbols)))
