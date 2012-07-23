(in-package :hawksbill.golbin)

(defclass photo ()
  ((id :initarg :id :initform nil :accessor id)
   (title :initarg  :title :initform nil :accessor title)
   (typeof :initarg  :typeof :initform nil :accessor typeof) ; :a article, :u author, :s slideshow
   (orig-filename :initarg :orig-filename :initform nil :accessor orig-filename)
   (new-filename :initarg :new-filename :initform nil :accessor new-filename)
   (date :initarg :date :initform nil :accessor date)
   (tags :initarg :tags :initform nil :accessor tags)
   (author :initarg :author :initform nil :accessor author)))

(defclass mini-photo ()
  ((id :initarg :id :initform nil :accessor id)
   (title :initarg :title :initform nil :accessor title)
   (filename :initarg :filename :initform nil :accessor filename))
  (:documentation "to be used as a foreign key in articles/authors"))

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
;; needed for resize photos cron
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro sp ()
  `(scale-photo (make-pathname :directory
                               (append (pathname-directory (get-config "path.uploads")) '("photos")))
                (get-config "path.photos")
                (new-filename photo)
                (first size)
                (second size)))

;; TODO: find a way to get the config names automatically from config-tree instead of hardcoding them below. the drawback w/ the below is that everytime a new photo config gets added to config-tree, it'll have to be added here too.
(defun scale-photos ()
  ;; XXX: need to use `+, below, instead of ' in order for the get-config to execute before getting assigned to *-sizes
  (let ((article-sizes `((,(get-config "photo.article-lead.block.max-width")
                           ,(get-config "photo.article-lead.block.max-height"))
                         (,(get-config "photo.article-lead.left.max-width")
                           ,(get-config "photo.article-lead.left.max-height"))
                         (,(get-config "photo.article-lead.right.max-width")
                           ,(get-config "photo.article-lead.right.max-height"))))
        (author-sizes `((,(get-config "photo.author.article-logo.max-width")
                          ,(get-config "photo.author.article-logo.max-height"))
                        (,(get-config "photo.author.avatar.max-width")
                          ,(get-config "photo.author.avatar.max-height")))))
    (dolist (photo (get-all-photos))
      (let ((typeof (typeof photo)))
        (cond ((eql :a typeof)
               (dolist (size article-sizes) (sp)))
              ((eql :u typeof)
               (dolist (size author-sizes) (sp))))))))

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