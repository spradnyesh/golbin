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
  (dotimes (i 1000)
    (multiple-value-bind (cat subcat) (get-random-cat-subcat)
      (add-article (make-instance 'article
                                  :title (format nil "title  of $ % ^ * the ~Ath article" (1+ i))
                                  :summary (format nil "~A: There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain... --http://lipsum.com/" (1+ i))
                                  :tags (list (get-random-tag) (get-random-tag))
                                  :body (format nil "~A: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.

It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)." (1+ i))
                                  :cat cat
                                  :subcat subcat
                                  :status (let ((r (random 4)))
                                            (cond ((zerop r) :d)
                                                  ((= 1 r) :s)
                                                  ((= 2 r) :a)
                                                  ((= 3 r) :w))))))))
