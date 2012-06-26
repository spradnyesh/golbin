(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; classes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defclass category ()
  ((id :initarg :id :initform nil :accessor id)
   (name :initarg :name :initform nil :accessor name)
   (parent :initarg :parent :initform nil :accessor parent)
   (slug :initarg :slug :initform nil :accessor slug)))

(defclass category-storage ()
  ((categorys :initform nil :accessor categorys)
   (last-id :initform 0 :accessor last-id))
  (:documentation "Object of this class will act as the storage for Categories"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; setters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun add-category (category)
  (let ((storage (get-storage :categorys)))
    ;; set some params
    (setf (id category)
          (incf (last-id storage)))
    (setf (slug category)
          (slugify (name category)))

    ;; add to store
    (execute *db* (make-transaction 'insert-category category))

    category))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; needed for init
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; getters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-category-by-slug (slug &optional (parent-id 0))
  (find slug
        (if (zerop parent-id)
            (get-root-categorys)
            (get-subcategorys parent-id))
        :key #'slug
        :test #'string-equal))

(defun get-subcategorys (cat-id)
  (conditionally-accumulate (lambda (cat)
                               (= cat-id (parent cat)))
                             (get-all-categorys)))

(defun get-root-categorys ()
  (get-subcategorys 0))

(defun get-category-tree ()
  (let ((rslt nil)
        (root (get-root-categorys)))
    (dolist (r root)
      (push (list r (get-subcategorys (id r)))
            rslt))
    (nreverse rslt)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; needed for tmp-init
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-random-cat-subcat ()
  (let* ((all-categories (get-root-categorys))
         (random-category (nth (random (length all-categories)) all-categories))
         (all-subcategories (get-subcategorys (id random-category))))
    (if all-subcategories
        (values random-category (nth (random (length all-subcategories)) all-subcategories))
        (get-random-cat-subcat))))
