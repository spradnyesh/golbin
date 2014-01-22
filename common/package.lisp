(defpackage :hawksbill.golbin
  (:use :cl :restas :restas.directory-publisher :hawksbill.utils)
  (:shadowing-import-from :restas :route)
  (:export :*valid-envts*
           :*valid-langs*
           :*secrets*
           :populate-config-from-secret
           :push-to-secret
           :golbin-restart))

(defvar *valid-envts* nil)
(defvar *valid-langs* nil)
(defvar *secrets* nil)
