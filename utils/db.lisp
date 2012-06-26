(in-package :hawksbill.utils)

(defmacro get-storage (system)
  `(cond ((equal (get-config "db.type") "prevalence")
          (get-root-object *db* ,system))))

(defmacro init-db-system (name system)
  `(let ((db-type (get-config "db.type")))
     (cond ((equal db-type "prevalence")
            (progn
              (defun ,(intern (string-upcase (format nil "make-~as-root" `,name))) (system)
                (setf (get-root-object system ,system)
                      (make-instance ',(intern (string-upcase (format nil "~a-storage" `,name))))))
              (defun ,(intern (string-upcase (format nil "get-all-~as" `,name))) ()
                (let ((storage (get-storage ,system)))
                  (,(intern (string-upcase (format nil "~as" `,name))) storage)))
              (defun ,(intern (string-upcase (format nil "insert-~a" `,name))) (system object)
                (let ((storage (get-root-object system ,system)))
                  (push object (,(intern (string-upcase (format nil "~as" `,name))) storage)))))))))

(defun db-connect ()
  (let ((db-type (get-config "db.type")))
    (cond ((equal db-type "prevalence")
           (setf *db* (make-prevalence-system (get-config "db.path")))))))
(defun db-disconnect ()
  (let ((db-type (get-config "db.type")))
    (cond ((equal db-type "prevalence")
           (when *db*
             (close-open-streams *db*))))))
