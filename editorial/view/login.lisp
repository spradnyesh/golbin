(in-package :hawksbill.golbin.editorial)

(defmacro lang-a (lang selected lang-name)
  (let ((class (when (or (string= lang "hi-IN")
                         (string= lang "mr-IN"))
                 "dvngr")))
    `(<:a :class (if ,selected
                    (concatenate 'string ,class " lang-selected")
                    ,class)
         :href (h-genurl 'r-login-get
                         :lang ,lang)
         ,lang-name)))

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
                    (<:form :action (h-genurl 'r-login-post)
                            :method "POST"
                            :id "login"
                            (<:fieldset :class "inputs"
                                        (<:ol (<:li (label-input "username" "text"))
                                              (<:li (label-input "password" "password"))))
                            (<:fieldset :class "actions"
                                        (<:ol (<:li (<:input :type "submit"
                                                             :name "submit"
                                                             :id "submit"
                                                             :value "Login"))
                                              (<:li
                                               (let ((ed-lang (cookie-in "ed-lang")))
                                                 (if ed-lang
                                                     (<:a :id "register"
                                                          :href (h-genurl 'r-register-get
                                                                          :lang ed-lang)
                                                          (translate "register-here"))
                                                     (redirect (h-genurl 'r-login-get :lang "en-IN"))))))))))))))

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
