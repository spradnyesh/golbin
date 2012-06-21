(in-package :hawksbill.golbin.frontend)

(defclass navigation-node ()
  ((name :initarg :name :initform nil :accessor name)
   (url :initarg :url :initform nil :accessor url)))
