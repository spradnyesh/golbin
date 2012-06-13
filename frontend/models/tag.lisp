(in-package :hawksbill.golbin.frontend)

(defclass tag ()
  ((name :initarg :name :initform nil :accessor name)))

(defclass tag-storage ()
  ((tags :initform nil :accessor tags))
  (:documentation "Object of this class will act as the storage for Tags"))

(defun add-tag (tag &optional storage *tag-storage*)
  (push tag (tags storage))
  tag)
(defun get-all-tags (&optional storage *tag-storage*)
  (sort (tags storage)
        #'string<
        :key 'name))
