(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro get-storage (system dim-str)
  `(cond ((equal (get-config "db.type" ,dim-str) "prevalence")
          (get-root-object system ,system))))

(defmacro init-db-system (name system dim-str)
  `(let ((db-type (get-config "db.type" ,dim-str)))
     (cond ((equal db-type "prevalence")
            (progn
              ;; make-<name>s-root (system)
              (defun ,(intern (string-upcase (format nil "make-~as-root" `,name))) (system)
                (setf (get-root-object system ,system)
                      (make-instance ',(intern (string-upcase (format nil "~a-storage" `,name))))))

              ;; get-all-<name>s ()
              (defun ,(intern (string-upcase (format nil "get-all-~as" `,name))) ()
                (,(intern (string-upcase (format nil "~as" `,name)))
                  (get-root-object (get-db-handle) ,system)))

              ;; incf-<name>-last-id (system)
              (defun ,(intern (string-upcase (format nil "incf-~a-last-id" `,name))) (system)
                (let ((storage (get-storage ,system ,dim-str)))
                  (incf (,(intern (string-upcase "last-id")) storage))))

              ;; insert-<name> (system object)
              (defun ,(intern (string-upcase (format nil "insert-~a" `,name))) (system object)
                (let ((storage (get-storage ,system ,dim-str)))
                  (push object (,(intern (string-upcase (format nil "~as" `,name))) storage))))

              ;; update-<name> (system object)
              (defun ,(intern (string-upcase (format nil "update-~a" `,name))) (system object)
                (let* ((storage (get-storage ,system ,dim-str))
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
;;; macros (won't work coz the macros are created only when this function is called,
;;; and other functions depending on these macros won't be created or will fail)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

              ;; get-<name>s-by (cond)
              #- (and)
              (defmacro ,(intern (string-upcase (format nil "get-~as-by" `,name))) (cond)
                `(sort (conditionally-accumulate ,cond
                                                 (,',(intern (string-upcase (format nil "get-all-~as" `,name)))))
                       #'>
                       :key #'id))

              ;; add-<name>-helper (object &key prefix suffix):- ; internally calls insert-<name>
              #- (and)
              (defmacro ,(intern (string-upcase (format nil "add-~a-helper" `,name)))
                  ((object ,(intern (string-upcase (format nil "~a" `,name)))) add-system &key prefix suffix)
                `(let ((storage (get-storage ,add-system)))
                   ,@prefix
                   (execute *db* (make-transaction ',(intern (string-upcase (format nil "insert-~a" `,name))) object))
                   ,@suffix
                   object)))))))

(defmacro get-object-by (cond list)
  `(conditionally-accumulate ,cond ,list))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; getters/setters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-db-handle ()
  (if (boundp '*request*)
      (db (resources (dimensions *request*)))
      (get-resource "db" *default-dimensions*)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DB connection
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun db-connect (dim-str)
  (let ((db-type (get-config "db.type" dim-str)))
    (cond ((equal db-type "prevalence")
           (set-resource "db" (make-prevalence-system (get-config "db.path" dim-str)) dim-str)))))

(defun db-disconnect (dim-str)
  (let ((db-type (get-config "db.type" dim-str)))
    (cond ((equal db-type "prevalence")
           (let ((db (get-resource "db" dim-str)))
             (when db
               (close-open-streams db)))))))

(defun db-reconnect ()
  (dolist (dim (first (reverse (hawksbill.utils::group-list #'length *dimensions-combos*))))
    (let ((dim-str (dim-to-dim-str dim)))
      (db-disconnect dim-str)
      (db-connect dim-str))))
