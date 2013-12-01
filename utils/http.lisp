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
  (let ((acceptor (gensym)))
    `(progn
       (when (boundp '*acceptor*)
         (setf ,acceptor *acceptor*))
       (string-trim " \"\\;"
                    (second (split-sequence
                             "="
                             (first (all-matches-as-strings
                                     "var redirUrl = .*;"
                                     ;; execute asynchronously
                                     (handler-case (do-in-background (drakma:http-request
                                                                      (concatenate 'string
                                                                                   "http://web.archive.org/save/"
                                                                                   ,uri)))
                                       (usocket:timeout-error ()
                                         (progn ,error-handle
                                                (when ,acceptor
                                                  (log-message* :warning "failed to archive uri: [~a]" ,uri)))))))
                             :test #'string=))))))
