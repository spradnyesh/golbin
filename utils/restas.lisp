(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; session handlin
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro with-login (url &body body)
  `(if *session*
       (progn ,@body)
       (redirect ,url)))

(defmacro is-logged-in? ()
  `*session*)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; start/stop/restart
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro start/stop/restart-system (system)
  `(progn
     (ensure-directories-exist ,(format nil "/tmp/hunchentoot/~a/" system))
     (defclass ,(intern (string-upcase (format nil "~a-acceptor" `,system))) (hawksbill-acceptor)
       ()
       (:default-initargs
        :access-log-destination ,(format nil "/tmp/hunchentoot/~a/access_log" system)
        :message-log-destination ,(format nil "/tmp/hunchentoot/~a/error_log" system)))
     (defun ,(intern (string-upcase (format nil "~a-start" `,system))) ()
       (unless *system-status*
         (setf *system-status* t)
         (init-config)
         (set-default-dimensions nil)
         ;; init-model & db-connect only for the longest dim-str
         ;; ensure that the "db.path" config is present in longest dim-str
         (dolist (dim (first (reverse (group-list #'length *dimensions-combos*))))
           ;; the below 'sort' ensures that the dim-str is lexically sorted based on the dimension
           ;; this reduces permutations-i -> combinations-i
           (let ((dim-str (join-string-list-with-delim "," (sort dim #'string<))))
             (setf (gethash dim-str *resources*) (make-hash-table :test 'equal))
             (model-init dim-str)
             (db-connect dim-str))))
       (load-all-languages)
       (hu-init)
       (obfuscate-js)
       (start (get-config ,(format nil "~a.restas.package" `,system))
              :port (get-config ,(format nil "~a.restas.port" `,system))
              :acceptor-class ',(intern (string-upcase (format nil "~a-acceptor" `,system)))))
     (defun ,(intern (string-upcase (format nil "~a-stop" `,system))) ()
       (restas-stop (get-config ,(format nil "~a.restas.port" `,system))))
     (defun ,(intern (string-upcase (format nil "~a-restart" `,system))) ()
       (,(intern (string-upcase (format nil "~a-stop" `,system))))
       (,(intern (string-upcase (format nil "~a-start" `,system)))))))

(defun restas-stop (port)
  (dolist (acceptor restas::*acceptors*)
      (when (= port (hunchentoot::acceptor-port acceptor))
        (stop acceptor)
        (setf restas::*acceptors* (remove acceptor restas::*acceptors*))))
  (dolist (vhost restas::*vhosts*)
      (when (= port (restas::vhost-port vhost))
        (setf restas::*vhosts* (remove vhost restas::*vhosts*)))))
