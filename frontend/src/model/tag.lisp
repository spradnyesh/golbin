(in-package :hawksbill.golbin.frontend)

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
(defun add-tag (tag)
  (setf (slug tag)
        (slugify (name tag)))
    ;; save tag into storage

  (execute *db* (make-transaction 'insert-tag tag))

    ;; TODO: sort tags in storage
    #|(setf (tags storage) (sort (tags storage) #'string< :key #'name))|#
  tag)

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
      (add-tag (make-instance 'tag :name tag)))))
