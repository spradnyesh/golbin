(in-package :hawksbill.golbin.editorial)

(defun v-login-get ()
  (let ((lang (get-parameter "lang")))
    (if lang
        (progn
          (set-cookie "ed-lang"
                      :path "/"
                      :value lang)
          (redirect (h-genurl 'r-login-get)))
        (template
         :title "Login"
         :logged-in nil
         :js nil
         :body (if (is-logged-in?)
                   (redirect (h-genurl 'r-home))
                   (fmtnil
                    (<:p :id "login-sub-hd"
                           (translate "login-existing"))
                    (<:form :action (h-genurl 'r-login-post)
                            :method "POST"
                            :id "login"
                            (<:fieldset :class "inputs"
                                        (label-input "username" "text")
                                        (label-input "password" "password")
                                        (<:p (<:input :type "submit"
                                                      :name "submit"
                                                      :id "submit"
                                                      :value "Login")))
                            (let ((ed-lang (cookie-in "ed-lang")))
                                                 (if ed-lang
                                                     (translate "register-forgot"
                                                      (<:a :id "register"
                                                           :href (h-genurl 'r-register-get
                                                                           :lang ed-lang)
                                                           (translate "register-here"))
                                                      (<:a :id "forgot"
                                                           :href (h-genurl 'r-register-get
                                                                           :lang ed-lang)
                                                           (translate "forgot-password")))
                                                     (redirect (h-genurl 'r-login-get :lang "en-IN")))))))))))

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
