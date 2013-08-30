(in-package :hawksbill.golbin.model)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; classes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defclass article ()
  ((id :initarg :id :initform nil :accessor id)
   (parent :initarg :parent :initform nil :accessor parent) ; id of already live article (on editing, new article gets a new ID so that existing (live) article will not disappear)
   (title :initarg :title :initform nil :accessor title)
   (slug :initarg :slug :initform nil :accessor slug)
   (summary :initarg :summary :initform nil :accessor summary)
   (body :initarg :body :initform nil :accessor body)
   (date :initarg :date :initform nil :accessor date) ; actually timestamp
   (status :initarg :status :initform nil :accessor status) ; :r draft, :s submitted for approval, :e deleted (by author), :a approved/active, :w rejected/withdrawn (deleted by admin), :p processed (intermediate edits, discarded)
   (photo :initarg :photo :initform nil :accessor photo)
   (photo-direction :initarg :photo-direction :initform nil :accessor photo-direction) ; :l left, :r right, :b block
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; setters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun add-article (article)
  (when article
    ;; save article into storage
    (execute (get-db-handle) (make-transaction 'insert-article article))
    article))

(defun edit-article (article)
  (when article
    ;; save article into storage
    (execute (get-db-handle) (make-transaction 'update-article article))
    article))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; getters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-new-article-id ()
  (execute (get-db-handle) (make-transaction 'incf-article-last-id)))

(defun get-active-articles ()
  (sort (make-set (get-object-by #'(lambda (article)
                                      (eql :a (status article)))
                                  (get-all-articles))
                   :key #'id)
        #'>
        :key #'id))

(defmacro get-articles-by (cond)
  `(get-object-by ,cond (get-active-articles)))

(defun get-articles-by-author (author)
  (when author
    (get-articles-by #'(lambda (article)
                         (= (id author)
                            (id (author article)))))))

(defun get-articles-by-tag-slug (slug)
  (get-articles-by #'(lambda (article)
                       (dolist (tag (tags article))
                         (when (string-equal slug
                                             (string-to-utf-8 (slug tag) :utf-8))
                           (return t))))))

(defun get-articles-by-cat (cat)
  (when cat
    (get-articles-by #'(lambda (article)
                         (= (id cat)
                            (id (cat article)))))))

(defun get-articles-by-cat-subcat (cat subcat)
  (when subcat
    (sort (conditionally-accumulate
           #'(lambda (article)
               (= (id subcat)
                  (id (subcat article))))
           (when cat
             (conditionally-accumulate ; not putting the get-articles-by macro here, since i don't want the unnecessary sorting (it'll be done anyways at the end)
              #'(lambda (article)
                  (= (id cat)
                     (id (cat article))))
              (get-active-articles))))
          #'>
          :key #'id)))

(defun get-related-articles (typeof article)
  (let* ((id (id article))
         (cat-id (id (cat article)))
         (subcat (subcat article))
         (subcat-id (if subcat (id subcat) 0))
         (author-id (id (author article))))
    ;; if a new typeof is added, add validation in route too
    (cond ((string-equal typeof "cat-subcat")
           (get-articles-by #'(lambda (article)
                                (and (= (id (cat article)) cat-id)
                                     (or (zerop subcat-id)
                                         (= (id (subcat article)) subcat-id))
                                     (/= (id (author article)) author-id)))))
          ((string-equal typeof "author")
           (get-articles-by #'(lambda (article)
                                (and (/= (id article) id)
                                     (= (id (author article)) author-id))
                                #- (and) ; XXX: uncomment this when we have sufficient related articles
                                (and (/= (id (subcat article)) subcat-id)
                                     (= (id (author article)) author-id))))))))

;; we need to filter out the most recent version of an edited article
(defun filter-approval-articles (list)
  (dolist (p list)
      (unless (null (parent p))
        (setf list (remove-if #'(lambda (a)
                                  (= (id a)
                                     (parent p)))
                              list))))
  list)

;; editorial: an author needs to see *all* of his articles
(defun get-all-articles-by-author (author)
  (let* ((rslt (get-object-by #'(lambda (article)
                                  (and (not (eq :p (status article)))
                                       (= (id author)
                                          (id (author article)))))
                             (get-all-articles)))
         (parent-not-nil (make-set (remove-if #'(lambda (a)
                                                  (null (parent a)))
                                              rslt)
                                   :key #'parent))
         (parent-nil (make-set (remove-if #'(lambda (a)
                                              (not (null (parent a))))
                                    rslt)
                               :key #'id)))
    (sort (filter-approval-articles (append parent-nil parent-not-nil))
          #'>
          :key #'id)))

(defun get-all-articles-for-approval ()
  (filter-approval-articles (reverse (make-set (get-object-by #'(lambda (article)
                                                                  (eq (status article)
                                                                      :s))
                                                              (get-all-articles))
                                               :key #'parent))))

(defun get-intermediate-articles (parent)
  (get-object-by #'(lambda (a)
                     (and (not (null (parent a)))
                          (= parent
                             (parent a))
                          (eq :r (status a))))
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
