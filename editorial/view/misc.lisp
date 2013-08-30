(in-package :hawksbill.golbin.editorial)

(defmacro get-slug-and-id (article)
  `(fmtnil (slug ,article) "-" (id ,article)))

(defun who-am-i ()
  (declare (inline))
  (get-author-by-handle (session-value :author)))

(defun v-ajax-tags ()
  (encode-json-to-string (get-tags-for-autocomplete (get-parameter "term"))))
