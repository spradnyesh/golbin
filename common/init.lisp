(in-package :hawksbill.golbin)

(defun create-system ()
  (init-config)
  (model-init)
  (db-connect))

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
