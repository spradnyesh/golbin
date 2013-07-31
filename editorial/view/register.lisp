(in-package :hawksbill.golbin.editorial)

(defun validate-register ()
  nil)

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
                         (<:tbody (<:tr :class "t-odd"
                                        (<:td (translate "courier"))
                                        (<:td :class "no" (translate "yes"))
                                        (<:td :class "yes" (translate "no"))
                                        (<:td (translate "courier-dtls")
                                              (tooltip "courier-tltip")))
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
                                              (tooltip "perf-reports-tltip")))))
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
                                      (tr-td-input "email address"
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
                                            (<:td (<:input :class "input" :type "password2"
                                                           :name "password2")))
                                      (tr-td-input "name" :mandatory t)
                                      (tr-td-input "age" :mandatory t)
                                      (<:tr (<:td (<:label :class "label" :for "gender"
                                                           (translate "gender")
                                                           (<:span :class "mandatory" "*")))
                                            (<:td (<:select :class "input"
                                                            :name "gender"
                                                            (<:option :value "m" (translate "male"))
                                                            (<:option :value "f" (translate "female")))))
                                      (tr-td-input "street" :mandatory t)
                                      (tr-td-input "city" :mandatory t)
                                      (tr-td-input "state" :mandatory t)
                                      (tr-td-input "zipcode" :mandatory t)
                                      (tr-td-input "phone number" :mandatory t)
                                      (<:tr (<:td (<:input :type "submit"
                                                           :name "submit"
                                                           :class "submit"
                                                           :value "Register"))))))))))

#|(defun v-register-post (&key (ajax nil))
  (let* ((email-address (post-parameter "email-address"))
         (username (post-parameter "username"))
         (password (post-parameter "password"))
         (password2 (post-parameter "password2"))
         (name (post-parameter "name"))
         (handle (slugify name))
         (age (post-parameter "age"))
         (gender (post-parameter "gender"))
         (street (post-parameter "street"))
         (city (post-parameter "city"))
         (state (post-parameter "state"))
         (zipcode (post-parameter "zipcode"))
         (phone-number (post-parameter "phone-number"))
         (err0r (validate-register)))
    (if (not err0r)
        (let ((token (create-code-map)))
          (add-author (make-instance 'author
                                     :name name
                                     :alias name
                                     :username slug
                                     :handle slug
                                     :password (hash-password password)
                                     :token token
                                     :salt (generate-salt 32)
                                     :status :a))
          (create-code-map-image token slug)
          (submit-success ajax (h-genurl 'r-register-confirm)))
        ;; validation failed
        (submit-error ajax err0r (h-genurl 'r-article-new-get)))))|#
