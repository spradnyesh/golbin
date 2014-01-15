(in-package :hawksbill.golbin.model)

(defclass photo ()
  ((id :initarg :id :initform nil :accessor id)
   (title :initarg  :title :initform nil :accessor title)
   (typeof :initarg  :typeof :initform nil :accessor typeof) ; :a article, :u author, :s slideshow
   (orig-filename :initarg :orig-filename :initform nil :accessor orig-filename)
   (new-filename :initarg :new-filename :initform nil :accessor new-filename)
   (date :initarg :date :initform nil :accessor date)
   (cat :initarg :cat :initform nil :accessor cat)
   (subcat :initarg :subcat :initform nil :accessor subcat)
   (tags :initarg :tags :initform nil :accessor tags)
   (author :initarg :author :initform nil :accessor author)
   (attribution :initarg :attribution :initform nil :accessor attribution)))

(defclass mini-photo ()
  ((id :initarg :id :initform nil :accessor id)
   (title :initarg :title :initform nil :accessor title)
   (new-filename :initarg :new-filename :initform nil :accessor new-filename)
   (attribution :initarg :attribution :initform nil :accessor attribution))
  (:documentation "to be used as a foreign key in articles/authors"))

(defclass photo-storage ()
  ((photos :initform nil :accessor photos)
   (last-id :initform 0 :accessor last-id)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro sp ()
  `(scale-and-save-photo (make-pathname :directory
                                        (append (pathname-directory (get-config "path.uploads")) '("photos")))
                         (get-config "path.photos")
                         (new-filename photo)
                         size))

;; TODO: find a way to get the config names automatically from config-tree instead of hardcoding them below. the drawback w/ the below is that everytime a new photo config gets added to config-tree, it'll have to be added here too.
(defun scale-photo (photo)
  ;; XXX: need to use `+, below, instead of ' in order for the get-config to execute before getting assigned to *-sizes
  (let ((article-sizes `(,(get-config "photo.article-lead.block")
                          ,(get-config "photo.article-lead.side")
                          ,(get-config "photo.article-lead.index-thumb")
                          ,(get-config "photo.article-lead.related-thumb")))
        (author-sizes `(,(get-config "photo.author.article-logo")
                         ,(get-config "photo.author.avatar")))
        (typeof (typeof photo)))
    (cond ((eql :a typeof)
           (dolist (size article-sizes) (sp)))
          ((eql :u typeof)
           (dolist (size author-sizes) (sp))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; setters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun add-photo (photo)
  ;; set some photo params
  (setf (id photo)
        (execute (get-db-handle) (make-transaction 'incf-photo-last-id)))
  (setf (date photo)
        (get-universal-time))
  (setf (author photo) (get-mini-author))

  ;; save photo into storage
  (execute (get-db-handle) (make-transaction 'insert-photo photo))

  (scale-photo photo)

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

(defun get-mini-photo (photo)
  (make-instance 'mini-photo
                 :id (id photo)
                 :title (title photo)
                 :new-filename (new-filename photo)
                 :attribution (attribution photo)))

(defun find-photo-by-new-filename (filename)
  (find filename (get-all-photos) :key #'new-filename :test #'string-equal))

(defun find-photo-by-img-tag (img-tag)
  (multiple-value-bind (match registers)
      (scan-to-strings "<img.*?src=\\\"\/static\/photos\/(.+?)_.+?x.+?\\\.(.+?)\\\".*?\/>" img-tag)
    (declare (ignore match))
    (when registers
      (find-photo-by-new-filename (concatenate 'string
                                               (aref registers 0)
                                               "."
                                               (aref registers 1))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; needed for resize photos cron
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun scale-photos ()
  (dolist (photo (get-all-photos))
    (scale-photo photo)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; needed for tmp-init
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-random-photo (typeof)
  (let* ((photos (get-photos-by #'(lambda (photo)
                                    (eql typeof (typeof photo)))))
         (photo (nth (random (length photos)) photos)))
    (make-instance 'mini-photo
                   :id (id photo)
                   :title (title photo)
                   :filename (new-filename photo))))
