(defpackage :hawksbill.utils
  (:use :cl :cl-who :cl-memcached :cl-ppcre :parenscript :restas)
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
   :pagination-markup
   ))

(in-package :hawksbill.utils)
