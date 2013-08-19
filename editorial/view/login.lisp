(in-package :hawksbill.golbin.editorial)

(defun v-login-get ()
  (template
   :title "Login"
   :js nil
   :body (fmtnil (<:p :id "login-sub-hd"
                      (translate "login-existing"))
                 (<:form :action (h-genurl 'r-login-post)
                         :method "POST"
                         :id "login"
                         (<:fieldset :class "inputs"
                                     (label-input "username" "text")
                                     (label-input "password" "password")
                                     (<:p (<:input :type "submit"
                                                   :name "submit"
                                                   :class "submit"
                                                   :value (translate "login"))))
                         (let ((ed-lang (cookie-in "ed-lang")))
                           (if ed-lang
                               (translate "register-forgot"
                                          (<:a :href (h-genurl 'r-why-register
                                                               :lang ed-lang)
                                               (translate "join-us"))
                                          (<:a :href (h-genurl 'r-register-get
                                                               :lang ed-lang)
                                               (translate "forgot-password")))
                               (redirect (h-genurl 'r-login-get :lang "en-IN"))))))))

(defun v-login-post ()
  (let* ((username (post-parameter "username"))
         (password (post-parameter "password"))
         (author (verify-login username password)))
    (if author
        (progn
          (start-session)
          (setf (session-value :author) (handle author))
          (setf (session-value :author-type) (author-type author))
          (redirect (h-genurl 'r-home)))
        (redirect (h-genurl 'r-login-get)))))

(defun v-logout ()
  (with-ed-login
    (remove-session *session*)
    (redirect (h-genurl 'r-login-get))))
