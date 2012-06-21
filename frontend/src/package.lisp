(restas:define-module :hawksbill.golbin.frontend
  (:use :cl :cl-who :local-time :cl-ppcre :hawksbill.utils :restas :parenscript :json :split-sequence :css-lite :kyoto-cabinet)
  (:shadowing-import-from :json :prototype)
  (:shadow :%)
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
(setf *home*
      (make-pathname :directory
                     (butlast (pathname-directory
                               (load-time-value
                                (or #.*compile-file-pathname* *load-pathname*))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; storages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar *db-storage* nil)
(defvar *article-storage* nil)
(defvar *view-storage* nil)
(defvar *count-storage* nil)
(defvar *tag-storage* nil)
(defvar *categories* nil)
(defvar *author-storage* nil)
(defvar *category-storage* nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setf *dimensions* '("envt"))
(defvar *valid-envts* '("dev" "prod"))
(setf *current-dimensions-string* "envt:dev") ; TODO: need to set this dynamically for every request (thread safe)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; debugging
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setf hunchentoot:*show-lisp-errors-p* t)
(setf hunchentoot:*show-lisp-backtraces-p* t)