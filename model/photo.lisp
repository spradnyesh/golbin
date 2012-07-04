(in-package :hawksbill.golbin)

(defclass photo ()
  ((id :initarg :id :initform nil :accessor id)
   (title :initarg  :title :initform nil :accessor title)
   (orig-filename :initarg :orig-filename :initform nil :accessor orig-filename)
   (path :initarg :path :initform nil :accessor path)
   (tags :initarg :tags :initform nil :accessor tags)
   (author :initarg :author :initform nil :accessor author)))
