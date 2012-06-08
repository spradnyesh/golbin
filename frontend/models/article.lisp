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
  ((articles :initform nil)
   (last-id :initform 0))
  (:documentation "Object of this class will act as the storage for Articles"))

(defmethod count-articles ((storage article-storage))
  "count the number of articles in 'storage'"
  (length (slot-value storage 'articles)))

(defun paginate (list &key (offset 0) (limit *article-pagination-limit*))
  (let* ((list (if (consp list)
				   list
				   (list list)))
		 (len (length list))
		 (end (+ limit offset)))
    (if (and (not (minusp offset))
             (> len offset))
        (subseq list
                offset
                (if (and list (< end len))
                    end)))))

(defmethod get-all-articles ((storage article-storage))
  "return all articles"
  (slot-value storage 'articles))

(defmethod get-article-by-id ((storage article-storage) id)
  "return article w/ ID 'id' from 'storage'"
  (find id
        (slot-value storage 'articles)
        :key #'id))

(defmethod get-articles-by-tag ((storage article-storage) tag)
  "return articles w/ tag 'tag' from 'storage'"
  (find tag
        (slot-value storage 'articles)
        :key #'tags
		:test #'string-equal))

(defmethod get-articles-by-cat ((storage article-storage) cat)
  "return articles w/ category 'cat' from 'storage'"
  (find cat
        (slot-value storage 'articles)
        :key #'cat
		:test #'string-equal))

(defmethod get-articles-by-cat-subcat ((storage article-storage) cat subcat)
  "return articles w/ category='cat' and subcategory='subcat' from 'storage'"
  (let ((cat-articles (find cat
							(slot-value storage 'articles)
							:key #'cat
							:test #'string-equal)))
	(when cat-articles
	  (find subcat
			(if (consp cat-articles)
				cat-articles
				(list cat-articles))
			:key #'subcat
			:test #'string-equal))))
