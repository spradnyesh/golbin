(in-package :hawksbill.utils)

(defun ppr-date (timestamp)
  (format-timestring nil timestamp :format '(:short-weekday ", " :short-month " " :day ", " :year)))

(defun ppr-time (timestamp)
  (format-timestring nil timestamp :format '(:hour12 ":" :min " " :ampm)))

(defun prettyprint-datetime (&optional (timestamp (now)))
  (translate "datetime" (ppr-date timestamp) (ppr-time timestamp)))
