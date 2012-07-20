(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; list manipulation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun conditionally-accumulate (cond list)
  "(remove-if #'null (mapcar #'(lambda (l) (when (funcall cond l) l)) list))"
  (let ((rslt nil))
    (dolist (l list rslt)
      (when (funcall cond l)
        (push l rslt)))))

(defun replace-all (list item replacement &key (test #'eql))
  (loop for l in list
       collect (if (funcall test item l)
                   replacement
                   l)))

(defun insert-at (list item position)
  (let ((len (length list)))
	(cond ((< position 0) (return-from insert-at list))
		  ((> position len) (setf position len)))
	(let ((rslt nil))
	  (dotimes (i position)
		(setf rslt (append rslt (list (pop list)))))
	  (setf rslt (append rslt (list item)))
	  (dotimes (i (length list))
		(setf rslt (append rslt (list (pop list)))))
	  rslt)))