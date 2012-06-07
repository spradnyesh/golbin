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

(defun tmp-init ()
  "add a new article to the db"
  (flet (( storage-add-article (storage article)
		   "add article 'article' to 'storage'"
		   (setf (slot-value article 'id)
				 (incf (slot-value storage 'last-id)))
		   (setf (slot-value article 'date)
				 (now))
		   (push article
				 (slot-value storage 'articles))
		   article))
	(dotimes (i 100)
	  (storage-add-article *article-storage* (make-instance 'article
															:title (format nil "title-of-the-~Ath-article" (1+ i))
															:summary (format nil "~A: There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain... --http://lipsum.com/" (1+ i))
															:tags (format nil "tags-~A" (1+ i))
															:body (format nil "~A: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.

It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)." (1+ i))
															:cat (format nil "cat-~A" (1+ i))
															:subcat (format nil "subcat-~A" (1+ i))
															:author (format nil "author-~A" (1+ i))))))
  (describe *article-storage*))
