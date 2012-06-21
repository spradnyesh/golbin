(in-package :hawksbill.utils)

(defun db-connect ()
  (dbm-open *db* (get-config "db.path") :create :write))
(defun db-disconnect ()
  (dbm-close *db*))

#|(defun memcache-connect ()
  (setf *use-pool* ((get-config "memcache.use-pool"))
  (setf *memcache*
        (mc-make-memcache-instance
         :ip ((get-config "memcache.host")
         :port ((get-config "memcache.port")
         :pool-size ((get-config "memcache.pool-size"))))))))|#

#|(defun rb-init ()
  (setf *translation-file-root*
        (concatenate 'string "/"
                     (join-string-list-with-delim
                      (rest (pathname-directory
                             (if (boundp '*home*)
                                 *home*
                                 *default-pathname-defaults*)))
                      "/")
                     "/"
                     ((get-config "i18n.trans-root")))
  (let ((locale ((get-config "i18n.l10n.locale")))
    (when locale
      (load-language locale))))))|#

;;;; create and start server
(defun hu-start ()
  (db-connect)
  #|(rb-init)|# ; rb-init should actually be done for all intls and not just once, so disabling it for now
  (memcache-connect)
  (start (get-config "restas.package" "restas.port")))
(defun hu-stop ()
  (format t "Shutting down")
  (db-disconnect)
  (stop-all)
  (sb-ext:quit))
