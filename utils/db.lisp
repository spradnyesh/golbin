(in-package :hawksbill.utils)

(defmacro get-storage (system)
  `(cond ((equal (get-config "db.type") "prevalence")
          (get-root-object *db* ,system))))

(defmacro init-db-system (name system)
  `(let ((db-type (get-config "db.type")))
     (cond ((equal db-type "prevalence")
            (progn
              ;; make-<name>s-root (system)
              (defun ,(intern (string-upcase (format nil "make-~as-root" `,name))) (system)
                (setf (get-root-object system ,system)
                      (make-instance ',(intern (string-upcase (format nil "~a-storage" `,name))))))

              ;; get-all-<name>s ()
              (defun ,(intern (string-upcase (format nil "get-all-~as" `,name))) ()
                (let ((storage (get-storage ,system)))
                  (,(intern (string-upcase (format nil "~as" `,name))) storage)))

              ;; insert-<name> (system object)
              (defun ,(intern (string-upcase (format nil "insert-~a" `,name))) (system object)
                (let ((storage (get-root-object system ,system)))
                  (push object (,(intern (string-upcase (format nil "~as" `,name))) storage))))

              ;; get-<name>-by-id (id)
              (defun ,(intern (string-upcase (format nil "get-~a-by-id" `,name))) (id)
                (find id
                      (,(intern (string-upcase (format nil "get-all-~as" `,name))))
                      :key #'id))

              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
              ;; macros (won't work coz the macros are created only when this function is called,
              ;; and other functions depending on these macros won't be created or will fail)
              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

              ;; get-<name>s-by (cond)
              #|(defmacro ,(intern (string-upcase (format nil "get-~as-by" `,name))) (cond)
                `(sort (conditionally-accumulate ,cond
                                                 (,',(intern (string-upcase (format nil "get-all-~as" `,name)))))
                       #'>
                       :key #'id))|#

              ;; add-<name>-helper (object &key prefix suffix):- ; internally calls insert-<name>
              #|(defmacro ,(intern (string-upcase (format nil "add-~a-helper" `,name)))
                  ((object ,(intern (string-upcase (format nil "~a" `,name)))) add-system &key prefix suffix)
                `(let ((storage (get-storage ,add-system)))
                   ,@prefix
                   (execute *db* (make-transaction ',(intern (string-upcase (format nil "insert-~a" `,name))) object))
                   ,@suffix
                   object))|#)))))

(defun db-connect ()
  (let ((db-type (get-config "db.type")))
    (cond ((equal db-type "prevalence")
           (setf *db* (make-prevalence-system (get-config "db.path")))))))
(defun db-disconnect ()
  (let ((db-type (get-config "db.type")))
    (cond ((equal db-type "prevalence")
           (when *db*
             (close-open-streams *db*))))))
