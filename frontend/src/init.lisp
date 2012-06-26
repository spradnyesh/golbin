(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; various inits
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun first-run ()
  (dolist (l '("article" "author" "category" "tag"))
    (execute *db* (make-transaction (intern (string-upcase (format nil "make-~as-root" l))))))
  (add-cat/subcat *config-storage*))

(defun tmp-init ()
  (add-authors)
  (add-tags)
  (add-articles))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; start/stop/restart various servers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun r-stop ()
  (db-disconnect)
  (stop-all))
(defun r-start ()
  (init-config)
  (init-storage)
  (db-connect)
  (start :hawksbill.golbin.frontend :port 8000))
(defun r-restart ()
  (r-stop)
  (r-start))
