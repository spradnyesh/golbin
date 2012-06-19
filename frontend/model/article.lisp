(in-package :hawksbill.golbin.frontend)

(defclass article ()
  ((id :initarg :id :initform nil :accessor id)
   (title :initarg :title :initform nil :accessor title)
   (slug :initarg :slug :initform nil :accessor slug)
   (summary :initarg :summary :initform nil :accessor summary)
   (date :initarg :date :initform nil :accessor date)
   (body :initarg :body :initform nil :accessor body)
   (status :initarg :status :initform nil :accessor status)
   (cat :initarg :cat :initform nil :accessor cat)
   (subcat :initarg :subcat :initform nil :accessor subcat)
   (tags :initarg :tags :initform nil :accessor tags)
   (location :initarg :location :initform nil :accessor location)
   (author :initarg :author :initform nil :accessor author))
  (:documentation "Article Class"))

(defclass article-storage ()
  ((articles :initform nil :accessor articles)
   (last-id :initform 0 :accessor last-id))
  (:documentation "Object of this class will act as the storage for Articles"))

(defun get-all-articles (&optional (storage *article-storage*))
  "return all articles"
  (articles storage))

(defun count-articles (&optional (storage *article-storage*))
  "count the number of articles in 'storage'"
  (length (get-all-articles storage)))

(defun get-article-by-id (id &optional (storage *article-storage*))
  "return article w/ ID 'id' from 'storage'"
  (find id
        (get-all-articles storage)
        :key #'id))

(defun get-articles-by-tag (tag &optional (storage *article-storage*))
  "return articles w/ tag 'tag' from 'storage'"
  (declare (ignore tag storage)))

(defun get-articles-by-cat (cat &optional (storage *article-storage*))
  "return articles w/ category 'cat' from 'storage'"
  (declare (ignore cat storage)))

(defun get-articles-by-cat-subcat (cat subcat &optional (storage *article-storage*))
  "return articles w/ category='cat' and subcategory='subcat' from 'storage'"
  (declare (ignore cat subcat storage)))

(defun add-article (article &optional (storage *article-storage*))
  "add article 'article' to 'storage'"
  ;; set some article params
  (setf (id article)
        (incf (last-id storage)))
  (setf (date article)
        (now))
  (setf (slug article)
        (slugify (title article)))
  (multiple-value-bind (id name handle) (get-mini-author-details-from-id (get-current-author-id))
    (setf (author article)
          (make-instance 'mini-author
                         :id id
                         :name name
                         :handle handle)))

  ;; save article into storage
  (push article
        (articles storage))
  article)

(defun latest-articles (category)
  (declare (ignore category)))

(defun most-popular-articles (category)
  (declare (ignore category)))
