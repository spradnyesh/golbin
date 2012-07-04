(restas:define-module :hawksbill.golbin.frontend
  (:use :cl :cl-who :cl-ppcre :hawksbill.utils :hawksbill.golbin.model :restas :parenscript :json :split-sequence :css-lite)
  (:shadow :% :prototype :size)
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
(setf hawksbill.utils:*home*
      (make-pathname :directory
                     (butlast (pathname-directory
                               (load-time-value
                                (or #.*compile-file-pathname* *load-pathname*))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; storages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar *config* nil)
(defvar *article-storage* nil)
(defvar *author-storage* nil)
(defvar *category-storage* nil)
(defvar *tag-storage* nil)
#|(defvar *view-storage* nil)|#
#|(defvar *count-storage* nil)|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; debugging
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setf hunchentoot:*show-lisp-errors-p* t)
(setf hunchentoot:*show-lisp-backtraces-p* t)
