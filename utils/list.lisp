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

#|(defun replace-all (list item replacement &key (test #'eql))
  (when list
    (if (funcall test item (first list))
        (cons replacement (find-replace (rest list) item replacement))
        (cons (first list) (find-replace (rest list) item replacement)))))|#

(defun replace-all (list item replacement &key (test #'eql))
  (loop for l in list
       collect (if (funcall test item l)
                   replacement
                   l)))
