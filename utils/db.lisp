(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro get-storage (dimension system)
  `(cond ((equal (get-config "db.type") "prevalence")
          (get-root-object (get-db-handle) ,system))))

(defmacro init-db-system (dimension name system)
  `(let ((db-type (get-config dimension "db.type")))
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

              ;; incf-<name>-last-id (system)
              (defun ,(intern (string-upcase (format nil "incf-~a-last-id" `,name))) (system)
                (let ((storage (get-root-object system ,system)))
                  (incf (,(intern (string-upcase (format nil "last-id"))) storage))))

              ;; insert-<name> (system object)
              (defun ,(intern (string-upcase (format nil "insert-~a" `,name))) (system object)
                (let ((storage (get-root-object system ,system)))
                  (push object (,(intern (string-upcase (format nil "~as" `,name))) storage))))

              ;; update-<name> (system object)
              (defun ,(intern (string-upcase (format nil "update-~a" `,name))) (system object)
                (let* ((storage (get-root-object system ,system))
                       (list (,(intern (string-upcase (format nil "~as" `,name))) storage)))
                  (setf (nth (position (id object) list :key #'id)
                             list)
                        object)))

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

(defmacro get-object-by (cond list)
  `(conditionally-accumulate ,cond ,list))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; getters/setters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-db-handle (request *request*)
  (db (resources (dimensions request))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DB connection
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun db-connect (dimension)
  (let ((db-type (get-config dimension "db.type")))
    (cond ((equal db-type "prevalence")
           (let ((resource (get-resource "db" dimension))
                 (db (make-prevalence-system (get-config dimension "db.path"))))
             (if resource
               (set-resource "db" dimension db)
               (progn
                 (let ((ht (make-hash-table :test 'equal)))
                   (setf (gethash dimension ht) db)
                   (setf (gethash "db" *resources*) ht)))))))))

(defun db-disconnect (dimension)
  (let ((db-type (get-config dimension "db.type")))
    (cond ((equal db-type "prevalence")
           (let ((db (get-resource "db" dimension)))
             (when db
               (close-open-streams db)))))))

(defun db-reconnect (dimension)
  (db-disconnect dimension)
  (db-connect dimension))