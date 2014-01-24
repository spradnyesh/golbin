(in-package :hawksbill.golbin)

(defmacro populate-config-from-secret (key)
  (let ((value (gensym)))
    `(progn
       (if (assoc ,key *secrets* :test #'equal)
           (add-config ,key
                       (cdr (assoc ,key *secrets* :test #'equal))
                       "master")
           (progn (format t "please enter ~a key: " ,key)
                  (setf ,value (read-line))
                  (push-to-secret ,key ,value)
                  (add-config ,key ,value "master"))))))

(defun push-to-secret (key value)
  (push (cons key value) *secrets*))
