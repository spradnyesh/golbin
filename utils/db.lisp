(in-package :hawksbill.utils)

(defmacro get-storage (storage)
  `(cond ((equal (get-config "db.type") "prevalence")
          (get-root-object *db* ,storage))))
(defun db-connect ()
  (let ((db-type (get-config "db.type")))
    (cond ((equal db-type "prevalence")
           (setf *db* (make-prevalence-system (get-config "db.path")))))))
(defun db-disconnect ()
  (let ((db-type (get-config "db.type")))
    (cond ((equal db-type "prevalence")
           (when *db*
             (close-open-streams *db*))))))
