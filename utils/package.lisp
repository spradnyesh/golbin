(defpackage :hawksbill.utils
  (:use :cl :sexml :cl-memcached :cl-ppcre :parenscript :restas :split-sequence :hunchentoot :cl-prevalence :cl-gd :ironclad :local-time :flexi-streams :trivial-utf-8 :cl-smtp :json :trivial-timeout :eager-future2)
  (:shadow :mime-type :size :prototype)
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
           :h-genurl
           :h-gen-full-url
           :m-404
           ;; dimensions
           :*resources*
           :init-dimensions
           :hawksbill-acceptor
           :show-resources
           :get-dimension-value
           ;; config
           :*config*
           :*dimensions*
           :*default-dimensions*
           :*dimensions-combos*
           :config-storage
           :get-config
           :add-config
           :show-config-tree
           :init-config
           :set-default-dimensions
           ;; html
           :with-html
           :tr-td-input
           :tr-td-text
           :tr-td-submit
           :label-input
           :tooltip
           :click-here
           :timed-redirect
           :submit-success
           :submit-error
           :cannot-be-empty
           :validate-email
           ;; ckeditor
           :ck-js
           :cleanup-ckeditor-text
           ;; http
           :hu-init
           :logout
           :web-archive
           ;; js
           :obfuscate-js
           :$event
           :$apply
           :$prevent-default
           :$log
           :$ajax-form
           :$pane
           ;; db
           :init-db-system
           :get-object-by
           :db-connect
           :db-disconnect
           :db-reconnect
           :get-db-handle
           ;; memcache
           :with-cache
           ;; list
           :conditionally-accumulate
           :replace-all
           :insert-at
           :splice
           :get-random-from-list
           :subset
           :print-map
           :push-map
           :make-set
           :group-list
           :range
           ;; string
           :slugify
           :join-string-list-with-delim
           :split-string-by-delim
           :nil-or-empty
           :make-keyword
           :string-pad
           :fmtnil
           :string-to-utf-8
           :join-loop
           :get-random-string
           :is-null-or-empty
           ;; pagination
           :paginate
           :pagination-markup
           ;; photo
           :save-photo-to-disk
           :scale-and-save-photo
           :build-sized-image
           :build-gravtar-image
           ;; file
           :get-directory-path-string
           ;; datetime
           :prettyprint-date
           :prettyprint-time
           ;; lang
           :*translation-table*
           :translate
           :load-all-languages
           :show-translation-tree
           :lang-a
           :logo-langs
           ;; cipher
           :md5-hash
           :sha256-hash
           :do-encrypt
           :do-decrypt
           :insecure-encrypt
           :insecure-decrypt
           :generate-salt
           ;; token-card
           :create-code-map
           :create-code-map-image
           ;; email
           :sendmail
           ;; misc
           :build-gravtar-image
           ;; ads
           :ads-markup
           :insert-inline-ads
           :remove-inline-ads))

(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; global configs for use in this package
;; make sure these are initialized in every project
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar *home* "")
;; init
(defvar *system-status* nil) ; whether system has been initialized or not
;; config
(defvar *dimensions* nil)
(defvar *dimensions-combos* nil)
(defvar *default-dimensions* nil)
(defvar *config* nil)
(defvar *config-storage* nil)
;; dimensions
(defvar *resources* (make-hash-table :test 'equal)) ; hashmap of all resources (eg db, etc) initialized during system-start
;; lang
(defvar *translation-table* nil)

;; http://common-lisp.net/project/parenscript/tutorial.html
(setf *js-string-delimiter* #\")

(sexml:with-compiletime-active-layers
      (sexml:standard-sexml sexml:xml-doctype)
    (sexml:support-dtd
     (merge-pathnames "html5.dtd" (asdf:system-source-directory "sexml"))
     :<))
