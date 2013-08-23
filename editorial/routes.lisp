(in-package :hawksbill.golbin.editorial)

;; login
(define-route r-login-get ("/login/") (v-login-get))
(define-route r-login-post ("/login/" :method :post) (v-login-post))

;; register
(define-route r-register-get ("/register/") (v-register-get))
(define-route r-register-post ("/register/" :method :post) (v-register-post))
(define-route r-why-register ("/register/why/") (v-why-register-get))
(define-route r-register-hurdle ("/register/hurdle/:email") (v-register-hurdle email))
(define-route r-register-do-confirm ("/register/do/:hash") (v-register-do-confirm hash))
(define-route r-register-done-confirm ("/register/done/:status"
                                       :parse-vars (list :status #'(lambda (a)
                                                                     (when (or (string= a "yes")
                                                                               (string= a "no"))
                                                                       a))))
  (v-register-done-confirm status))

;; forgot password
(define-route r-password-get ("/password/") (v-password-get))
(define-route r-password-post ("/password/" :method :post) (v-password-post))
(define-route r-password-email ("/password/email/") (v-password-email))
(define-route r-password-change-get ("/password/change/:hash ") (v-password-change-get hash))
(define-route r-password-change-post ("/password/change/" :method :post) (v-password-change-post))
(define-route r-password-changed ("/password/changed/:status"
                                  :parse-vars (list :status #'(lambda (a)
                                                                (when (or (string= a "yes")
                                                                          (string= a "no"))
                                                                  a))))
  (v-password-changed status))

;; robots
(define-route r-robots ("/robots.txt")
  (handle-static-file (merge-pathnames "../data/static/ed-robots.txt" *home*) "text/plain"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; only for logged-in users
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-route r-home ("/") (v-home))
(define-route r-logout ("/logout/") (v-logout))

;; article
(define-route r-article ("/:(slug-and-id).html") (v-article slug-and-id t))
(define-route r-article-new-get ("/article/") (v-article-get))
(define-route r-article-new-post ("/article/" :method :post) (v-article-post))
(define-route r-article-edit-get ("/article/:id/" :parse-vars (list :id #'parse-integer)) (v-article-get id))
(define-route r-article-edit-post ("/article/:id/" :method :post
                                                   :parse-vars (list :id #'parse-integer))
  (v-article-post :id id))
(define-route r-article-delete-post ("/article/:id/delete/" :method :post
                                                            :parse-vars (list :id #'parse-integer))
  (v-article-delete-post id))
;(define-route r-approve-articles ("/article/approve/") (v-articles-approve))

;; photo (non-ajax needed for tmp-init)
(define-route r-tmp-photo-get ("/tmp-photo/") (v-tmp-photo-get))
(define-route r-tmp-photo-post ("/tmp-photo/" :method :post) (v-tmp-photo-post))

;; account
(define-route r-account-password-get ("/account/password/") (v-account-password-get))
(define-route r-account-password-post ("/account/password/" :method :post) (v-account-password-post))
(define-route r-account-password-done ("/account/password/:status"
                                       :parse-vars (list :status #'(lambda (a)
                                                                     (when (or (string= a "yes")
                                                                               (string= a "no"))
                                                                       a))))
  (v-account-password-done status))
(define-route r-account-email-get ("/account/email/") (v-account-email-get))
(define-route r-account-email-post ("/account/email/" :method :post) (v-account-email-post))
(define-route r-account-email-done ("/account/email/:status"
                                    :parse-vars (list :status #'(lambda (a)
                                                                     (when (or (string= a "yes")
                                                                               (string= a "no"))
                                                                       a))))
  (v-account-email-done status))
(define-route r-account-token-get ("/account/token/") (v-account-token-get))
(define-route r-account-token-post ("/account/token/" :method :post) (v-account-token-post))
(define-route r-account-token-done ("/account/token/:status"
                                    :parse-vars (list :status #'(lambda (a)
                                                                  (when (or (string= a "yes")
                                                                            (string= a "no"))
                                                                    a))))
  (v-account-token-done status))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ajax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-route r-ajax-article-new-post ("/ajax/article/" :method :post
                                                        :content-type "application/json")
  (v-article-post :ajax t))
(define-route r-ajax-article-edit-post ("/ajax/article/:id/" :method :post
                                                             :parse-vars (list :id #'parse-integer)
                                                             :content-type "application/json")
  (v-article-post :id id :ajax t))
(define-route r-ajax-photos-select ("/ajax/photos/:who/:page/" :content-type "application/json"
                                                               :parse-vars (list :page #'parse-integer))
  (v-ajax-photos-select who page))
(define-route r-ajax-photo-get ("/ajax/photo/" :content-type "application/json")
  (v-ajax-photo-get))
(define-route r-ajax-photo-post ("/ajax/photo/" :method :post
                                                :content-type "application/json")
  (v-photo-post t))
(define-route r-ajax-tags ("/ajax/tags/" :content-type "application/json")
  (v-ajax-tags))
(define-route r-ajax-register-post ("/ajax/register/" :method :post
                                                      :content-type "application/json")
  (v-register-post :ajax t))
(define-route r-ajax-account-password-post ("/ajax/account/password/" :method :post
                                                                      :content-type "application/json")
  (v-account-password-post :ajax t))
(define-route r-ajax-account-email-post ("/ajax/account/email/" :method :post
                                                                :content-type "application/json")
  (v-account-email-post :ajax t))
(define-route r-ajax-account-token-post ("/ajax/account/token/" :method :post
                                                                :content-type "application/json")
  (v-account-token-post :ajax t))
(define-route r-ajax-password-post ("/ajax/password/" :method :post
                                                      :content-type "application/json")
  (v-password-post :ajax t))
(define-route r-ajax-password-change-post ("/ajax/password/change/" :method :post
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
  (when (nil-or-empty (get-config "cipher.secure"))
    (format t "please enter secure cipher-key: ")
    (add-config "cipher.secure" (read-line) "master")))
