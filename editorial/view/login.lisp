(in-package :hawksbill.golbin)

(defun ed-v-login-get ()
  (ed-page-template "Login"
    (:form :action (genurl 'ed-r-login)
           :method "POST"
           (str (label-input "name" "text"))
           (str (label-input "password" "text"))
           (:input :type "submit"
                   :name "submit"
                   :id "submit"
                   :value "Login"))))