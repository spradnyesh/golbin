(in-package :hawksbill.golbin.frontend)

(defclass view-storage ()
  ((views :initform nil)
   (last-id :initform 0))
  (:documentation "Object of this class will act as the storage for Views"))

(defclass tag-storage ()
  ((tags :initform nil)
   (last-id :initform 0))
  (:documentation "Object of this class will act as the storage for Tags"))
