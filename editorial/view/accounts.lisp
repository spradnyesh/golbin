(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; view functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-account-password-get ())

(defun v-account-password-post ())

(defun v-account-password-done ())

(defun v-account-email-get ()
  (template
   :title (translate "change-email")
   :js nil
   :body (<:form :action (h-genurl 'r-account-email-post)
                         :method "POST"
                         :id "email"
                         (<:fieldset :class "inputs"
                                     (label-input "new-email" "text")
                                     (<:p (<:input :type "submit"
                                                   :name "submit"
                                                   :class "submit"
                                                   :value (translate "submit")))))))

(defun v-account-email-post (&key (ajax nil))
  (let* ((email (post-parameter "new-email"))
         (author (get-author-by-handle (session-value :author)))
         (err0r nil)
         (err0r (unless (validate-email email)
                  (push (translate "invalid-email") err0r))))
    (if (not err0r)
        (progn
          (setf (email author) email)
          (edit-author author)
          (submit-success ajax
                          (h-genurl 'r-account-email-done
                                    :status "yes")))
        (submit-error ajax
                      err0r
                      (redirect (h-genurl 'r-account-email-done
                                          :status "no"))))))

(defun v-account-email-done (status)
  (template
   :title (translate "change-emaili")
   :js nil
   :body (if (string= status "yes")
      (translate "email-changed")
      (translate "email-not-changed"))))

(defun v-account-token-get ())

(defun v-account-token-post ())

(defun v-account-token-done ())
