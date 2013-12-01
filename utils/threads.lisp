(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro do-in-background (fn)
  `(plet ((status ,fn))
     (declare (ignore status))))
