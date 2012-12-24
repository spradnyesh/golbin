(in-package :hawksbill.golbin.model)

(defclass comment ()
  ((children :initarg :children :initform nil :accessor children)
   (body :initarg :body :initform nil :accessor body)
   (date :initarg :date :initform nil :accessor date) ; actually datetime
   (status :initarg :status :initform nil :accessor status) ; :a active, :d deleted
   ;; below fields are needed for akismet/spam
   (username :initarg :username :initform nil :accessor username)
   (useremail :initarg :useremail :initform nil :accessor useremail)
   (userurl :initarg :userurl :initform nil :accessor userurl)
   (userip :initarg :userip :initform nil :accessor userip)
   (useragent :initarg :useragent :initform nil :accessor useragent)))
