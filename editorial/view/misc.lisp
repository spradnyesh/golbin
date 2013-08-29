(in-package :hawksbill.golbin.editorial)

(defmacro get-slug-and-id (article)
  `(fmtnil (slug ,article) "-" (id ,article)))

(defun v-ajax-tags ()
  (encode-json-to-string (get-tags-for-autocomplete (get-parameter "term"))))
