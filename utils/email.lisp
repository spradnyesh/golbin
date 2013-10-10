(in-package :hawksbill.utils)

(defmacro sendmail (&key to subject cc bcc attachments body package error-handle)
  (declare (ignore package))
  `(handler-case (with-timeout ((parse-integer (get-config "site.timeout.email")))
                   (send-email (get-config "site.email.host")
                               (get-config "site.email.address")
                               ,to
                               ,subject
                               ,body
                               :attachments ,attachments
                               :cc ,cc
                               :bcc ,bcc
                               :authentication (list (get-config "site.email.address")
                                                     (get-config "site.email.password"))))
     (trivial-timeout:timeout-error ()
       (progn ,error-handle
              (when (and (boundp '*acceptor*) *acceptor*)
                (log-message* :warning "failed to send email, to:[~a], subject:[~a], body:[~a]" ,to ,subject ,body))))
     (usocket:timeout-error ()
       (progn ,error-handle
              (when (and (boundp '*acceptor*) *acceptor*)
                (log-message* :warning "failed to send email, to:[~a], subject:[~a], body:[~a]" ,to ,subject ,body))))))
