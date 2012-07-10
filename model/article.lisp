(in-package :hawksbill.golbin)

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
   (status :initarg :status :initform nil :accessor status) ; :d draft (for withdrawn by author too), :s submitted, :a approved/active, :w withdrawn (deleted by admin)
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
  ;; set some article params
  (setf (id article)
        (execute *db* (make-transaction 'incf-article-last-id)))
  (setf (date article)
        (now))
  (setf (slug article)
        (slugify (title article)))
  (set-mini-author article)

  ;; save article into storage
  (execute *db* (make-transaction 'insert-article article))

  article)

(defun edit-article (article)
  (execute *db* (make-transaction 'update-article article))

  article)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; getters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-all-articles-by-author (author)
  (get-object-by #'(lambda (article)
                                (= (id author)
                                   (id (author article))))
                 (get-all-articles)))

(defmacro get-articles-by (cond)
  `(get-object-by ,cond (get-all-articles)))

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
          (get-all-articles)))
        #'>
        :key #'id))

(defun latest-articles (category)
  (declare (ignore category)))

(defun most-popular-articles (category)
  (declare (ignore category)))

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
                                  :cat cat
                                  :subcat subcat
                                  :status (let ((r (random 4)))
                                            (cond ((zerop r) :d)
                                                  ((= 1 r) :s)
                                                  ((= 2 r) :a)
                                                  ((= 3 r) :w))))))))
