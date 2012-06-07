(restas:define-module :hawksbill.golbin.frontend
  (:use :cl :restas :cl-who :local-time))

(in-package :hawksbill.golbin.frontend)

(defvar *article-storage* nil)
(defvar *article-pagination-limit* 10)
