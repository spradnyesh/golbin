(in-package :hawksbill.golbin.editorial)

(defun get-tags-json ()
  (encode-json-to-string (get-tags-for-autocomplete)))