(in-package :hawksbill.golbin.frontend)

(defclass tag ()
  ((name :initarg :name :initform nil :accessor name)
   (slug :initarg :slug :initform nil :accessor slug)))

(defclass tag-storage ()
  ((tags :initform nil :accessor tags))
  (:documentation "Object of this class will act as the storage for Tags"))

(defun insert-tag (system tag)
  (let ((tags (get-root-object system :tags)))
    (push tag (tags tags))))

(defun add-tag (tag)
  (setf (slug tag)
        (slugify (name tag)))
    ;; save tag into storage

  (execute *db* (make-transaction 'insert-tag tag))

    ;; TODO: sort tags in storage
    #|(setf (tags storage) (sort (tags storage) #'string< :key #'name))|#
  tag)

(defun get-all-tags ()
  (let ((storage (get-storage :tags)))
    (tags storage)))

(defun get-tag-by-slug (slug)
  (find slug
        (get-all-tags)
        :test #'string-equal
        :key #'slug))
