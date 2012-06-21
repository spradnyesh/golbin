(defpackage :hawksbill.utils
  (:use :cl :cl-who :cl-memcached :cl-ppcre :parenscript :restas :split-sequence)
  (:export
   :*home*
   ;; config
   :config-storage ; class
   :*config-storage*
   :*config* ; input to init-config-tree
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
   :init-config-tree
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
   ;; string
   :slugify
   :join-string-list-with-delim
   ;; pagination
   :paginate
   :pagination-markup
   ))

(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; global configs for use in this package
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; make sure these are initialized in every project
(defvar *home* "")
(defvar *translation-file-root* nil)
(defvar *db-init-ids* nil)
(defvar *save-photo-to-db-function* nil)
(defvar *pagination-limit* 10)
