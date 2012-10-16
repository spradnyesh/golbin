(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; list manipulation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun conditionally-accumulate (cond list)
  (remove-if #'null (mapcar #'(lambda (l) (when (funcall cond l) l)) list)))

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

(defun splice (list &key (from 0) (to (1- (length list))))
  (if (and list
           (>= from 0)
           (>= to from)
           (< to (length list)))
      (let ((rslt nil))
        (dotimes (i (1+ (- to from)))
          (push (nth (+ from i) list) rslt))
        (nreverse rslt))
      (values nil list)))

(defun get-random-from-list (list)
  (nth (random (length list)) list))

(defun subset (l1 l2)
  (when (<= (length l1) (length l2))
    (dolist (l l1)
      (unless (member l l2)
        (return nil)))
    t))