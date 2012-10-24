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
         ;; XXX: this will make envt-dimen1, envt-dimen2, etc pairs which might not be what is really needed
         (dolist (envt *valid-envts*) ; for all envts
           (dolist (dimension (rest *dimensions*)) ; for all dimensions except envt
             (dolist (dim (symbol-value ; for every dimension value
                           (intern
                            (string-upcase
                             (format nil
                                     "*valid-~as*"
                                     dimension)))))
               (let ((dimension (build-dimension :envt envt (make-keyword dim) dim)))
                 (model-init dimension)
                 (db-connect dimension))))))
       (hu-init)
       (load-all-languages)
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
