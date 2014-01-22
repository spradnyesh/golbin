(in-package :hawksbill.golbin)

(defmacro populate-config-from-secret (key)
  `(progn
     (if (assoc ,key *secrets* :test #'equal)
         (add-config ,key
                     (cdr (assoc ,key *secrets* :test #'equal))
                     "master")
         (progn (format t "please enter ~a key: " ,key)
                (add-config ,key (read-line) "master")))))

(defun push-to-secret (key value)
  (push (cons key value) *secrets*))
