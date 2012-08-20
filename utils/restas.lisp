(in-package :hawksbill.utils)

(defmacro with-login (url &body body)
  `(if *session*
       (progn ,@body)
       (redirect ,url)))

(defmacro is-logged-in? ()
  `*session*)

(defmacro start/stop/restart-system (system)
  `(progn
     (ensure-directories-exist ,(format nil "/tmp/hunchentoot/~a/" system))
     (defclass ,(intern (string-upcase (format nil "~a-acceptor" `,system))) (restas-acceptor)
       ()
       (:default-initargs
        :access-log-destination ,(format nil "/tmp/hunchentoot/~a/access_log" system)
         :message-log-destination ,(format nil "/tmp/hunchentoot/~a/error_log" system)))
     (defun ,(intern (string-upcase (format nil "~a-start" `,system))) ()
       (unless *system-status*
         (setf *system-status* t)
         (init-config)
         (model-init)
         (db-connect))
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
