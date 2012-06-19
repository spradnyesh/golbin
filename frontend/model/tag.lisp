(in-package :hawksbill.golbin.frontend)

(defclass tag ()
  ((name :initarg :name :initform nil :accessor name)
   (slug :initarg :slug :initform nil :accessor slug)))

(defclass tag-storage ()
  ((tags :initform nil :accessor tags))
  (:documentation "Object of this class will act as the storage for Tags"))

(defun add-tag (tag &optional (storage *tag-storage*))
  (setf (slug tag)
        (slugify (name tag)))
  (push tag (tags storage))
  tag)

(defun get-all-tags (&optional (storage *tag-storage*))
  (tags storage))
