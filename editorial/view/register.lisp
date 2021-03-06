(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-confirm-register-email-text (hash lang)
  (click-here "register-email"
              (h-gen-full-url 'r-register-do-confirm
                              :hash hash
                              :lang lang)))

(defun validate-register (email username password)
  (let ((err0r nil))
    (cannot-be-empty email "email" err0r
      (progn (if (get-author-by-email email)
                 (push (translate "email-already-exists") err0r)
                 (unless (validate-email email)
                   (push (translate "invalid-email") err0r)))))
    (cannot-be-empty username "username" err0r
      (if (get-author-by-username username)
          (push (translate "username-already-exists") err0r)
          (unless (string-equal username (slugify username))
            (push (translate "username-no-special-characters" "[/\\\"?~`!@#$%^&*()+=|{}':\;<,>.]") err0r))))
    (cannot-be-empty password "password" err0r)
    err0r))

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
               (when ,tooltip (tooltip ,tooltip)))))

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
                                  (why-register-tr 0 "ads-wait" "no" "yes" "yes" "no" "already-completed" "ads-wait-tltip")
                                  (why-register-tr 1 "ads-approval" "no" "yes" "yes" "no" "already-completed" "ads-approval-tltip")
                                  (why-register-tr 0 "seo" "no" "yes" "no" "yes" "we-do-it-for-you" "we-do-it-for-you-tltip")
                                  (why-register-tr 1 "performance" "no" "yes" "no" "yes" "we-do-it-for-you" "we-do-it-for-you-tltip")
                                  (why-register-tr 0 "income" "yes" "no" "100%" "70%" "income-dtls" nil)
                                  (why-register-tr 1 "hosting-cost" "no" "yes" "yes" "no" "we-do-it-for-you" "we-do-it-for-you-tltip")
                                  (why-register-tr 0 "marketing" "no" "yes" "no" "yes" "we-do-it-for-you" "we-do-it-for-you-tltip")
                                  (why-register-tr 1 "giant-shoulders" "no" "yes" "no" "yes" "giant-shoulders-dtls" "giant-shoulders-tltip")
                                  (why-register-tr 0 "min-pay-amt" "no" "yes" "yes" "no" "min-pay-amt-dtls" "min-pay-amt-tltip")
                                  (why-register-tr 1 "perf-reports" "no" "yes" "no" "yes" "perf-reports-dtls" "perf-reports-tltip")
                                  (why-register-tr 0 "write-once-earn-for-life" "yes" "yes" "yes" "yes" "write-once-earn-for-life-dtls" "write-once-earn-for-life-tltip")))
                (<:p (<:a :class "submit"
                          :href (h-genurl 'r-register-get)
                          (translate "register-here"))))))

(defun v-register-get ()
  (template
   :title "Register"
   :js nil
   :body (<:div :class "wrapper"
                :id "register"
                (<:p (<:a :href (h-genurl 'r-why-register) (translate "view-registeration-benefits")))
                (<:form :action (h-genurl 'r-register-post)
                        :method "POST"
                        (<:fieldset :class "inputs"
                                    (<:table
                                     (<:tbody
                                      (tr-td-input "email" :mandatory t)
                                      (<:tr (<:td (<:label :class "label" :for "username"
                                                           (translate "username")
                                                           (<:span :class "mandatory" "*")))
                                            (<:td (<:input :class "input" :type "text"
                                                           :name "username")))
                                      (tr-td-input "password" :typeof "password" :mandatory t)
                                      (<:tr (<:td)
                                            (<:td (translate "tnc-and-originality"
                                                             (<:a :href (h-genurl 'r-tnc) (translate "tnc"))
                                                             (<:a :href (h-genurl 'r-originality)
                                                                  (translate "originality")))))
                                      (tr-td-submit))))))))

(defun v-register-post (&key (ajax nil))
  (let* ((email (post-parameter "email"))
         (username (post-parameter "username"))
         (password (post-parameter "password"))
         (err0r (validate-register email username password)))
    (if (not err0r)
        (let* ((salt (generate-salt 32))
               (photo (md5-hash email))
               (hash (insecure-encrypt (concatenate 'string
                                                    email
                                                    "|"
                                                    salt)))
               (err0r "false"))
          (add-author (make-instance 'author
                                     :email email
                                     :username username
                                     :password (sha256-hash password)
                                     :salt salt
                                     :photo photo
                                     :status :a))
          (sendmail :to email
                    :subject (translate "confirm-registration")
                    :body (get-confirm-register-email-text hash (get-dimension-value "lang"))
                    :error-handle (setf err0r "true"))
          (submit-success ajax
                          (h-genurl 'r-register-hurdle
                                    :email (insecure-encrypt (concatenate 'string email "|" err0r)))))
        (submit-error ajax
                      err0r
                      (h-genurl 'r-register-get)))))

(defun v-register-hurdle (email)
  (let* ((ee (split-sequence "|" (insecure-decrypt email) :test #'string=))
         (email (first ee))
         (err0r (second ee)))
    (template
     :title "Register Hurdle"
     :js nil
     :body (<:div :class "wrapper"
                  (<:p (if (string= err0r "true")
                           (translate "confirmation-email-failed" email)
                           (translate "confirmation-email-sent" email)))))))

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
