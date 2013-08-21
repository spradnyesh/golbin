(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun validate-account-password (current-password old-password new-password new-password-2)
  (let ((err0r nil))
    (unless (string= old-password current-password)
      (push (translate "wrong-current-password") err0r))
    (unless (string= new-password new-password-2)
      (push (translate "new-passwords-dont-match") err0r))
    err0r))

(defun validate-account-email (email)
  (let ((err0r nil))
    (unless (validate-email email)
      (push (translate "invalid-email") err0r))
    err0r))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; view functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-account-password-get ()
  (template
   :title (translate "change-password")
   :js nil
   :body (<:div :id "accounts"
                (<:form :action (h-genurl 'r-account-password-post)
                        :method "POST"
                        :id "password"
                        (<:fieldset :class "inputs"
                                    (label-input "current-password" "password")
                                    (label-input "new-password" "password")
                                    (label-input "re-enter-password" "password")
                                    (<:p (<:input :type "submit"
                                                  :name "submit"
                                                  :class "submit"
                                                  :value (translate "submit"))))))))

(defun v-account-password-post (&key (ajax nil))
  (let* ((old-password (post-parameter "current-password"))
         (new-password (post-parameter "new-password"))
         (new-password-2 (post-parameter "re-enter-password"))
         (author (get-author-by-handle (session-value :author)))
         (err0r (validate-account-password (password author)
                                           (hash-password old-password)
                                           new-password
                                           new-password-2)))
    (if (not err0r)
        (progn
          (setf (password author) (hash-password new-password))
          (setf (salt author) (generate-salt 32))
          (edit-author author)
          (sendmail :to (email author)
                    :subject (translate "password-changed")
                    :body (translate "password-changed-email")
                    :package hawksbill.golbin.editorial)
          (submit-success ajax
                          (h-genurl 'r-account-password-done
                                    :status "yes")))
        (submit-error ajax
                      err0r
                      (redirect (h-genurl 'r-account-password-done
                                          :status "no"))))))

(defun v-account-password-done (status)
  (template
   :title (translate "change-password")
   :js nil
   :body (if (string= status "yes")
      (translate "password-changed")
      (translate "password-not-changed"))))

(defun v-account-email-get ()
  (template
   :title (translate "change-email")
   :js nil
   :body (<:div :id "accounts"
                (<:form :action (h-genurl 'r-account-email-post)
                                       :method "POST"
                                       :id "email"
                                       (<:fieldset :class "inputs"
                                                   (label-input "new-email" "text")
                                                   (<:p (<:input :type "submit"
                                                                 :name "submit"
                                                                 :class "submit"
                                                                 :value (translate "submit"))))))))

(defun v-account-email-post (&key (ajax nil))
  (let* ((email (post-parameter "new-email"))
         (author (get-author-by-handle (session-value :author)))
         (err0r (validate-account-email email)))
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
   :title (translate "change-email")
   :js nil
   :body (if (string= status "yes")
      (translate "email-changed")
      (translate "email-not-changed"))))

(defun v-account-token-get ()
  (template
   :title (translate "change-token")
   :js nil
   :body (<:div :id "accounts"
                (<:form :action (h-genurl 'r-account-token-post)
                        :method "POST"
                        :id "token"
                        (<:fieldset :class "inputs"
                                    (<:p (translate "re-generate-email-token"))
                                    (<:p (<:input :type "submit"
                                                  :name "submit"
                                                  :class "submit"
                                                  :value (translate "submit"))))))))

(defun v-account-token-post (&key (ajax nil))
  (let* ((token (create-code-map))
         (author (get-author-by-handle (session-value :author)))
         (filename (create-code-map-image token (handle author))))
    (setf (token author) token)
    (edit-author author)
    (sendmail :to (email author)
              :subject (translate "confirm-registration")
              :body (translate "new-token-email")
              :package hawksbill.golbin.editorial
              :attachments (list filename))
    (submit-success ajax
                    (h-genurl 'r-account-token-done
                              :status "yes"))))

(defun v-account-token-done (status)
  (template
   :title (translate "change-token")
   :js nil
   :body (<:div :class "wrapper"
                (if (string= status "yes")
                    (translate "token-changed")
                    (translate "token-not-changed")))))
