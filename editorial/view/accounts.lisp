(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun validate-account (name city state country zipcode)
  (let ((err0r nil))
    (cannot-be-empty name "name" err0r)
    (cannot-be-empty city "city" err0r)
    (cannot-be-empty state "state" err0r)
    (cannot-be-empty country "country" err0r)
    (cannot-be-empty zipcode "zipcode" err0r
      (progn
        (handler-case (parse-integer zipcode)
          (sb-int:simple-parse-error ()
            (push (translate "invalid-zipcode") err0r)))
        (unless (< 3 (length zipcode) 8)
          (push (translate "invalid-zipcode") err0r))))
    err0r))

(defun validate-account-password (current-password old-password new-password)
  (let ((err0r nil))
    (cannot-be-empty old-password "old-password" err0r)
    (cannot-be-empty new-password "new-password" err0r)
    (unless (string= old-password current-password)
      (push (translate "wrong-current-password") err0r))
    (when (string= (sha256-hash new-password) current-password)
      (push (translate "current-new-passwords-cannot-be-same") err0r))
    err0r))

(defun validate-account-email (email author)
  (let ((err0r nil))
    (when (string= email (email author))
      (push (translate "same-as-old-email") err0r))
    (unless (validate-email email)
      (push (translate "invalid-email") err0r))
    err0r))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; account view functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-account-get ()
  (let ((author (who-am-i)))
    (template
     :title "change-account-details"
     :js (ck-js lang)
     :body (<:div :id "accounts"
                  (<:form :action (h-genurl 'r-account-post)
                          :method "POST"
                          (<:table (tr-td-input "name"
                                                :value (name author)
                                                :tooltip "name-match-bank-paypal")
                                   (tr-td-input "username"
                                                :value (username author)
                                                :disabled t
                                                :tooltip "cannot-change")
                                   (<:tr (<:td (<:label :class "label"
                                                        :for "password"
                                                        (translate "password")))
                                         (<:td (<:a :href (h-genurl 'r-account-password-get)
                                                    (translate "change-password"))))
                                   (<:tr (<:td (<:label :class "label"
                                                        :for "email"
                                                        (translate "email")))
                                         (<:td (<:a :href (h-genurl 'r-account-email-get)
                                                    (translate "change-email"))))
                                   (<:tr (<:td (<:label :class "label"
                                                        :for "photo"
                                                        (translate "photo")))
                                         (<:td (let ((photo (photo author)))
                                                 (if (find #\. photo)
                                                     ;; uploaded image
                                                     (fmtnil (<:img :alt (username author)
                                                                    :src (build-sized-image "/static/photos/"
                                                                                            photo
                                                                                            (write-to-string (get-config "photo.author.avatar"))))
                                                             (<:a :href "#"
                                                                  :id "upload-author-photo"
                                                                  (translate "change-photo"))
                                                             (<:a :href (h-genurl 'r-ajax-author-photo-reset)
                                                                  :id "gravatar-author-photo"
                                                                  (translate "reset-photo")))
                                                     ;; gravatar
                                                     (fmtnil (build-gravtar-image photo
                                                                                  (username author)
                                                                                  (write-to-string (get-config "photo.author.avatar")))
                                                             (<:a :href "#"
                                                                  :id "upload-author-photo"
                                                                  (translate "change-photo")))))))
                                   (<:tr (<:td (<:label :class "label"
                                                        :for "background"
                                                        (translate "background")))
                                         (<:td (let ((background (background author)))
                                                 (fmtnil (when background
                                                           ;; uploaded image
                                                           (<:img :src (build-sized-image "/static/photos/"
                                                                                          background
                                                                                          (write-to-string (get-config "photo.author.background")))))
                                                         (<:a :href "#"
                                                              :id "upload-author-background"
                                                              (translate "change-background"))))))
                                   (tr-td-text "description"
                                               :class "ckeditor"
                                               :value (description author))
                                   (tr-td-input "street"
                                                :value (street author))
                                   (tr-td-input "city"
                                                :value (city author)
                                                :mandatory t)
                                   (tr-td-input "state"
                                                :value (state author)
                                                :mandatory t)
                                   (tr-td-input "country"
                                                :value (country author)
                                                :mandatory t)
                                   (tr-td-input "zipcode"
                                                :value (zipcode author)
                                                :mandatory t)
                                   (tr-td-input "bank-name"
                                                :value (bank-name author)
                                                :tooltip "bank-or-paypal")
                                   (tr-td-input "bank-branch"
                                                :value (bank-branch author)
                                                :tooltip "bank-or-paypal")
                                   (tr-td-input "bank-account-no"
                                                :value (bank-account-no author)
                                                :tooltip "bank-or-paypal")
                                   (tr-td-input "bank-ifsc"
                                                :value (bank-ifsc author)
                                                :tooltip "bank-or-paypal")
                                   (tr-td-input "paypal-userid"
                                                :value (paypal-userid author)
                                                :tooltip "bank-or-paypal")
                                   (tr-td-submit)))))))

(defun v-account-post (&key (ajax nil))
  (let* ((name (post-parameter "name"))
         (description (update-anchors (cleanup-ckeditor-text (post-parameter "description"))))
         (street (post-parameter "street"))
         (city (post-parameter "city"))
         (state (post-parameter "state"))
         (country (post-parameter "country"))
         (zipcode (post-parameter "zipcode"))
         (bank-name (post-parameter "bank-name"))
         (bank-branch (post-parameter "bank-branch"))
         (bank-account-no (post-parameter "bank-account-no"))
         (bank-ifsc (post-parameter "bank-ifsc"))
         (paypal-userid (post-parameter "paypal-userid"))
         (author (who-am-i))
         (err0r (validate-account name city state country zipcode)))
    (if (not err0r)
        (progn
          (edit-author (make-instance 'author
                                      :id (id author)
                                      :username (username author)
                                      :password (password author)
                                      :salt (salt author)
                                      :name name
                                      :status (status author)
                                      :email (email author)
                                      :description description
                                      :street street
                                      :city city
                                      :state state
                                      :country country
                                      :zipcode zipcode
                                      :bank-name bank-name
                                      :bank-branch bank-branch
                                      :bank-account-no bank-account-no
                                      :bank-ifsc bank-ifsc
                                      :paypal-userid paypal-userid))
          (submit-success ajax
                          (h-genurl 'r-account-get)))
        (submit-error ajax
                      err0r
                      (redirect (h-genurl 'r-account-get))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; password view functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-account-password-get ()
  (template
   :title "change-password"
   :js nil
   :body (<:div :id "accounts"
                (<:form :action (h-genurl 'r-account-password-post)
                        :method "POST"
                        :id "password"
                        (<:fieldset :class "inputs"
                                    (label-input "current-password" "password")
                                    (label-input "new-password" "password")
                                    (<:p (<:input :type "submit"
                                                  :name "submit"
                                                  :class "submit"
                                                  :value (translate "submit"))))))))

(defun v-account-password-post (&key (ajax nil))
  (let* ((old-password (post-parameter "current-password"))
         (new-password (post-parameter "new-password"))
         (author (who-am-i))
         (err0r (validate-account-password (password author)
                                           (sha256-hash old-password)
                                           new-password)))
    (if (not err0r)
        (progn
          (setf (password author) (sha256-hash new-password))
          (setf (salt author) (generate-salt 32))
          (edit-author author)
          (sendmail :to (email author)
                    :subject (translate "password-changed")
                    :body (translate "password-changed-email"))
          (submit-success ajax
                          (h-genurl 'r-account-password-done
                                    :status "yes")))
        (submit-error ajax
                      err0r
                      (redirect (h-genurl 'r-account-password-done
                                          :status "no"))))))

(defun v-account-password-done (status)
  (template
   :title "change-password"
   :js nil
   :body (<:div :class "wrapper"
                (if (string= status "yes")
                    (translate "password-changed")
                    (translate "password-not-changed")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; email view functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-account-email-get ()
  (template
   :title "change-email"
   :js nil
   :body (<:div :id "accounts"
                (<:form :action (h-genurl 'r-account-email-post)
                        :method "POST"
                        :id "email"
                        (<:fieldset :class "inputs"
                                    (label-input "new-email" "text" :tooltip "needs-verification")
                                    (<:p (<:input :type "submit"
                                                  :name "submit"
                                                  :class "submit"
                                                  :value (translate "submit"))))))))

(defun v-account-email-post (&key (ajax nil))
  (let* ((email (post-parameter "new-email"))
         (author (who-am-i))
         (err0r (validate-account-email email author)))
    (if (not err0r)
        (let* ((salt (salt author))
               (hash (insecure-encrypt (concatenate 'string
                                                    (email author) ; old-email
                                                    "|"
                                                    email ; new-email
                                                    "|"
                                                    salt))))
          (sendmail :to email
                    :subject (translate "confirm-email-change")
                    :body (click-here "change-email-email"
                                      (h-gen-full-url 'r-account-email-verify
                                                      :hash hash
                                                      :lang (get-dimension-value "lang"))))
          (submit-success ajax
                          (h-genurl 'r-account-email-hurdle
                                    :email (insecure-encrypt email))))
        (submit-error ajax
                      err0r
                      (redirect (h-genurl 'r-account-email-get))))))

(defun v-account-email-hurdle (email)
  (template
   :title "change-email"
   :js nil
   :body (<:div :class "wrapper"
                (<:p (translate "confirmation-email-sent"
                                (insecure-decrypt email))))))

(defun v-account-email-verify (hash)
  (let* ((ees (split-sequence "|" (insecure-decrypt hash) :test #'string=))
         (old-email (first ees))
         (new-email (second ees))
         (salt (third ees))
         (author (find-author-by-email-salt old-email salt)))
    (if author
        (progn
          (setf (email author) new-email)
          (edit-author author)
          (sendmail :to new-email
                    :cc old-email
                    :subject (translate "email-changed-subject")
                    :body (translate "email-changed-body" old-email new-email))
          (redirect (h-genurl 'r-account-email-done
                              :status "yes")))
        (redirect (h-genurl 'r-account-email-done
                            :status "no")))))

(defun v-account-email-done (status)
  (template
   :title "change-email"
   :js nil
   :body (if (string= status "yes")
      (translate "email-changed")
      (translate "email-not-changed"))))
