(restas:define-module :hawksbill.golbin.frontend
  (:use :cl :cl-who :local-time)
  (:export :route-home
		   :route-home-page
		   :route-cat
		   :route-cat-subcat
		   :route-article
		   :route-home
		   :route-author
		   :route-tag))

(in-package :hawksbill.golbin.frontend)

(defvar *article-storage* nil)
(defvar *article-pagination-limit* 10)

(setf hunchentoot:*show-lisp-errors-p* t)
(setf hunchentoot:*show-lisp-backtraces-p* t)
#|(restas:stop-all)|#
#|(restas:start :hawksbill.golbin.frontend :port 8000)|#
