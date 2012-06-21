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
  (setf (tags storage) (sort (tags storage) #'string< :key #'name))
  tag)

(defun get-all-tags (&optional (storage *tag-storage*))
  (tags storage))

(defun get-tag-by-slug (slug &optional (storage *tag-storage*))
  (find slug
        (get-all-tags storage)
        :test #'string-equal
        :key #'slug))
