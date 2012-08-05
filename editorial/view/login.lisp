(in-package :hawksbill.golbin.editorial)

(defun v-login-get ()
  (ed-page-template "Login"
    (:form :action (genurl 'r-login)
           :method "POST"
           (str (label-input "name" "text"))
           (str (label-input "password" "text"))
           (:input :type "submit"
                   :name "submit"
                   :id "submit"
                   :value "Login"))))
