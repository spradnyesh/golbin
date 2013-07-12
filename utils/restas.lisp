(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; session handling
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro with-login (url &body body)
  `(if *session*
       (progn ,@body)
       (redirect ,url)))

(defmacro is-logged-in? ()
  `*session*)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; start/stop/restart
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro start/stop/restart-system (system)
  `(progn
     (ensure-directories-exist ,(format nil "/tmp/hunchentoot/~a/" system))
     (defclass ,(intern (string-upcase (format nil "~a-acceptor" `,system))) (hawksbill-acceptor)
       ()
       (:default-initargs
        :access-log-destination ,(format nil "/tmp/hunchentoot/~a/access.log" system)
         :message-log-destination ,(format nil "/tmp/hunchentoot/~a/error.log" system)))
     (defun ,(intern (string-upcase (format nil "~a-start" `,system))) ()
       (unless *system-status*
         (setf *system-status* t)
         (init-config)
         (set-default-dimensions nil)
         ;; init-model & db-connect only for the longest dim-str
         ;; ensure that the "db.path" config is present in longest dim-str
         (dolist (dim (first (reverse (group-list #'length *dimensions-combos*))))
           ;; the below 'sort' ensures that the dim-str is lexically sorted based on the dimension
           ;; this reduces permutations-i -> combinations-i
           (let ((dim-str (dim-to-dim-str dim)))
             (setf (gethash dim-str *resources*) (make-hash-table :test 'equal))
             (model-init dim-str)
             (db-connect dim-str))))
       (load-all-languages)
       (hu-init)
       (obfuscate-js)
       (start (get-config ,(format nil "~a.restas.package" `,system))
              :port (get-config ,(format nil "~a.restas.port" `,system))
              :acceptor-class ',(intern (string-upcase (format nil "~a-acceptor" `,system)))))
     (defun ,(intern (string-upcase (format nil "~a-stop" `,system))) ()
       (restas-stop (get-config ,(format nil "~a.restas.port" `,system))))
     (defun ,(intern (string-upcase (format nil "~a-restart" `,system))) ()
       (,(intern (string-upcase (format nil "~a-stop" `,system))))
       (,(intern (string-upcase (format nil "~a-start" `,system)))))))

(defun restas-stop (port)
  (dolist (acceptor restas::*acceptors*)
    (when (= port (hunchentoot::acceptor-port acceptor))
      (stop acceptor)
      (setf restas::*acceptors* (remove acceptor restas::*acceptors*))))
  (dolist (vhost restas::*vhosts*)
    (when (= port (restas::vhost-port vhost))
      (setf restas::*vhosts* (remove vhost restas::*vhosts*)))))


(defun h-genurl (&rest args)
  (if (boundp '*request*)
      (apply #'genurl (if (parameter "d1m")
                          (append args (list :d1m (parameter "d1m")))
                          args))
      "/"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 404
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro m-404 (base-name)
  ;; http://stackoverflow.com/a/5891899
  (let*
      ((package (symbol-package base-name))
       (r-404 (intern (string-upcase  "r-404") package))
       (v-404 (intern (string-upcase "v-404") package))
       (template (intern (string-upcase "template") package)))
    `(progn
       (define-route ,r-404 ("*any")
         (,v-404))
       (defun ,v-404 ()
         (,template
          :title (translate "page-not-found")
          :body (<:div :class "error"
                      "Sorry! We were unable to find the content that you are looking for. Please click "
                      (<:a :href "javascript:history.go(-1)" "here")
                      " to go back."))))))
