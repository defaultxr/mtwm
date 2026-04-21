;;;; package.lisp

(uiop:define-package #:mtwm
  (:mix #:cl
        #:alexandria
        #:mutility
        #:mtwm.river-window-management-v1
        #:mtwm.river-xkb-bindings-v1
        #:com.andrewsoutar.cl-wayland-client
        #:com.andrewsoutar.cl-wayland-client/core
        #:cffi)
  (:import-from #:com.andrewsoutar.cl-wayland-client/core
                #:wayland-proxy
                #:find-proxy
                #:wl-proxy-marshal-array
                #:wl-proxy-marshal-array-constructor-versioned)
  (:export #:main
           #:start))
