(in-package :hawksbill.golbin.editorial)

;; TODO: correct implementation
(defun who-am-i ()
  (get-random-from-list (get-all-authors)))