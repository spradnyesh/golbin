(restas:define-module :hawksbill.golbin.frontend
  (:use :cl :cl-who :local-time :cl-ppcre :hawksbill.utils)
  (:export :route-home
           :route-home-page
           :route-cat
           :route-cat-subcat
           :route-article
           :route-home
           :route-author
           :route-tag
           :route-search))

(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; parameters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defparameter *site-name* "Golbin")
(defparameter *article-pagination-range* 10)
(defparameter *article-pagination-limit* 10)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; storages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar *article-storage* nil)
(defvar *category-storage* nil)
(defvar *view-storage* nil)
(defvar *tag-storage* nil)
(defvar *categories* nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; debugging
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setf hunchentoot:*show-lisp-errors-p* t)
(setf hunchentoot:*show-lisp-backtraces-p* t)
