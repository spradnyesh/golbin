(in-package :hawksbill.golbin.frontend)

(defclass page-count ()
  ((url :initarg :url :initform nil :accessor url)
   (page-count :initarg :page-count :initform 1 :accessor page-count))
  (:documentation "#times a page was hit in the past 1 hour"))

(defclass view-node ()
  ((from-time :initarg :from-time :initform nil :accessor from-time)
   (to-time :initarg :to-time :initform nil :accessor to-time)
   (page-count :initarg :page-count :initform nil :accessor page-count))
  (:documentation "a node in 'view-list' in 'views'"))

(defclass view ()
  ((url :initarg :url :initform nil :accessor url)
   (view-list :initarg :view-list :initform nil :accessor view-list))
  (:documentation "Nodes: hourly (for 24 hours), daily (for 31 days), monthly (for 12 months), yearly"))

(defclass views-storage ()
  ((views :initform nil :accessor views)
   (last-id :initform 0 :accessor last-id))
  (:documentation "Object of this class will act as the storage for views (time-based views of a page (index/article))"))

(defclass page-count-storage ()
  ((counts :initform nil :accessor counts))
  (:documentation "Object of this class will act as the storage for page-count"))

(defun get-all-counts (&optional (storage *count-storage*))
  (counts storage))

(defun incf-count (url &optional (storage *count-storage*))
  ;; TODO: this needs to be mutexed
  (let ((pc (find url (get-all-counts storage)
                  :test #'string-equal
                  :key 'url)))
    (if pc
        (incf (page-count pc))
        (push (make-instance 'page-count
                             :url url
                             :page-count 1)
              (counts *count-storage*)))))

(defun view-counts (&optional (storage *count-storage*))
  (dolist (c (counts storage))
    (format t "[~a]: ~a~%" (url c) (page-count c))))

(defun most-popular-categories ())
(defun most-popular-authors ())
(defun most-popular-articles (&optional category)
  (declare (ignore category)))
(defun most-popular-articles-in-category ())
(defun trending-tags ())
