(in-package :hawksbill.utils)

(defun conditional-accumulate (cond list)
  (when list
    (if (funcall cond (first list))
        (cons (first list) (helper cond (rest list)))
        (helper cond (rest list)))))
