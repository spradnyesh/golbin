(in-package :hawksbill.utils)

(defmacro with-cache (&body body)
  `(let ((data (mc-get+ key)))
      (if data
          data
          (progn
            (setf data ,@body)
            (mc-store key data)
            data))))
