(in-package :hawksbill.utils)

(defun get-year-month-date ()
  (multiple-value-bind (s m h d mm y dw dst-p tz)
                        (get-decoded-time)
    (declare (ignore s m h dw dst-p tz))
    (values y mm d)))
