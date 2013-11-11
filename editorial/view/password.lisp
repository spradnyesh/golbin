(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun validate-password-get (email username)
  (let ((err0r nil))
    (if (and (nil-or-empty username)
             (nil-or-empty email))
        (push (translate "username-email-required") err0r)
        (cond ((and (not (nil-or-empty username))
                    (not (get-author-by-username username)))
               (push (translate "cannot-find-username") err0r))
              ((and (not (nil-or-empty email))
                    (not (get-author-by-email email)))
               (push (translate "cannot-find-email") err0r))))
    err0r))

(defun validate-password-change-get (username timestamp)
  (let ((err0r nil))
    (unless (get-author-by-username username)
      (push (translate "cannot-find-username") err0r))
    (when (or (null timestamp)
              (< (get-config "timestamp.password-link-validity")
                 (- (timestamp-to-universal (now))
                    timestamp)))
      (push (translate "password-link-expired") err0r))
    err0r))

(defun validate-password-change-post (username timestamp password password2)
  (let ((err0r (validate-password-change-get username timestamp)))
    (unless (string= password password2)
      (push (translate "passwords-no-match") err0r))
    err0r))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; view functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-password-get ()
  (template
   :title "change-password"
   :js nil
   :body (<:div :class "wrapper"
                :id "password"
                (<:p (translate "username-or-email"))
                (<:form :action (h-genurl 'r-password-post)
                        :method "POST"
                        (<:fieldset :class "inputs"
                                    (<:table
                                     (<:tbody
                                      (tr-td-input "username")
                                      (tr-td-input "email")
                                      (tr-td-submit))))))))

(defun v-password-post (&key (ajax nil))
  (let* ((email (post-parameter "email"))
         (username (post-parameter "username"))
         (err0r (validate-password-get email username)))
    (if (not err0r)
        (let ((author (if username
                          (get-author-by-username username)
                          (get-author-by-email email)))
              (hash (insecure-encrypt (concatenate 'string
                                                   username
                                                   "|"
                                                   (write-to-string (timestamp-to-universal (now)))))))
          (sendmail :to (email author)
                    :subject (translate "change-password")
                    :body (click-here "password-email"
                                      (h-gen-full-url 'r-password-change-get
                                                      :hash hash
                                                      :lang (get-dimension-value "lang"))))
          (submit-success ajax
                          (h-genurl 'r-password-email)))
        ;; validation failed
        (submit-error ajax
                      err0r
                      (h-genurl 'r-register-get)))))

(defun v-password-email ()
  (template
   :title "change-password"
   :js nil
   :body (<:div :class "wrapper"
                :id "password"
                (<:p (translate "password-email-sent")))))

(defun v-password-change-get (hash)
  (let* ((ut (split-sequence "|" (insecure-decrypt hash) :test #'string=))
         (username (first ut))
         (timestamp (when (second ut)
                      (parse-integer (second ut)
                                     :junk-allowed t)))
         (err0r (validate-password-change-get username timestamp)))
    (if (not err0r)
        (template
         :title "change-password"
         :js nil
         :body (<:div :class "wrapper"
                      :id "password"
                      (<:form :action (h-genurl 'r-password-change-post)
                              :method "POST"
                              (<:fieldset :class "inputs"
                                          (<:table
                                           (<:tbody
                                            (tr-td-input "password" :typeof "password" :mandatory t)
                                            (<:tr (<:td (<:label :class "label" :for "password2"
                                                                 (translate "retype-password")
                                                                 (<:span :class "mandatory" "*")))
                                                  (<:td (<:input :class "input" :type "password"
                                                                 :name "password2")))
                                            (<:input :class "td-input"
                                                     :type "hidden"
                                                     :name "hash"
                                                     :value hash)
                                            (tr-td-submit)))))))
        (template
         :title "change-password"
         :js nil
         :body (<:div :class "wrapper"
                      :id "password"
                      (<:p (translate "reapply-password-change"))
                      (<:ul (join-loop l
                                       err0r
                                       (<:li l))))))))

(defun v-password-change-post (&key (ajax nil))
  (let* ((ut (split-sequence "|" (insecure-decrypt (post-parameter "hash")) :test #'string=))
         (username (first ut))
         (timestamp (when (second ut)
                      (parse-integer (second ut)
                                     :junk-allowed t)))
         (password (post-parameter "password"))
         (password2 (post-parameter "password2"))
         (err0r (validate-password-change-post username timestamp password password2)))
    (if (not err0r)
        (let ((author (get-author-by-username username)))
          (setf (password author) (sha256-hash password))
          (setf (salt author) (generate-salt 32))
          (edit-author author)
          (sendmail :to (email author)
                    :subject (translate "password-changed")
                    :body (translate "password-changed-email"))
          (submit-success ajax
                          (h-genurl 'r-password-changed
                                    :status "yes")))
        ;; validation failed
        (submit-error ajax
                      err0r
                      (h-genurl 'r-password-changed
                                :status "no")))))

(defun v-password-changed (status)
  (template
   :title "change-password"
   :js nil
   :body (<:div :class "wrapper"
                (if (string= status "yes")
                    (translate "password-changed")
                    (translate "password-not-changed")))))
