(in-package :hawksbill.golbin.frontend)

(defclass article ()
  ((id :initarg :id :initform nil :accessor article-id)
   (author :initarg :author :initform nil :accessor article-author)
   (title :initarg :title :initform nil :accessor article-title)
   (slug :initarg :slug :initform nil :accessor article-slug)
   (date :initarg :date :initform nil :accessor article-date)
   (cat :initarg :cat :initform nil :accessor article-cat)
   (subcat :initarg :subcat :initform nil :accessor article-subcat)
   (tags :initarg :tags :initform nil :accessor article-tags)
   (body :initarg :body :initform nil :accessor article-body)
   (summary :initarg :summary :initform nil :accessor article-summary))
  (:documentation "Article Class"))

(defclass article-storage ()
  ((articles :initform nil)
   (last-id :initform 0))
  (:documentation "Object of this class will act as the storage for Articles"))

(defmethod count-articles ((storage article-storage))
  "count the number of articles in 'storage'"
  (length (slot-value storage 'articles)))

#|(defmethod paginated-list-of-articles ((storage article-storage) &optional (offset 0) (limit *article-pagination-limit*))
  "return list of 'limit' articles (not IDs) starting from 'offset' from 'storage'"
  (let* ((articles (slot-value storage 'articles))
         (len (length articles))
         (end (+ limit offset)))
    (if (and (not (minusp offset))
             (> len offset))
        (subseq articles
                offset
                (if (and articles (< end len))
                    end)))))|#
(defun paginate (list &key (offset 0) (limit *article-pagination-limit*))
  (let ((len (length list))
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
        :key #'article-id))

(defmethod get-articles-by-tag ((storage article-storage) tag)
  "return articles w/ tag 'tag' from 'storage'"
  (find tag
        (slot-value storage 'articles)
        :key #'article-tags
		:test #'string-equal))

(defmethod get-articles-by-cat ((storage article-storage) cat)
  "return articles w/ category 'cat' from 'storage'"
  (find cat
        (slot-value storage 'articles)
        :key #'article-cat
		:test #'string-equal))

(defmethod get-articles-by-cat-subcat ((storage article-storage) cat subcat)
  "return articles w/ category='cat' and subcategory='subcat' from 'storage'"
  (let ((cat-articles (find cat
							(slot-value storage 'articles)
							:key #'article-cat
							:test #'string-equal)))
	(when cat-articles
	  (find subcat
			(if (consp cat-articles)
				cat-articles
				(list cat-articles))
			:key #'article-subcat
			:test #'string-equal))))


;; the below articles are needed on the editorial site, and not on the frontend
#|(
 (defmethod storage-add-article ((storage article-storage) article)
   "add article 'article' to 'storage'"
   (setf (slot-value article 'id)
		 (incf (slot-value storage 'last-id)))
   (setf (slot-value article 'date)
		 (local-time:now))
   (push article
		 (slot-value storage 'articles))
   article)

 (defmethod storage-remove-article (storage id)
   "remove article w/ ID 'id' from 'storage'"
   (setf (slot-value storage 'articles)
		 (remove id
				 (slot-value storage 'articles)
				 :key #'(lambda (article) (getf article :id))))))|#


;;;; misc
#|(
 ;; add a new article to the db
 (defvar *article* nil)
 (setf *article* (make-instance 'article
						  :title "title-1"
						  :summary "summary-1"
						  :tags "tags-1"
						  :body "body-1"
						  :cat "cat-1"
						  :subcat "subcat-1"
						  :author "author-1"))
 (storage-add-article *article-storage* *article*)
 (describe *article-storage*)
 )|#
