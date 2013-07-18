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
                   (fmtnil (<:form :action (h-genurl 'r-login-post)
                                 :method "POST"
                                 (label-input "username" "text")
                                 (label-input "password" "password")
                                 (<:input :type "submit"
                                         :name "submit"
                                         :id "submit"
                                         :value "Login"))
                          (let ((ed-lang (cookie-in "ed-lang")))
                            (cond ((string= ed-lang "en-IN")
                                   (fmtnil (<:p
                                            (lang-a "en-IN" t "English")
                                            (lang-a "hi-IN" nil "हिन्दी")
                                            (lang-a "mr-IN" nil "मराठी"))
                                           (<:p
                                            (<:a :id "register" :href (h-genurl 'r-register-get
                                                                                :lang "en-IN")
                                                 (translate "register-here")))))
                                  ((string= ed-lang "hi-IN")
                                   (fmtnil (<:p
                                            (lang-a "en-IN" nil "English")
                                            (lang-a "hi-IN" t "हिन्दी")
                                            (lang-a "mr-IN" nil "मराठी"))
                                           (<:p
                                            (<:a :id "register" :href (h-genurl 'r-register-get
                                                                                :lang "hi-IN")
                                                 (translate "register-here")))))
                                  ((string= ed-lang "mr-IN")
                                   (fmtnil (<:p
                                            (lang-a "en-IN" nil "English")
                                            (lang-a "hi-IN" nil "हिन्दी")
                                            (lang-a "mr-IN" t "मराठी"))
                                           (<:p
                                            (<:a :id "register" :href (h-genurl 'r-register-get
                                                                                :lang "mr-IN")
                                                 (translate "register-here")))))
                                  (t (redirect (h-genurl 'r-login-get :lang "en-IN")))))))))))

(defun v-login-post ()
  (let ((username (post-parameter "username"))
        (password (post-parameter "password")))
    (multiple-value-bind (logged-in author) (verify-login username password)
      (if logged-in
          (progn
            (start-session)
            (setf (session-value :author) (handle author))
            (setf (session-value :author-type) (author-type author))
            (redirect (h-genurl 'r-home)))
          (redirect (h-genurl 'r-login-get))))))

(defun v-logout ()
  (with-ed-login
    (remove-session *session*)
    (redirect (h-genurl 'r-login-get))))
