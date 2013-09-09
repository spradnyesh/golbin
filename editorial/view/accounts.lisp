(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun validate-account-password (current-password old-password new-password new-password-2)
  (let ((err0r nil))
    (cannot-be-empty old-password "old-password" err0r)
    (cannot-be-empty new-password "new-password" err0r)
    (cannot-be-empty new-password-2 "new-password-2" err0r)
    (unless (string= old-password current-password)
      (push (translate "wrong-current-password") err0r))
    (when (string= (hash-password new-password) current-password)
      (push (translate "current-new-passwords-cannot-be-same") err0r))
    (unless (string= new-password new-password-2)
      (push (translate "new-passwords-dont-match") err0r))
    err0r))

(defun validate-account-email (email author)
  (let ((err0r nil))
    (when (string= email (email author))
      (push (translate "same-as-old-email") err0r))
    (unless (validate-email email)
      (push (translate "invalid-email") err0r))
    err0r))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; password view functions
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
         (author (who-am-i))
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
                    :body (translate "password-changed-email"))
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
   :body (<:div :class "wrapper"
                (if (string= status "yes")
                    (translate "password-changed")
                    (translate "password-not-changed")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; email view functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
         (author (who-am-i))
         (err0r (validate-account-email email author)))
    (if (not err0r)
        (let* ((salt (salt author))
               (hash (insecure-encrypt (concatenate 'string
                                                    (email author) ; old-email
                                                    "|"
                                                    email ; new-email
                                                    "|"
                                                    salt))))
          (sendmail :to email
                    :subject (translate "confirm-email-change")
                    :body (click-here "change-email-email"
                                      (h-gen-full-url 'r-account-email-verify
                                                      :hash hash
                                                      :lang (get-dimension-value "lang"))))
          (submit-success ajax
                          (h-genurl 'r-account-email-hurdle
                                    :email (insecure-encrypt email))))
        (submit-error ajax
                      err0r
                      (redirect (h-genurl 'r-account-email-get))))))

(defun v-account-email-hurdle (email)
  (template
   :title (translate "change-email")
   :js nil
   :body (<:div :class "wrapper"
                (<:p (translate "confirmation-email-sent"
                                (insecure-decrypt email))))))

(defun v-account-email-verify (hash)
  (let* ((ees (split-sequence "|" (insecure-decrypt hash) :test #'string=))
         (old-email (first ees))
         (new-email (second ees))
         (salt (third ees))
         (author (find-author-by-email-salt old-email salt)))
    (if author
        (progn
          (setf (email author) new-email)
          (edit-author author)
          (sendmail :to new-email
                    :cc old-email
                    :subject (translate "email-changed-subject")
                    :body (translate "email-changed-body" old-email new-email))
          (redirect (h-genurl 'r-account-email-done
                              :status "yes")))
        (redirect (h-genurl 'r-account-email-done
                            :status "no")))))

(defun v-account-email-done (status)
  (template
   :title (translate "change-email")
   :js nil
   :body (if (string= status "yes")
      (translate "email-changed")
      (translate "email-not-changed"))))
