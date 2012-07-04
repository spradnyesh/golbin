(in-package :hawksbill.golbin)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; start/stop/restart various servers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun r-stop ()
  (db-disconnect)
  (stop-all))
(defun r-start ()
  (model-init)
  (start :hawksbill.golbin :port 8000))
(defun r-restart ()
  (r-stop)
  (r-start))
