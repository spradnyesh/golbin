(defpackage :hawksbill.utils
  (:use :cl :cl-who :cl-memcached :cl-ppcre :parenscript :restas :split-sequence)
  (:export
   ;; config
   :*home*
   :config-storage
   :*config-storage*
   :*dimensions*
   :*valid-envts*
   :*valid-intls*
   :*valid-langs*
   :*default-envt*
   :*default-intl*
   :*default-lang*
   :get-config
   :add-config
   :show-config-tree
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
