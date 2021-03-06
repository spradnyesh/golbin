(in-package :hawksbill.golbin.model)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; classes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defclass category ()
  ((id :initarg :id :initform nil :accessor id)
   (name :initarg :name :initform nil :accessor name)
   (parent :initarg :parent :initform nil :accessor parent)
   (slug :initarg :slug :initform nil :accessor slug)
   (rank :initarg :rank :initform nil :accessor rank))) ; order of placement in nav/subnav

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
        (db-execute 'incf-category-last-id))
  (setf (slug category)
        (slugify (name category)))

  ;; add to store
  (db-execute 'insert-category category)

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
        :key #'(lambda (cat)
                 (abs (rank cat)))))

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
    (push (get-category-by-slug "editorial") rslt)
    (push (get-category-by-slug "business") rslt)
    (push (get-category-by-slug "entertainment") rslt)
    (push (get-category-by-slug "lifestyle") rslt)
    (push (get-category-by-slug "science") rslt)
    (push (get-category-by-slug "technology") rslt)
    rslt))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; needed for init
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun add-cat/subcat ()
  (let ((i 1))
    (dolist (cs (get-config "categorys"))
      (let* ((cat-name (first cs))
             (subcats (rest cs))
             (cat (add-category (make-instance 'category
                                               :name cat-name
                                               :parent 0
                                               :rank i))))
        (add-category (make-instance 'category
                                     :name "--" ; empty sub-category
                                     :parent (id cat)
                                     :rank (+ i (/ 1 10.0))))
        (let ((j 1))
          (dolist (sc-name subcats)
            (add-category (make-instance 'category
                                         :name sc-name
                                         :parent (id cat)
                                         :rank (+ i (/ j 10.0))))
            (incf j)))
        (incf i)))))

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
