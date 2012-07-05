(in-package :hawksbill.golbin)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; start/stop/restart various servers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun fe-start ()
  (unless *system-status*
    (setf *system-status* t)
    (create-system))
  (start (get-config "frontend.restas.package") :port (get-config "frontend.restas.port")))
(defun fe-stop ()
  (restas-stop (get-config "frontend.restas.port")))
(defun fe-restart ()
  (fe-stop)
  (fe-start))
