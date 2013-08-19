(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-confirm-register-email-text (hash lang)
  (click-here "register-email"
              (h-gen-full-url 'r-register-do-confirm
                              :hash hash
                              :lang lang)))

(defun validate-register (email username password password2 name age gender phone-number)
  (let ((err0r nil))
    (cannot-be-empty email "email" err0r)
    (cannot-be-empty username "username" err0r)
    (cannot-be-empty password "password" err0r)
    (cannot-be-empty password2 "re-password" err0r)
    (cannot-be-empty name "name" err0r)
    (cannot-be-empty age "age" err0r)
    (cannot-be-empty gender "gender" err0r)
    (cannot-be-empty phone-number "phone-number" err0r)
    (unless (validate-email email)
      (push (translate "invalid-email") err0r))
    (when (get-author-by-username username)
      (push (translate "username-already-exists") err0r))
    (when (get-author-by-email email)
      (push (translate "email-already-exists") err0r))
    (when (not (string-equal password password2))
      (push (translate "passwords-no-match") err0r))
    (when (not (or (string= gender "m")(string= gender "f")))
      (push (translate "invalid-gender") err0r))
    (reverse err0r)))

(defmacro why-register-tr (odd-even key class-1 class-2 value-1 value-2 desc tooltip)
  `(<:tr :class (concatenate 'string
                             "t-"
                             (if (zerop ,odd-even)
                                 "even"
                                 "odd"))
         (<:td (translate ,key))
         (<:td :class ,class-1 (translate ,value-1))
         (<:td :class ,class-2 (translate ,value-2))
         (<:td (translate ,desc)
               (tooltip ,tooltip))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; view functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-why-register-get ()
  (template
   :title "Why Register"
   :js nil
   :body (<:div :class "wrapper"
                (<:table (<:thead (<:tr :class "t-head"
                                        (<:td)
                                        (<:td (<:strong (translate "google"))
                                              (tooltip "google-ads"))
                                        (<:td (<:strong (translate "golbin")))
                                        (<:td (<:strong (translate "details")))))
                         (<:tbody (why-register-tr 1 "courier" "no" "yes" "yes" "no" "courier-dtls" "courier-tltip")
                                  (<:tr :class "t-even"
                                        (<:td (translate "ads-wait"))
                                        (<:td :class "no" (translate "yes"))
                                        (<:td :class "yes" (translate "no"))
                                        (<:td (translate "already-complted")
                                              (tooltip "ads-wait-tltip")))
                                  (<:tr :class "t-odd"
                                        (<:td (translate "ads-approval"))
                                        (<:td :class "no" (translate "yes"))
                                        (<:td :class "yes" (translate "no"))
                                        (<:td (translate "already-complted")
                                              (tooltip "ads-approval-tltip")))
                                  (<:tr :class "t-even"
                                        (<:td (translate "seo"))
                                        (<:td :class "no" (translate "no"))
                                        (<:td :class "yes" (translate "yes"))
                                        (<:td (translate "we-do-it-for-you")
                                              (tooltip "we-do-it-for-you-tltip")))
                                  (<:tr :class "t-odd"
                                        (<:td (translate "performance"))
                                        (<:td :class "no" (translate "no"))
                                        (<:td :class "yes" (translate "yes"))
                                        (<:td (translate "we-do-it-for-you")
                                              (tooltip "we-do-it-for-you-tltip")))
                                  (<:tr :class "t-even"
                                        (<:td (translate "income"))
                                        (<:td :class "yes" "100%")
                                        (<:td :class "no" "70%")
                                        (<:td (translate "income-dtls")))
                                  (<:tr :class "t-odd"
                                        (<:td (translate "hosting-cost"))
                                        (<:td :class "no" (translate "yes"))
                                        (<:td :class "yes" (translate "no"))
                                        (<:td (translate "we-do-it-for-you")
                                              (tooltip "we-do-it-for-you-tltip")))
                                  (<:tr :class "t-even"
                                        (<:td (translate "marketing"))
                                        (<:td :class "no" (translate "no"))
                                        (<:td :class "yes" (translate "yes"))
                                        (<:td (translate "we-do-it-for-you")
                                              (tooltip "we-do-it-for-you-tltip")))
                                  (<:tr :class "t-odd"
                                        (<:td (translate "giant-shoulders"))
                                        (<:td :class "no" (translate "no"))
                                        (<:td :class "yes" (translate "yes"))
                                        (<:td (translate "giant-shoulders-dtls")
                                              (tooltip "giant-shoulders-tltip")))
                                  (<:tr :class "t-even"
                                        (<:td (translate "min-pay-amt"))
                                        (<:td :class "no" (translate "yes"))
                                        (<:td :class "yes" (translate "no"))
                                        (<:td (translate "min-pay-amt-dtls")
                                              (tooltip "min-pay-amt-tltip")))
                                  (<:tr :class "t-odd"
                                        (<:td (translate "perf-reports"))
                                        (<:td :class "no" (translate "no"))
                                        (<:td :class "yes" (translate "yes"))
                                        (<:td (translate "perf-reports-dtls")
                                              (tooltip "perf-reports-tltip")))
                                  (<:tr :class "t-even"
                                        (<:td (translate "write-once-earn-for-life"))
                                        (<:td :class "yes" (translate "yes"))
                                        (<:td :class "yes" (translate "yes"))
                                        (<:td (translate "write-once-earn-for-life-dtls")
                                              (tooltip "write-once-earn-for-life-tltip")))))
                (<:p (<:a :class "submit"
                          :href (h-genurl 'r-register-get)
                          (translate "register-here"))))))

(defun v-register-get ()
  (template
   :title "Register"
   :js nil
   :body (<:div :class "wrapper"
                :id "register"
                (<:form :action (h-genurl 'r-register-post)
                        :method "POST"
                        (<:fieldset :class "inputs"
                                    (<:table
                                     (<:tbody
                                      (tr-td-input "name" :mandatory t)
                                      (tr-td-input "age" :mandatory t)
                                      (tr-td-input "email"
                                                   :mandatory t)
                                      (<:tr (<:td (<:label :class "label" :for "username"
                                                           (translate "username")
                                                           (<:span :class "mandatory" "*")))
                                            (<:td (<:input :class "input" :type "text"
                                                           :name "username")
                                                  (tooltip (translate "check-if-username-exists"))))
                                      (tr-td-input "alias"
                                                   :tooltip "alias")
                                      (tr-td-input "password" :typeof "password" :mandatory t)
                                      (<:tr (<:td (<:label :class "label" :for "password2"
                                                           (translate "retype-password")
                                                           (<:span :class "mandatory" "*")))
                                            (<:td (<:input :class "input" :type "password"
                                                           :name "password2")))
                                      (<:tr (<:td (<:label :class "label" :for "gender"
                                                           (translate "gender")
                                                           (<:span :class "mandatory" "*")))
                                            (<:td (<:select :class "input"
                                                            :name "gender"
                                                            (<:option :value "m" (translate "male"))
                                                            (<:option :value "f" (translate "female")))))
                                      (tr-td-input "phone number" :mandatory t)
                                      (<:tr (<:td (<:input :type "submit"
                                                           :name "submit"
                                                           :class "submit"
                                                           :value "Register"))))))))))

(defun v-register-post (&key (ajax nil))
  (let* ((email (post-parameter "email"))
         (username (post-parameter "username"))
         (alias (post-parameter "alias"))
         (password (post-parameter "password"))
         (password2 (post-parameter "password2"))
         (name (post-parameter "name"))
         (handle (slugify username))
         (age (post-parameter "age"))
         (gender (post-parameter "gender"))
         (phone-number (post-parameter "phone-number"))
         (err0r (validate-register email
                                   username
                                   password
                                   password2
                                   name
                                   age
                                   gender
                                   phone-number)))
    (if (not err0r)
        (let* ((salt (generate-salt 32))
               (token (create-code-map))
               (hash (insecure-encrypt (concatenate 'string
                                              email
                                              "|"
                                              salt)))
               (filename (create-code-map-image token handle)))
          (add-author (make-instance 'author
                                     :email email
                                     :username username
                                     :alias alias
                                     :password (hash-password password)
                                     :name name
                                     :handle handle
                                     :age age
                                     :gender gender
                                     :phone phone-number
                                     :token token
                                     :salt salt
                                     :status :d))
          (sendmail :to email
                    :subject (translate "confirm-registration")
                    :body (get-confirm-register-email-text hash (cookie-in "ed-lang"))
                    :package hawksbill.golbin.editorial
                    :attachments (list filename))
          (submit-success ajax
                          (h-genurl 'r-register-hurdle
                                    :email (insecure-encrypt email))))
        ;; validation failed
        (submit-error ajax
                      err0r
                      (h-genurl 'r-register-get)))))

(defun v-register-hurdle (email)
  (template
   :title "Register Hurdle"
   :js nil
   :body (<:div :class "wrapper"
                (<:p (translate "confirmation-email-sent"
                                (insecure-decrypt email))))))

(defun v-register-do-confirm (hash)
  (let* ((es (split-sequence "|" (insecure-decrypt hash) :test #'string=))
         (email (first es))
         (salt (second es)))
    (if (find-author-by-email-salt email salt)
        (redirect (h-genurl 'r-register-done-confirm
                            :status "yes"))
        (redirect (h-genurl 'r-register-done-confirm
                            :status "no")))))

(defun v-register-done-confirm (status)
  (let ((status status))
    (template
     :title "Register Hurdle"
     :js nil
     :body (<:div :class "wrapper"
                  (if (string-equal "yes" status)
                      (let ((route (h-genurl 'r-login-get)))
                        (fmtnil (timed-redirect)
                                (<:p (click-here "registration-complete"
                                                 route))))
                      (let ((route (h-genurl 'r-register-get)))
                        (fmtnil (timed-redirect)
                                (<:p (click-here "registration-failed"
                                                 route)))))))))
