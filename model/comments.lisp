(in-package :hawksbill.golbin.model)

(defclass comment ()
  ((children :initarg :children :initform nil :accessor children)
   (body :initarg :body :initform nil :accessor body)
   (status :initarg :status :initform nil :accessor status) ; :a active, :d deleted
   ;; below fields are needed for akismet/spam
   (username :initarg :username :initform nil :accessor username)
   #|(user-email :initarg :user-email :initform nil :accessor user-email)|#
   (user-url :initarg :user-url :initform nil :accessor user-url)
   (user-ip :initarg :user-ip :initform nil :accessor user-ip)
   (user-agent :initarg :user-agent :initform nil :accessor user-agent)))
