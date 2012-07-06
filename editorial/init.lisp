(in-package :hawksbill.golbin)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; start/stop/restart various servers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ed-start ()
  (unless *system-status*
    (setf *system-status* t)
    (create-system))
  (hu-init)
  (start (get-config "editorial.restas.package") :port (get-config "editorial.restas.port")))
(defun ed-stop ()
  (restas-stop (get-config "editorial.restas.port")))
(defun ed-restart ()
  (ed-stop)
  (ed-start))
