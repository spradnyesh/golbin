(in-package :hawksbill.utils)

(defun join-string-list-with-delim (delim list &key (key nil))
  (let ((first-element (if key
                           (funcall key (first list))
                           (first list))))
    (if (= 1 (length list))
        first-element
        (concatenate 'string first-element
                     delim
                     (join-string-list-with-delim delim (rest list) :key key)))))
