(in-package :hawksbill.utils)

(defun db-connect ()
  (cond ((equal "sqlite3"
                       (scwe ".database.type"))
         (open-store `(:clsql (:sqlite3 ,(scwe ".database.path")))))
        ((equal "mysql"
                       (scwe ".database.type"))
         (open-store `(:clsql (:mysql ,(scwe ".database.host")
                                            (scwe ".database.database-name")
                                            (scwe ".database.username")
                                            (scwe ".database.password")))))))
(defun db-disconnect ()
  (close-store))

(defun memcache-connect ()
  (setf *use-pool* (scwe ".memcache.use-pool"))
  (setf *memcache*
        (mc-make-memcache-instance
         :ip (scwe ".memcache.host")
         :port (scwe ".memcache.port")
         :pool-size (scwe ".memcache.pool-size"))))

(defun hunchentoot-connect (server)
  (let ((port (scwe ".hunchentoot.port")))
    (setf server (make-instance 'acceptor
                                :port port))
    (hunchentoot:start server)
    (format t "Webserver started on port ~A.~%" port)
    (setf *show-lisp-errors-p* (scwe ".hunchentoot.show-lisp-errors"))
    (setf *message-log-pathname* (scwe ".hunchentoot.message-log-pathname"))
    (setf *access-log-pathname* (scwe ".hunchentoot.access-log-pathname"))
    server))

(defun rb-init ()
  (setf *translation-file-root*
        (concatenate 'string "/"
                     (join-string-list-with-delim
                      (rest (pathname-directory
                             (if (boundp '*home*)
                                 *home*
                                 *default-pathname-defaults*)))
                      "/")
                     "/"
                     (scwe ".i18n.trans-root")))
  (let ((locale (scwe ".i18n.l10n.locale")))
    (when locale
      (load-language locale))))

(defun init-db-id (name value)
  (unless (root-existsp name)
      (add-to-root name value)))
(defun init-db-ids ()
  (dolist (id-value *db-init-ids*)
    (destructuring-bind (id value) id-value
      (init-db-id id value))))

;;;; create and start server
(let ((server nil))
  (defun hu-start ()
    (db-connect)
    (init-db-ids)
    (memcache-connect)
    #|(rb-init)|# ; rb-init should actually be done for all intls and not just once, so disabling it for now
    (setf server (hunchentoot-connect server)))
  (defun hu-stop ()
    (format t "Shutting down")
    (hunchentoot:stop server)
    (db-disconnect)
    (sb-ext:quit)))
