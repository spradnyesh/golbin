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

(defun get-all-articles ()
  (let ((storage (get-storage :articles)))
    (articles storage)))

(defun count-articles ()
  (length (get-all-articles)))

(defun get-article-by-id (id)
  (find id
        (get-all-articles)
        :key #'id))

(defmacro get-articles-by (cond)
  `(sort (conditionally-accumulate ,cond
                                   (get-all-articles))
         #'>
         :key #'id))

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

(defun insert-article (system article)
  (let ((articles (get-root-object system :articles)))
    (push article (articles articles))))

(defun add-article (article)
  (let ((storage (get-storage :categorys)))
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
    (execute *db* (make-transaction 'insert-article article))

    article))

(defun latest-articles (category)
  (declare (ignore category)))

(defun most-popular-articles (category)
  (declare (ignore category)))
