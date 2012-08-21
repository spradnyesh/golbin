(in-package :hawksbill.golbin.editorial)

(defun who-am-i ()
  (get-author-by-username (session-value :username)))