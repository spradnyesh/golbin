(defpackage :hawksbill.utils
  (:use :cl :cl-who :cl-memcached :cl-ppcre :parenscript :restas :split-sequence :hunchentoot :kyoto-cabinet)
  (:shadowing-import-from :restas :redirect :acceptor :start)
  (:export
   :*home*
   :*db*
   ;; config
   :config-storage ; class
   :*config-storage*
   :*config* ; input to init-config-tree
   :*dimensions*
   :*current-dimensions-string*
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
   :db-connect
   :db-disconnect
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
;; make sure these are initialized in every project
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; init
(defvar *home* "")
(defparameter *db* (make-instance 'kc-dbm))
;; pagination
(defvar *pagination-limit* 10)
;; config
(defvar *dimensions* nil)
(defvar *config* nil)
(defvar *config-storage* nil)
(defvar *current-dimensions-string* nil)
