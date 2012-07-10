(restas:define-module :hawksbill.golbin
  (:use :cl :hawksbill.utils :cl-who :cl-ppcre :cl-prevalence :local-time :split-sequence :restas :parenscript :json :split-sequence :css-lite :hunchentoot)
  (:shadow :% :prototype :size :acceptor :mime-type)
  (:shadowing-import-from :restas :redirect :start)
  (:export :fe-r-home
           :fe-r-home-page
           :fe-r-cat
           :fe-r-cat-page
           :fe-r-cat-subcat
           :fe-r-cat-subcat-page
           :fe-r-author
           :fe-r-author-page
           :fe-r-tag
           :fe-r-tag-page
           :fe-r-article
           :fe-r-search
           :ed-r-login-get
           :ed-r-login-post
           :ed-r-photo-get
           :ed-r-photo-post))

(in-package :hawksbill.golbin)

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
                     (pathname-directory
                                (load-time-value
                                 (or #.*compile-file-pathname* *load-pathname*)))))

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
;; default routes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(mount-submodule -static- (#:restas.directory-publisher)
  (restas.directory-publisher:*baseurl* '("static"))
  (restas.directory-publisher:*directory* (merge-pathnames "../data/static/" *home*)))
