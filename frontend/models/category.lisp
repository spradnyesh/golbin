(in-package :hawksbill.golbin.frontend)

(defclass category ()
  ((id :initarg :id :initform nil :accessor id)
   (name :initarg :name :initform nil :accessor name)
   (status :initarg :status :initform nil :accessor status
           :documentation "nil/t => dis/en-able; to be able to hide certain cat/subcat from navigation")
   (parent :initarg :parent :initform nil :accessor parent)))

(defclass category-storage ()
  ((categories :initform nil :accessor categories)
   (last-id :initform 0 :accessor last-id))
  (:documentation "Object of this class will act as the storage for Categories"))

(defmacro get-all-categories ()
  `(categories storage))

(defun get-category-by-name (category-name &optional (storage *category-storage*))
  (find category-name
        (get-all-categories)
        :key 'name
        :test #'string-equal))

(defun add-category (category &optional (storage *category-storage*))
  "add category 'category' to 'storage'"
  ;; set id
  (let ((id (setf (id category)
                  (incf (last-id storage)))))
    ;; add to store
    (push category
          (get-all-categories))
    id))

(defun get-root-categories (&optional (storage *category-storage*))
  (sort
   (conditionally-accumulate (lambda (cat)
                               (null (parent cat)))
                             (get-all-categories))
   #'string<
   :key 'name))

(defun get-subcategories (cat-id &optional (storage *category-storage*))
  (sort
   (conditionally-accumulate (lambda (cat)
                               (= cat-id (parent cat)))
                             (get-all-categories))
   #'string<
   :key 'name))
