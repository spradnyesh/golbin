(in-package :hawksbill.golbin.model)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; classes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defclass comment ()
  ((id :initarg :id :initform nil :accessor id)
   (parent :initarg :parent :initform nil :accessor parent)
   (body :initarg :body :initform nil :accessor body)
   (date :initarg :date :initform nil :accessor date) ; actually timestamp
   (status :initarg :status :initform nil :accessor status) ; :a active, :d deleted
   (article-id :initarg :article-id :initform nil :accessor article-id)
   ;; below fields are needed for akismet/spam
   (username :initarg :username :initform nil :accessor username)
   (useremail :initarg :useremail :initform nil :accessor useremail)
   (userurl :initarg :userurl :initform nil :accessor userurl)
   (userip :initarg :userip :initform nil :accessor userip)
   (useragent :initarg :useragent :initform nil :accessor useragent)))

(defclass comment-storage ()
  ((comments :initform nil :accessor comments)
   (last-id :initform 0 :accessor last-id))
  (:documentation "Object of this class will act as the storage for Comments"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; getters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-comments (article-id)
  (get-object-by #'(lambda (comment)
                     (= (article-id comment)
                        article-id))
                 (get-all-comments)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; setters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun add-comment (comment)
  (when comment
    ;; set some comment params
    (setf (id comment)
          (db-execute 'incf-comment-last-id))

    ;; save comment into storage
    (db-execute 'insert-comment comment)

    comment))
