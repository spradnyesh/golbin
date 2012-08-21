(in-package :hawksbill.golbin.editorial)

(defun v-login-get ()
  (ed-page-template "Login"
      nil
      nil
    (if (is-logged-in?)
        (redirect (genurl 'r-home))
        (htm (:form :action (genurl 'r-login-post)
                    :method "POST"
                    (str (label-input "username" "text"))
                    (str (label-input "password" "password"))
                    (:input :type "submit"
                            :name "submit"
                            :id "submit"
                            :value "Login"))))))

(defun v-login-post ()
  (let ((username (post-parameter "username"))
        (password (post-parameter "password")))
    (multiple-value-bind (logged-in author) (verify-login username password)
      (if logged-in
       (progn
         (start-session)
         (setf (session-value :user) (handle author))
         (redirect (genurl 'r-home))
         (redirect (genurl 'r-login-get)))))))

(defun v-logout ()
  (with-ed-login
    (remove-session *session*)
    (redirect (genurl 'r-login-get))))
