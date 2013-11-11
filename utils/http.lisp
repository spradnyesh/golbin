(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; hunchentoot params
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defparameter hunchentoot:*default-content-type* "text/html; charset=utf-8")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; standard functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hunchentoot params
(defun hu-init ()
  (setf *catch-errors-p* (get-config "hunchentoot.debug.errors.catch"))
  (setf *show-lisp-errors-p* (get-config "hunchentoot.debug.errors.show"))
  (setf *show-lisp-backtraces-p* (get-config "hunchentoot.debug.backtraces")))

(defun logout ()
  (remove-session *session*)
  (redirect "/"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; archive @ http://web.archive.org
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro web-archive (uri &key error-handle)
  `(handler-case (with-timeout ((get-config "site.timeout.archive"))
                   (drakma:http-request (concatenate 'string
                                                     "http://web.archive.org/save/"
                                                     ,uri)))
     (trivial-timeout:timeout-error ()
       (progn ,error-handle
              (when (and (boundp '*acceptor*) *acceptor*)
                (log-message* :warning "failed to archive uri: [~a]" ,uri))))
     (usocket:timeout-error ()
       (progn ,error-handle
              (when (and (boundp '*acceptor*) *acceptor*)
                (log-message* :warning "failed to archive uri: [~a]" ,uri))))))
