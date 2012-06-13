(in-package :hawksbill.utils)

(defun conditionally-accumulate (cond list)
  (let ((rslt nil))
    (dolist (l list rslt)
      (when (funcall cond l)
        (push l rslt)))))
