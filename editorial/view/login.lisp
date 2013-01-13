(in-package :hawksbill.golbin.editorial)

(defun v-login-get ()
  (let ((lang (get-parameter "lang")))
    (if lang
        (progn
          (set-cookie "ed-lang"
                      :path "/"
                      :value lang)
          (redirect (h-genurl 'r-login-get)))
        (ed-page-template "Login"
            nil
            nil
          (if (is-logged-in?)
              (redirect (h-genurl 'r-home))
              (htm (:form :action (h-genurl 'r-login-post)
                          :method "POST"
                          (str (label-input "username" "text"))
                          (str (label-input "password" "password"))
                          (:input :type "submit"
                                  :name "submit"
                                  :id "submit"
                                  :value "Login"))
                   (:a :id "english" :href (h-genurl 'r-login-get
                                                     :lang "en-IN") "English")
                   (:a :id "hindi" :class "dvngr" :href (h-genurl 'r-login-get
                                                                       :lang "hi-IN") "हिन्दी")
                   (:a :id "marathi" :class "dvngr" :href (h-genurl 'r-login-get
                                                                         :lang "mr-IN") "मराठी")))))))

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
