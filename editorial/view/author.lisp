(in-package :hawksbill.golbin.editorial)

(defun who-am-i ()
  (get-author-by-handle (session-value :author)))
