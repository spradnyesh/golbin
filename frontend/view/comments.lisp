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

(defun single-comment-markup (ht comment)
  (let* ((url (userurl comment))
         (datetime (universal-to-timestamp (date comment)))
         (name (username comment))
         (img (build-gravtar-image (md5-hash (useremail comment))
                                   name
                                   (write-to-string (get-config "photo.comments.size")))))
    (<:li :class "comment"
          (<:span :class "hidden" (id comment))
          (translate "user-comment-prelude"
                     (if (nil-or-empty url)
                         img
                         (<:a :href url img))
                     name
                     (prettyprint-date datetime)
                     (prettyprint-time datetime)
                     (translate "reply"))
          (<:p :class "c-body" (encode-entities (body comment)))
          (let ((children (gethash (id comment) ht)))
            (when children
              (<:ul (children-markup ht children)))))))

(defun children-markup (ht children)
  (join-loop child (reverse children) (single-comment-markup ht child)))

(defun article-comments-markup (article-id)
  (<:div :id "comments"
         (<:h3 (translate "comments"))
         (<:div (<:p (<:a :href "#" ; the 2nd p is needed to have a similar structure w/ existing comments markup so that js is easier
                        :class "c-reply"
                        (translate "write-a-comment"))))
         (<:div :id "c-input"
                :class "hidden"
                (<:div :class "yui3-u-1-2"
                       (<:form :method "POST"
                               :action (h-genurl 'r-comment-post
                                                 :article-id article-id)
                               (<:table
                                (tr-td-input "c-parent"
                                             :value 0
                                             :class "hidden"
                                             :id t)
                                (tr-td-input "name" :mandatory t)
                                (tr-td-input "email"
                                             :tooltip "mandatory-will-not-be-shown"
                                             :mandatory t)
                                (tr-td-input "url")
                                (tr-td-text "comment" :mandatory t)
                                (tr-td-input "challenge" :class "hidden" :id t :value "")
                                (tr-td-input "response" :class "hidden" :id t :value "")
                                (tr-td-submit))))
                (<:div :class "yui3-u-1-2"
                       (<:div :id "recaptcha")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; views
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-comment-get (article-id &optional ajax)
  (declare (ignore ajax))
  (multiple-value-bind (ignore ht)
      (group-list #'parent (get-comments article-id))
    (declare (ignore ignore))
    (encode-json-to-string `((:status . "success")
                             (:data . ,(<:ul :class "first"
                                             (children-markup ht (gethash 0 ht))))))))

(defun v-comment-post (article-id &optional ajax)
  (let* ((parent (post-parameter "c-parent"))
         (name (post-parameter "name"))
         (email (post-parameter "email"))
         (url (post-parameter "url"))
         (body (post-parameter "comment"))
         (challenge (post-parameter "challenge"))
         (response (post-parameter "response"))
         (userip (remote-addr*))
         (ajax-url (h-genurl 'r-article
                              :slug-and-id (url-encode (get-slug-and-id (get-article-by-id article-id)))))
         (err0r (validate-comment name email body challenge response userip)))
    (if (not err0r)
        (progn
          (handler-case (add-comment (make-instance 'comment
                                                    :parent (parse-integer parent)
                                                    :body (clean body)
                                                    :date (get-universal-time)
                                                    :status :a
                                                    :article-id article-id
                                                    :username name
                                                    :useremail email
                                                    :userurl url
                                                    :userip userip
                                                    :useragent (user-agent)))
            (simple-parse-error ()
              (push (translate "something-went-wrong") err0r)
              (submit-error ajax err0r ajax-url)))
          (submit-success ajax ajax-url))
        (submit-error ajax err0r ajax-url))))
