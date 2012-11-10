(in-package :hawksbill.golbin.model)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; classes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defclass category ()
  ((id :initarg :id :initform nil :accessor id)
   (name :initarg :name :initform nil :accessor name)
   (parent :initarg :parent :initform nil :accessor parent)
   (slug :initarg :slug :initform nil :accessor slug)
   (rank :initarg :rank :initform nil :accessor rank)
   (active :initarg :active :initform nil :accessor active))) ; y/n

(defclass category-storage ()
  ((categorys :initform nil :accessor categorys)
   (last-id :initform 0 :accessor last-id))
  (:documentation "Object of this class will act as the storage for Categories"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; setters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun add-category (category)
  ;; set some params
  (setf (id category)
        (execute (get-db-handle) (make-transaction 'incf-category-last-id)))
  (setf (slug category)
        (slugify (name category)))

  ;; add to store
  (execute (get-db-handle) (make-transaction 'insert-category category))

  category)

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
  (sort (conditionally-accumulate (lambda (cat)
                                    (= cat-id (parent cat)))
                                  (get-all-categorys))
        #'<
        :key 'id))

(defun get-root-categorys ()
  (get-subcategorys 0))

(defun get-category-tree ()
  (let ((rslt nil)
        (root (get-root-categorys)))
    (dolist (r root)
      (push (list r (get-subcategorys (id r)))
            rslt))
    (nreverse rslt)))

;; XXX: needs cache (no key needed)
(defun get-category-tree-json ()
  (encode-json-to-string (get-category-tree)))

(defun get-home-page-categories (number)
  (declare (ignore number))
  (let ((rslt nil))
    (push (get-category-by-slug "business") rslt)
    (push (get-category-by-slug "entertainment") rslt)
    (push (get-category-by-slug "lifestyle") rslt)
    (push (get-category-by-slug "science") rslt)
    (push (get-category-by-slug "technology") rslt)
    rslt))
