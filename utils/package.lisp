(defpackage :hawksbill.utils
  (:use :cl :cl-who :cl-memcached :cl-ppcre :parenscript :restas :split-sequence :hunchentoot :cl-prevalence :cl-gd :ironclad)
  (:shadow :mime-type :size)
  (:shadowing-import-from :restas :redirect :start)
  (:shadowing-import-from :cl :null)
  (:export :*home*
           ;; init
           :destroy-system
           :model-init
           ;; restas
           :*system-status*
           :start/stop/restart-system
           :with-login
           :is-logged-in?
           ;; dimensions
           :init-dimensions
           :hawksbill-acceptor
           ;:hawksbill-request
           ;; config
           :config-storage
           :*config*
           :*dimensions*
           :*current-dimensions-string*
           :get-config
           :add-config
           :show-config-tree
           :init-config-tree
           :init-config
           ;; html
           :with-html
           :tr-td-input
           :tr-td-text
           :hu-init
           ;; js
           :js-script
           :obfuscate-js
           :$event
           :$apply
           :$prevent-default
           ;; db
           :*db*
           :get-storage
           :init-db-system
           :get-object-by
           :db-connect
           :db-disconnect
           :db-reconnect
           ;; memcache
           :with-cache
           ;; list
           :conditionally-accumulate
           :replace-all
           :insert-at
           :splice
           :get-random-from-list
           :subset
           ;; string
           :slugify
           :join-string-list-with-delim
           :split-string-by-delim
           :nil-or-empty
           ;; pagination
           :paginate
           :pagination-markup
           ;; photo
           :save-photo-to-disk
           :scale-and-save-photo
           ;; file
           :get-parent-directory-path-string
           ;; translate
           :*translation-table*
           :translate
           :load-all-languages
           :show-translation-tree))

(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; global configs for use in this package
;; make sure these are initialized in every project
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar *home* "")
;; init
(defvar *system-status* nil)
;; db
(defvar *db* nil)
;; config
(defvar *dimensions* nil)
(defvar *config* nil)
(defvar *config-storage* nil)
(defvar *current-dimensions-string* nil)
;; translate
(defvar *translation-table*)
(defvar *lang*) ; this needs to be thread safe (http://www.sbcl.org/manual/Special-Variables.html)
(defvar *envt*) ; this needs to be thread safe (http://www.sbcl.org/manual/Special-Variables.html)

;; http://common-lisp.net/project/parenscript/tutorial.html
(setf *js-string-delimiter* #\")
