(in-package :hawksbill.utils)

(defgeneric model-init (dimension)
  (:documentation "dummy function so that the below macro will work correctly"))

(defun destroy-system ()
  (stop-all)
  (db-disconnect))
