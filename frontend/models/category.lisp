(in-package :hawksbill.golbin.frontend)

(defclass category ()
  ((id :initarg :id :initform nil :accessor id)
   (name :initarg :name :initform nil :accessor name)
   (parent :initarg :parent :initform nil :accessor parent)))

(defclass category-storage ()
  ((categorys :initform nil)
   (last-id :initform 0))
  (:documentation "Object of this class will act as the storage for Categorys"))
