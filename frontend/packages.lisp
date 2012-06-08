(restas:define-module :hawksbill.golbin.frontend
  (:use :cl :cl-who :local-time :cl-ppcre)
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

(defvar *article-storage* nil)
(defvar *article-pagination-limit* 10)
(defvar *category-storage* nil)
(defvar *view-storage* nil)
(defvar *tag-storage* nil)
(defvar *categories* nil)

(setf hunchentoot:*show-lisp-errors-p* t)
(setf hunchentoot:*show-lisp-backtraces-p* t)
