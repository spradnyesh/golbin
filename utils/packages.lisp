(restas:define-module :hawksbill.golbin.utils
	(:use :cl :hunchentoot :cl-who :cl-memcached)
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

(in-package :hawksbill.golbin.utils)
