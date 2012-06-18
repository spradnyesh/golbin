(restas:define-module :hawksbill.golbin.frontend
  (:use :cl :cl-who :local-time :cl-ppcre :hawksbill.utils :restas :parenscript :json)
  (:shadowing-import-from :json :prototype)
  (:export :route-home
           :route-home-page
           :route-cat
           :route-cat-page
           :route-cat-subcat
           :route-cat-subcat-page
           :route-author
           :route-author-page
           :route-tag
           :route-tag-page
           :route-article
           :route-search))

(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; parameters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defparameter *site-name* "Golbin")
(defparameter *article-pagination-range* 10)
(defparameter *article-pagination-limit* 10)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar *static-path* nil)
(defvar *nav-cat-json* nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; storages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar *db-storage* nil)
(defvar *article-storage* nil)
(defvar *category-storage* nil)
(defvar *view-storage* nil)
(defvar *count-storage* nil)
(defvar *tag-storage* nil)
(defvar *categories* nil)
(defvar *author-storage* nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setf *dimensions* '("envt" "intl" "lang"))
(setf *valid-envts* '("dev" "prod"))
(setf *valid-intls* '("IN"))
(setf *valid-langs* '("en-IN"))
(setf *default-envt* "dev")
(setf *default-intl* "IN")
(setf *default-lang* "en-IN")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; debugging
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setf hunchentoot:*show-lisp-errors-p* t)
(setf hunchentoot:*show-lisp-backtraces-p* t)