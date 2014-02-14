(in-package :hawksbill.golbin.editorial)

;; login
(def-route r-login-get ("/login/") (v-login-get))
(def-route r-login-post ("/login/" :method :post) (v-login-post))

;; register
(def-route r-register-get ("/register/") (v-register-get))
(def-route r-register-post ("/register/" :method :post) (v-register-post))
(def-route r-why-register ("/register/why/") (v-why-register-get))
(def-route r-register-hurdle ("/register/hurdle/:email") (v-register-hurdle email))
(def-route r-register-do-confirm ("/register/do/:hash") (v-register-do-confirm hash))
(def-route r-register-done-confirm ("/register/done/:status")
  (:sift-variables (status #'(lambda (a)
                               (when (or (string= a "yes")
                                         (string= a "no"))
                                 a))))
  (v-register-done-confirm status))

;; forgot password
(def-route r-password-get ("/password/") (v-password-get))
(def-route r-password-post ("/password/" :method :post) (v-password-post))
(def-route r-password-email ("/password/email/") (v-password-email))
(def-route r-password-change-get ("/password/change/:hash ") (v-password-change-get hash))
(def-route r-password-change-post ("/password/change/" :method :post) (v-password-change-post))
(def-route r-password-changed ("/password/changed/:status")
  (:sift-variables (status #'(lambda (a)
                               (when (or (string= a "yes")
                                         (string= a "no"))
                                 a))))
  (v-password-changed status))

;; static pages
(def-route r-tnc ("/tos.html") (v-tnc))
(def-route r-faq ("/faq.html") (v-faq))
(def-route r-help ("/help.html") (v-help))
(def-route r-originality ("/originality.html") (v-originality))

;; robots
(def-route r-robots ("/robots.txt")
  (handle-static-file (merge-pathnames "../data/static/ed-robots.txt" *home*) "text/plain"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; only for logged-in users
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(def-route r-home ("/") (v-home))
(def-route r-logout ("/logout/") (v-logout))

;; article
(def-route r-article ("/:(slug-and-id).html") (v-article slug-and-id t))
(def-route r-article-new-get ("/article/") (v-article-get))
(def-route r-article-new-post ("/article/" :method :post) (v-article-post))
(def-route r-article-edit-get ("/article/:id/") (:sift-variables (id #'parse-integer)) (v-article-get id))
(def-route r-article-edit-post ("/article/:id/" :method :post)
  (:sift-variables (id #'parse-integer))
  (v-article-post :id id))
(def-route r-article-delete-post ("/article/:id/delete/" :method :post)
  (:sift-variables (id #'parse-integer))
  (v-article-delete-post id))

;; photo (non-ajax needed for tmp-init)
(def-route r-tmp-photo-get ("/tmp-photo/") (v-tmp-photo-get))
(def-route r-tmp-photo-post ("/tmp-photo/" :method :post) (v-tmp-photo-post))

;; account
(def-route r-account-get ("/account/") (v-account-get))
(def-route r-account-post ("/account/" :method :post) (v-account-post))
(def-route r-account-password-get ("/account/password/") (v-account-password-get))
(def-route r-account-password-post ("/account/password/" :method :post) (v-account-password-post))
(def-route r-account-password-done ("/account/password/:status")
  (:sift-variables (status #'(lambda (a)
                               (when (or (string= a "yes")
                                         (string= a "no"))
                                 a))))
  (v-account-password-done status))

(def-route r-account-email-get ("/account/email/") (v-account-email-get))
(def-route r-account-email-post ("/account/email/" :method :post) (v-account-email-post))
(def-route r-account-email-hurdle ("/account/email/hurdle/:email") (v-account-email-hurdle email))
(def-route r-account-email-verify ("/account/email/verify/:hash") (v-account-email-verify hash))
(def-route r-account-email-done ("/account/email/:status")
  (:sift-variables (status #'(lambda (a)
                               (when (or (string= a "yes")
                                         (string= a "no"))
                                 a))))
  (v-account-email-done status))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ajax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(def-route r-ajax-login-post ("/ajax/login/" :method :post
                                             :content-type "application/json")
  (v-login-post :ajax t))
(def-route r-ajax-article-new-post ("/ajax/article/" :method :post
                                                     :content-type "application/json")
  (v-article-post :ajax t))
(def-route r-ajax-article-edit-post ("/ajax/article/:id/" :method :post
                                                          :content-type "application/json")
  (:sift-variables (id #'parse-integer))
  (v-article-post :id id :ajax t))
(def-route r-ajax-article-delete-post ("/ajax/article/:id/delete/" :method :post
                                                                   :content-type "application/json")
  (:sift-variables (id #'parse-integer))
  (v-article-delete-post id :ajax t))
(def-route r-ajax-photos-select ("/ajax/photos/:who/:page/" :content-type "application/json")
  (:sift-variables (page #'parse-integer))
  (v-ajax-photos-select who page))
(def-route r-ajax-photo-get ("/ajax/photo/" :content-type "application/json")
  (v-ajax-photo-get))
(def-route r-ajax-photo-post ("/ajax/photo/" :method :post
                                             :content-type "application/json")
  (v-photo-post t))
(def-route r-ajax-author-photo ("/ajax/photo/author/" :method :post
                                                      :content-type "application/json")
  (v-photo-author t nil))
(def-route r-ajax-author-background ("/ajax/photo/author/background/"
                                     :method :post
                                     :content-type "application/json")
  (v-photo-author nil nil))
(def-route r-ajax-author-photo-reset ("/ajax/photo/author/reset/" :method :post
                                                                  :content-type "application/json")
  (v-photo-author nil t))
(def-route r-ajax-tags ("/ajax/tags/" :content-type "application/json")
  (v-ajax-tags))
(def-route r-ajax-register-post ("/ajax/register/" :method :post
                                                   :content-type "application/json")
  (v-register-post :ajax t))
(def-route r-ajax-account-post ("/ajax/account/" :method :post
                                                 :content-type "application/json")
  (v-account-post :ajax t))
(def-route r-ajax-account-password-post ("/ajax/account/password/" :method :post
                                                                   :content-type "application/json")
  (v-account-password-post :ajax t))
(def-route r-ajax-account-email-post ("/ajax/account/email/" :method :post
                                                             :content-type "application/json")
  (v-account-email-post :ajax t))
(def-route r-ajax-password-post ("/ajax/password/" :method :post
                                                   :content-type "application/json")
  (v-password-post :ajax t))
(def-route r-ajax-password-change-post ("/ajax/password/change/" :method :post
                                                                 :content-type "application/json")
  (v-password-change-post :ajax t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 404, define this as the last route
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(m-404 hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; start/stop/restart various servers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(start/stop/restart-system "ed")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; load cipher.secure if not already loaded
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmethod ed-start-real :after ((instance ed-acceptor))
  (declare (ignore instance))

  ;; populate secret configs
  (when (nil-or-empty (get-config "cipher.secure"))
    (populate-config-from-secret "cipher.secure"))
  (when (nil-or-empty (get-config "site.email.password"))
    (populate-config-from-secret "site.email.password"))

  ;; restart cron for future publishing
  (unless *cron-started*
    (make-cron-job #'article-future-publish)
    (setf *cron-started* t))
  (cron-restart))
