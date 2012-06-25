(in-package :hawksbill.golbin.frontend)

(defclass category ()
  ((id :initarg :id :initform nil :accessor id)
   (name :initarg :name :initform nil :accessor name)
   (parent :initarg :parent :initform nil :accessor parent)
   (slug :initarg :slug :initform nil :accessor slug)))

(defclass category-storage ()
  ((categorys :initform nil :accessor categorys)
   (last-id :initform 0 :accessor last-id))
  (:documentation "Object of this class will act as the storage for Categories"))

(defun insert-category (system category)
  (let ((categorys (get-root-object system :categorys)))
    (push category (categorys categorys))))

(defun add-category (category)
  (let ((storage (get-storage :categorys)))
    "add category 'category' to 'storage'"
    ;; set some params
    (setf (id category)
          (incf (last-id storage)))
    (setf (slug category)
          (slugify (name category)))

    ;; add to store
    (execute *db* (make-transaction 'insert-category category))

    category))

(defun add-cat/subcat (&optional (config-storage *config-storage*))
  (dolist (cs (get-config "categorys" "master" config-storage))
    (let* ((cat-name (first cs))
           (subcats (rest cs))
           (cat (add-category (make-instance 'category
                                             :name cat-name
                                             :parent 0))))
      (dolist (sc-name subcats)
        (add-category (make-instance 'category
                                     :name sc-name
                                     :parent (id cat)))))))

(defun get-all-categorys (&optional (storage *category-storage*))
  (categorys storage))

(defun get-category-by-id (id &optional (storage *category-storage*))
  (find id
        (get-all-categorys storage)
        :key 'id))

(defun get-category-by-slug (slug &optional (parent-id 0) (storage *category-storage*))
  (find slug
        (if (zerop parent-id)
            (get-root-categorys storage)
            (get-subcategorys parent-id storage))
        :key #'slug
        :test #'string-equal))

(defun get-subcategorys (cat-id &optional (storage *category-storage*))
  (conditionally-accumulate (lambda (cat)
                               (= cat-id (parent cat)))
                             (get-all-categorys storage)))

(defun get-root-categorys (&optional (storage *category-storage*))
  (get-subcategorys 0 storage))

(defun get-category-tree (&optional (storage *category-storage*))
  (let ((rslt nil)
        (root (get-root-categorys storage)))
    (dolist (r root)
      (push (list r (get-subcategorys (id r) storage))
            rslt))
    (nreverse rslt)))
