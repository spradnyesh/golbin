(in-package :hawksbill.golbin.editorial)

(defun v-ajax-tags ()
  (encode-json-to-string (get-tags-for-autocomplete (get-parameter "term"))))