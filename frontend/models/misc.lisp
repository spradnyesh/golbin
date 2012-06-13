(in-package :hawksbill.golbin.frontend)

(defclass view-storage ()
  ((views :initform nil :accessor views)
   (last-id :initform 0 :accessor last-id))
  (:documentation "Object of this class will act as the storage for Views"))

(defclass tag-storage ()
  ((tags :initform nil :accessor tags)
   (last-id :initform 0 :accessor last-id))
  (:documentation "Object of this class will act as the storage for Tags"))

(defun most-viewed-category ())
