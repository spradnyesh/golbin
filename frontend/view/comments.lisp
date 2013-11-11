(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cl-recaptcha vars
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setf cl-recaptcha::*captcha-verify-url* "http://www.google.com/recaptcha/api/verify")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun validate-comment (name email body challenge response userip)
  (let ((err0r nil))
    (cannot-be-empty name "name" err0r)
    (cannot-be-empty email "email" err0r
      (unless (validate-email email)
        (push (translate "invalid-email") err0r)))
    (cannot-be-empty body "body" err0r)
    (cannot-be-empty response "captcha" err0r
      (handler-case
          (with-timeout ((get-config "site.timeout.comments"))
            (multiple-value-bind (status error-code)
                (verify-captcha challenge response userip :private-key (get-config "cipher.fe.comments.private"))
              (unless status
                (push (translate "captcha-verification-failed" error-code) err0r))))
        (trivial-timeout:timeout-error ()
          (push (translate "recaptcha-connection-failed") err0r))
        (usocket:timeout-error ()
          (push (translate "recaptcha-connection-failed") err0r))))
    err0r))

(defun get-comment-markup (comment)
  (let* ((email (useremail comment))
         (url (userurl comment))
         (name (username comment))
         (datetime (universal-to-timestamp (date comment)))
         (img (build-gravtar-image email name (get-config "photo.comments.size"))))
    (<:li :class "comment"
          (<:span :class "hidden" (id comment))
          (translate "user-comment-prelude"
                     (if (nil-or-empty url)
                         img
                         (<:a :href url img))
                     (prettyprint-date datetime)
                     (prettyprint-time datetime))
          (<:p :class "c-body" (encode-entities (body comment))))))

(defun article-comments-markup (article-id start)
  (<:div :id "comments"
         (<:h3 "Comments")
         (<:div (<:div :class "yui3-u-1-2"
                       (<:form :method "POST"
                               :action (h-genurl 'r-article-comment :id article-id)
                               (<:table
                                (tr-td-input "name" :mandatory t)
                                (tr-td-input "email"
                                             :tooltip "mandatory, but will not be shown"
                                             :mandatory t)
                                (tr-td-input "url")
                                (tr-td-text "comment" :mandatory t)
                                (tr-td-input "challenge" :class "hidden" :id t :value "")
                                (tr-td-input "response" :class "hidden" :id t :value "")
                                (tr-td-submit))))
                (<:div :class "yui3-u-1-2"
                       (<:div :id "recaptcha")))
         (<:ul (join-loop comment
                          (paginate (get-article-comments article-id)
                                    start
                                    (get-config "pagination.comments"))
                          (get-comment-markup comment)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; views
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-comment (article-id &optional ajax)
  (let ((name (post-parameter "name"))
        (email (post-parameter "email"))
        (url (post-parameter "url"))
        (body (post-parameter "comment"))
        (challenge (post-parameter "challenge"))
        (response (post-parameter "response"))
        (userip (remote-addr*)))
    (let ((err0r (validate-comment name email body challenge response userip)))
      (if (not err0r)
          (progn
            (add-comment (make-instance 'comment
                                        :body (clean body)
                                        :date (get-universal-time)
                                        :status :a
                                        :article-id article-id
                                        :username name
                                        :useremail email
                                        :userurl url
                                        :userip userip
                                        :useragent (user-agent)))
            (submit-success ajax
                            (h-genurl 'r-article
                                      :slug-and-id (url-encode (get-slug-and-id (get-article-by-id article-id))))))
          (submit-error ajax
                        err0r
                        (h-genurl 'r-article
                                  :slug-and-id (url-encode (get-slug-and-id (get-article-by-id article-id)))))))))
