(defpackage :hawksbill.utils
	(:use :cl :hunchentoot :cl-who :cl-memcached :cl-ppcre :parenscript)
  (:export
   ;; config
   :*home*
   :*config*
   :*environment*
   :scwe
   :make-config-tuple
   ;; html
   :with-html
   :js-script
   ;; init
   :hu-start
   :hu-stop
   ;; memcache
   :with-cache
   ;; helpers
   :conditionally-accumulate
   :slugify
   :paginate
   ))

(in-package :hawksbill.utils)
