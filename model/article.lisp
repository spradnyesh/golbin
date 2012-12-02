(in-package :hawksbill.golbin.model)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; classes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defclass article ()
  ((id :initarg :id :initform nil :accessor id)
   (title :initarg :title :initform nil :accessor title)
   (slug :initarg :slug :initform nil :accessor slug)
   (summary :initarg :summary :initform nil :accessor summary)
   (date :initarg :date :initform nil :accessor date)
   (body :initarg :body :initform nil :accessor body)
   (status :initarg :status :initform nil :accessor status) ; :r draft, :e deleted (by author), :s submitted for approval, :a approved/active, :w rejected/withdrawn (deleted by admin)
   (photo :initarg :photo :initform nil :accessor photo)
   (photo-direction :initarg :photo-direction :initform nil :accessor photo-direction) ; :l left, :r right, :b block
   (cat :initarg :cat :initform nil :accessor cat)
   (subcat :initarg :subcat :initform nil :accessor subcat)
   (tags :initarg :tags :initform nil :accessor tags)
   (location :initarg :location :initform nil :accessor location)
   (author :initarg :author :initform nil :accessor author)
   (comments :initarg :comments :initform nil :accessor comments))
  (:documentation "Article Class"))

(defclass article-storage ()
  ((articles :initform nil :accessor articles)
   (last-id :initform 0 :accessor last-id))
  (:documentation "Object of this class will act as the storage for Articles"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; setters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun add-article (article)
  (when article
    ;; set some article params
    (setf (id article)
          (execute (get-db-handle) (make-transaction 'incf-article-last-id)))
    (setf (date article)
          (now))
    (setf (slug article)
          (slugify (title article)))
    (setf (status article) :r)
    (set-mini-author article)

    ;; save article into storage
    (execute (get-db-handle) (make-transaction 'insert-article article))

    article))

(defun edit-article (article)
  (when article
    ;; set some article params
    (setf (date article)
          (now))
    (set-mini-author article)

    ;; save article into storage
    (execute (get-db-handle) (make-transaction 'update-article article))

    article))

(defun add-article-comment (article parent-id comment)
  (when article
    (if (or (null (comments article))
            (string= "-1" parent-id))
        ;; this is the 1st comment for the article
        ;; or this is a top level comment
        (let ((comments (comments article)))
          (push comment comments)
          (setf (comments article) comments))
        ;; article already has comments
        (let ((parent (comments article))
              (p-id (split-sequence "." parent-id :test #'string=)))
          (dotimes (i (1- (length p-id)))
            (setf parent (children (nth (parse-integer (nth i p-id)) parent))))
          ;; take special care since the last node can be nil
          (setf parent (nth (parse-integer (first (last p-id))) parent))
          (push comment (children parent))))

    ;; save article into storage
    (execute (get-db-handle) (make-transaction 'update-article article))

    article))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; getters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-active-articles ()
  (get-object-by #'(lambda (article)
                       (eql :a (status article)))
                 (get-all-articles)))

(defmacro get-articles-by (cond)
  `(get-object-by ,cond (get-active-articles)))

(defun get-articles-by-author (author)
  (get-articles-by #'(lambda (article)
                                (= (id author)
                                   (id (author article))))))

(defun get-articles-by-tag-slug (slug)
  (get-articles-by #'(lambda (article)
                                (dolist (tag (tags article))
                                  (when (equal slug (slug tag))
                                    (return t))))))

(defun get-articles-by-cat (cat)
  (get-articles-by #'(lambda (article)
                                 (= (id cat)
                                    (id (cat article))))))

(defun get-articles-by-cat-subcat (cat subcat)
  (sort (conditionally-accumulate
         #'(lambda (article)
             (= (id subcat)
                (id (subcat article))))
         (conditionally-accumulate ; not putting the get-articles-by macro here, since i don't want the unnecessary sorting (it'll be done anyways at the end)
          #'(lambda (article)
              (= (id cat)
                 (id (cat article))))
          (get-active-articles)))
        #'>
        :key #'id))

(defun get-related-articles (typeof article)
  (let* ((cat-id (id (cat article)))
         (subcat (subcat article))
         (subcat-id (if subcat (id subcat) 0))
         (author-id (id (author article))))
    (cond ((string-equal typeof "cat-subcat")
           (get-articles-by #'(lambda (article)
                                (and (= (id (cat article)) cat-id)
                                     (or (zerop subcat-id) (= (id (subcat article)) subcat-id))
                                     (/= (id (author article)) author-id)))))
          ((string-equal typeof "author")
           (get-articles-by #'(lambda (article)
                                (and (/= (id (cat article)) cat-id)
                                     (/= (id (subcat article)) subcat-id)
                                     (= (id (author article)) author-id))))))))

;; editorial: an author needs to see *all* of his articles
(defun get-all-articles-by-author (author)
  (get-object-by #'(lambda (article)
                                (= (id author)
                                   (id (author article))))
                 (get-all-articles)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; needed for tmp-init
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun add-articles ()
  "add new articles to the db"
  (dotimes (i 1000)
    (multiple-value-bind (cat subcat) (get-random-cat-subcat)
      (add-article (make-instance 'article
                                  :title (format nil "title  of $ % ^ * the ~Ath article" (1+ i))
                                  :summary (format nil "~A: There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain... --http://lipsum.com/" (1+ i))
                                  :tags (list (get-random-tag) (get-random-tag))
                                  :body (format nil "~A: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.

It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)." (1+ i))
                                  :photo (let ((r (random 4)))
                                           (if (zerop r) nil
                                               (get-random-photo :a))) ; put a photo in 75% articles
                                  :photo-direction (let ((r (random 3)))
                                                     (cond ((zerop r) :l)
                                                           ((= 1 r) :b)
                                                           ((= 2 r) :r)))
                                  :cat cat
                                  :subcat subcat
                                  :status (let ((r (random 10)))
                                            (cond ((zerop r) :r)
                                                  ((= 1 r) :s)
                                                  ((= 2 r) :w)
                                                  ((= 3 r) :deleted)
                                                  (t :a))))))))
