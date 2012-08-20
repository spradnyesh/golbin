(in-package :hawksbill.golbin.editorial)

(defun v-home ()
  (with-ed-login
    (ed-page-template "Home"
        t
        nil
      (:div (:pre (str (session-value :username)))
            (:p "Hello World!")))))