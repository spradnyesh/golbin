(in-package :hawksbill.utils)

(defgeneric model-init ()
  (:documentation "dummy function so that the below macro will work correctly"))

(defmacro start/stop/restart-system (system)
  `(progn
     (defun ,(intern (string-upcase (format nil "~a-start" `,system))) ()
       (unless *system-status*
         (setf *system-status* t)
         (init-config)
         (model-init)
         (db-connect))
       (hu-init)
       (start (get-config ,(format nil "~a.restas.package" `,system))
              :port (get-config ,(format nil "~a.restas.port" `,system))))
     (defun ,(intern (string-upcase (format nil "~a-stop" `,system))) ()
       (restas-stop (get-config ,(format nil "~a.restas.port" `,system))))
     (defun ,(intern (string-upcase (format nil "~a-restart" `,system))) ()
       (,(intern (string-upcase (format nil "~a-start" `,system))))
       (,(intern (string-upcase (format nil "~a-stop" `,system)))))))

(defun restas-stop (port)
  (dolist (acceptor restas::*acceptors*)
      (when (= port (hunchentoot::acceptor-port acceptor))
        (stop acceptor)
        (setf restas::*acceptors* (remove acceptor restas::*acceptors*))))
  (dolist (vhost restas::*vhosts*)
      (when (= port (restas::vhost-port vhost))
        (setf restas::*vhosts* (remove vhost restas::*vhosts*)))))

(defun destroy-system ()
  (stop-all)
  (db-disconnect))
