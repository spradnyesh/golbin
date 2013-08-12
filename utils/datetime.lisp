(in-package :hawksbill.utils)

(defun prettyprint-date (&optional (timestamp (now)))
  (format-timestring nil timestamp :format '(:short-weekday ", " :short-month " " :day ", " :year)))

(defun prettyprint-time (&optional (timestamp (now)))
  (format-timestring nil timestamp :format '((:hour 2) ":" (:min 2))))
