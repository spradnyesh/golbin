(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun validate-login (username password)
  (let ((err0r nil))
    (cannot-be-empty username "username" err0r)
    (cannot-be-empty password "password" err0r)
    (when (and (not (is-null-or-empty username))
               (not (is-null-or-empty password)))
      (let ((author (verify-login username password)))
        (if author
            (return-from validate-login (values t author))
            (push (translate "invalid-username-password") err0r))))
    (values nil err0r)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; view functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-login-get ()
  (template
   :title "Login"
   :js nil
   :body (fmtnil (<:p :id "login-sub-hd"
                      (translate "login-existing"))
                 (<:div :class "wrapper"
                        :id "login"
                        (<:form :action (h-genurl 'r-login-post)
                                :method "POST"
                                (<:fieldset :class "inputs"
                                            (label-input "username" "text")
                                            (label-input "password" "password")
                                            (<:p (<:input :type "submit"
                                                          :name "submit"
                                                          :class "submit"
                                                          :value (translate "login"))))
                                (let ((lang (get-dimension-value "lang")))
                                  (if lang
                                      (translate "register-forgot"
                                                 (<:a :href (h-genurl 'r-register-get
                                                                      :lang lang)
                                                      (translate "join-us"))
                                                 (<:a :href (h-genurl 'r-password-get
                                                                      :lang lang)
                                                      (translate "forgot-password")))
                                      (redirect (h-genurl 'r-login-get :lang "en-IN")))))))))

(defun v-login-post (&key (ajax nil))
  (let ((username (post-parameter "username"))
        (password (post-parameter "password")))
    (multiple-value-bind (status err0r)
        (validate-login username password)
      (if status ; login validated, and author found
          (progn (start-session)
                 (setf (session-value :author) (handle err0r))
                 (setf (session-value :author-type) (author-type err0r))
                 (submit-success ajax
                                 (h-genurl 'r-home)))
          (submit-error ajax
                        err0r
                        (redirect (h-genurl 'r-login-get)))))))

(defun v-logout ()
  (with-ed-login
    (remove-session *session*)
    (redirect (h-genurl 'r-login-get))))
