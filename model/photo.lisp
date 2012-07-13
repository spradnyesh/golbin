(in-package :hawksbill.golbin)

(defclass photo ()
  ((id :initarg :id :initform nil :accessor id)
   (title :initarg  :title :initform nil :accessor title)
   (typeof :initarg  :typeof :initform nil :accessor typeof) ; article, author, slideshow
   (orig-filename :initarg :orig-filename :initform nil :accessor orig-filename)
   (new-filename :initarg :new-filename :initform nil :accessor new-filename)
   (date :initarg :date :initform nil :accessor date)
   (tags :initarg :tags :initform nil :accessor tags)
   (author :initarg :author :initform nil :accessor author)))

(defclass photo-storage ()
  ((photos :initform nil :accessor photos)
   (last-id :initform 0 :accessor last-id)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; setters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun add-photo (photo)
  ;; set some photo params
  (setf (id photo)
        (execute *db* (make-transaction 'incf-photo-last-id)))
  (setf (date photo)
        (now))
  (set-mini-author photo)

  ;; save photo into storage
  (execute *db* (make-transaction 'insert-photo photo))

  photo)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; getters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro get-photos-by (cond)
  `(get-object-by ,cond (get-all-photos)))

(defun get-photos-by-author (author)
  (get-photos-by #'(lambda (photo)
                     (= (id author)
                        (id (author photo))))))

(defun get-photos-by-tag-slug (slug)
  (get-photos-by #'(lambda (photo)
                     (dolist (tag (tags photo))
                       (when (equal slug (slug tag))
                         (return t))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; needed for tmp-init
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun add-photos ()
  "add a new photos to the db"
  )
