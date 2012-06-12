(defpackage :hawksbill.utils
	(:use :cl :hunchentoot :cl-who :cl-memcached :cl-ppcre)
  (:export
   ;; config
   :*home*
   :*config*
   :*environment*
   :scwe
   :make-config-tuple
   ;; html
   :with-html
   ;; init
   :hu-start
   :hu-stop
   ;; memcache
   :with-cache
   ))

(in-package :hawksbill.utils)
