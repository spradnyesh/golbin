(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cl-recaptcha vars
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setf cl-recaptcha::*captcha-verify-url* "http://www.google.com/recaptcha/api/verify")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun validate-comment (name email url challenge response userip)
  (and (not (nil-or-empty name))
       (or (not (nil-or-empty email))
           (not (nil-or-empty url)))
       (verify-captcha challenge response userip :private-key (get-config "cipher.fe.comments.private"))))

(defun get-comment-markup (comment)
  (let ((url (userurl comment))
        (email (useremail comment))
        (datetime (universal-to-timestamp (date comment))))
    (<:li :class "comment"
          (translate "user-comment-prelude"
                     (if (nil-or-empty url)
                         (if (nil-or-empty email)
                             (username comment)
                             (<:a :href (concatenate 'string "mailto:" email)
                                  (username comment)))
                         (<:a :href url
                              (username comment)))
                     (prettyprint-date datetime)
                     (prettyprint-time datetime))
          (<:p :class "c-body" (body comment)))))

(defun article-comments-markup (article-id start)
  (<:div :id "comments"
         (<:h3 "Comments")
         (<:div (<:div :class "yui3-u-1-2"
                       (<:form :method "POST"
                               :action (h-genurl 'r-article-comment :id article-id)
                               (<:table
                                (tr-td-input "name")
                                (tr-td-input "email")
                                (tr-td-input "url")
                                (tr-td-text "comment" :cols 18)
                                (tr-td-input "challenge" :class "hidden" :id t :value "abc")
                                (tr-td-input "response" :class "hidden" :id t :value "def")
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
(defun v-comment (article-id)
  (let ((name (post-parameter "name"))
        (email (post-parameter "email"))
        (url (post-parameter "url"))
        (body (post-parameter "comment"))
        (challenge (post-parameter "challenge"))
        (response (post-parameter "response"))
        (userip (remote-addr*)))
    (when (validate-comment name email url challenge response userip)
      (add-comment (make-instance 'comment
                                  :body body
                                  :date (get-universal-time)
                                  :status :a
                                  :article-id article-id
                                  :username name
                                  :useremail email
                                  :userurl url
                                  :userip userip
                                  :useragent (user-agent))))
    (redirect (h-genurl 'r-article
                        :slug-and-id (url-encode (get-slug-and-id (get-article-by-id article-id)))))))
