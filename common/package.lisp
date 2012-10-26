(defpackage :hawksbill.golbin
  (:use :cl :restas :restas.directory-publisher :hawksbill.utils)
  (:shadowing-import-from :restas :route)
  (:export :*valid-envts*
           :*valid-langs*))

(defvar *valid-envts* nil)
(defvar *valid-langs* nil)
