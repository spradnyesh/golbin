(in-package :hawksbill.utils)

(defmacro sendmail (&key to subject cc bcc attachments body package error-handle)
  (let ((template (intern (string-upcase "template") (symbol-package package))))
    `(handler-case (send-email (get-config "site.email.host")
                                       (get-config "site.email.address")
                                       ,to
                                       ,subject
                                       (,template :title (translate "confirm-registration-email-header")
                                                  :body ,body
                                                  :email t)
                                       :attachments ,attachments
                                       :cc ,cc
                                       :bcc ,bcc
                                       :authentication (list (get-config "site.email.address")
                                                             (get-config "site.email.password")))
               (usocket:timeout-error ()
                 (progn ,error-handle
                        (when *acceptor*
                          (log-message* :warning "failed to send email, to:[~a], subject:[~a], body:[~a]" ,to ,subject ,body)))))))
