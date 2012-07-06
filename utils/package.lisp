(defpackage :hawksbill.utils
  (:use :cl :cl-who :cl-memcached :cl-ppcre :parenscript :restas :split-sequence :hunchentoot :cl-prevalence :cl-gd :ironclad)
  (:shadow :acceptor :mime-type :size :null)
  (:shadowing-import-from :restas :redirect :start)
  (:export :*home*
           ;; init
           :*system-status*
           :start/stop/restart-system
           :destroy-system
           :model-init
           ;; db
           :*db*
           ;; config
           :config-storage              ; class
           :*config*                    ; input to init-config-tree
           :*dimensions*
           :*current-dimensions-string*
           :get-config
           :add-config
           :show-config-tree
           :init-config-tree
           :init-config
           ;; html
           :with-html
           :js-script
           :hu-init
           ;; db
           :get-storage
           :init-db-system
           :get-object-by
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
           :pagination-markup))

(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; global configs for use in this package
;; make sure these are initialized in every project
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar *home* "")
;; init
(defvar *system-status* nil)
;; db
(defparameter *db* nil)
;; pagination
(defvar *pagination-limit* 10)
;; config
(defvar *dimensions* nil)
(defvar *config* nil)
(defvar *config-storage* nil)
(defvar *current-dimensions-string* nil)
