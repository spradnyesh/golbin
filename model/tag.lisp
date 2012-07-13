(in-package :hawksbill.golbin)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; classes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defclass tag ()
  ((name :initarg :name :initform nil :accessor name)
   (slug :initarg :slug :initform nil :accessor slug)))

(defclass tag-storage ()
  ((tags :initform nil :accessor tags))
  (:documentation "Object of this class will act as the storage for Tags"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; setters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun add-tag (name)
  (let* ((name (string-trim " " name))
		 (slug (slugify name))
		 (new-tag (make-instance 'tag :name name :slug slug))
		 (existing-tag (get-tag-by-slug slug)))
	;; save tag into storage only if it does not already exist
	(if existing-tag
		existing-tag
		(progn
		  (execute *db* (make-transaction 'insert-tag new-tag))
		  new-tag))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; getters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-tag-by-slug (slug)
  (find slug
        (get-all-tags)
        :test #'string-equal
        :key #'slug))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; needed for tmp-init
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-random-tag ()
  (let ((all-tags (get-all-tags)))
    (nth (random (length all-tags)) all-tags)))

(defun add-tags ()
  (let ((tags "1500s 1960s aldus been book centuries containing desktop dummy electronic essentially ever five galley including industry industrys into ipsum leap letraset like lorem make more only pagemaker passages popularised printer printing publishing recently release remaining scrambled sheets simply since software specimen standard survived text took type typesetting unchanged unknown versions when with"))
    (dolist (tag (split-sequence " " tags :test #'string-equal))
      (add-tag tag))))
