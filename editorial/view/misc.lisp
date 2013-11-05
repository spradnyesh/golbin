(in-package :hawksbill.golbin.editorial)

(defun who-am-i ()
  (declare (inline))
  (get-author-by-handle (session-value :author)))

(defun v-ajax-tags ()
  (encode-json-to-string (get-tags-for-autocomplete (get-parameter "term"))))
