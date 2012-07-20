(in-package :hawksbill.utils)

(defgeneric model-init ()
  (:documentation "dummy function so that the below macro will work correctly"))

(defun destroy-system ()
  (stop-all)
  (db-disconnect))
