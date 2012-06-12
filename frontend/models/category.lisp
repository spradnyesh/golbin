(in-package :hawksbill.golbin.frontend)

(defclass category ()
  ((id :initarg :id :initform nil :accessor id)
   (name :initarg :name :initform nil :accessor name)
   (status :initarg :status :initform nil :accessor status
           :documentation "nil/t => dis/en-able; to be able to hide certain cat/subcat from navigation")
   (parent :initarg :parent :initform nil :accessor parent)))

(defclass category-storage ()
  ((categories :initform nil)
   (last-id :initform 0))
  (:documentation "Object of this class will act as the storage for Categories"))

(defun get-category-by-name (category-name &optional (storage *category-storage*))
  (find category-name
        (slot-value storage 'categories)
        :key 'name
        :test #'string-equal))

(defun add-category (category &optional (storage *category-storage*))
  "add category 'category' to 'storage'"
  ;; set id
  (let ((id (setf (slot-value category 'id)
                  (incf (slot-value storage 'last-id)))))
    ;; add to store
    (push category
          (slot-value storage 'categories))
    id))

(defun get-root-categories (&optional (storage *category-storage*))
  (sort
   (conditional-accumulate (lambda (cat)
                             (null (parent cat)))
                           (slot-value storage 'categories))
   #'string<
   :key 'name))
