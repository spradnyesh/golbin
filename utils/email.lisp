(in-package :hawksbill.utils)

(defmacro sendmail (&key to subject cc bcc attachments body package error-handle)
  (declare (ignore package))
  (let* ((acceptor (gensym)))
    `(progn
       (when (boundp '*acceptor*)
         (setf ,acceptor *acceptor*))
       ;; execute asynchronously
       (handler-case (do-in-background (send-email (get-config "site.email.host")
                                                   (get-config "site.email.address")
                                                   ,to
                                                   ,subject
                                                   ,body
                                                   :attachments ,attachments
                                                   :cc ,cc
                                                   :bcc ,bcc
                                                   :authentication (list (get-config "site.email.address")
                                                                         (get-config "site.email.password"))))
         (usocket:timeout-error ()
           (progn ,error-handle
                  (when ,acceptor
                    (log-message* :warning "failed to send email, to:[~a], subject:[~a], body:[~a]" ,to ,subject ,body))))))))
