(in-package :hawksbill.golbin.frontend)

(defclass category ()
  ((id :initarg :id :initform nil :accessor id)
   (name :initarg :name :initform nil :accessor name)
   (parent :initarg :parent :initform nil :accessor parent)
   (slug :initarg :slug :initform nil :accessor slug)))

(defclass category-storage ()
  ((categories :initform nil :accessor categories)
   (last-id :initform 0 :accessor last-id))
  (:documentation "Object of this class will act as the storage for Categories"))

(defun add-category (category &optional (storage *category-storage*))
  "add category 'category' to 'storage'"
  ;; set some params
  (setf (id category)
        (incf (last-id storage)))
  (setf (slug category)
        (slugify (name category)))

  ;; add to store
  (push category
        (categories storage))
  category)

(defun get-all-categories (&optional (storage *category-storage*))
  (categories storage))

(defun get-category-by-id (id &optional (storage *category-storage*))
  (find id
        (get-all-categories storage)
        :key 'id))

(defun get-category-by-slug (slug &optional (storage *category-storage*))
  (find slug
        (get-all-categories storage)
        :key 'slug
        :test #'string-equal))

(defun get-subcategories (cat-id &optional (storage *category-storage*))
  (sort
   (conditionally-accumulate (lambda (cat)
                               (= cat-id (parent cat)))
                             (get-all-categories storage))
   #'string<
   :key 'name))

(defun get-root-categories (&optional (storage *category-storage*))
  (get-subcategories 0 storage))

(defun get-category-tree (&optional (storage *category-storage*))
  (let ((rslt nil)
        (root (get-root-categories storage)))
    (dolist (r root)
      (push (list r (get-subcategories (id r) storage))
            rslt))
    (nreverse rslt)))
