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
(define-route r-register-done-confirm ("/register/done/:status") (v-register-done-confirm status))

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
(define-route r-article-edit-post ("/article/:id/" :method :post :parse-vars (list :id #'parse-integer))
  (v-article-post :id id))
(define-route r-article-delete-post ("/article/:id/delete/" :method :post :parse-vars (list :id #'parse-integer))
  (v-article-delete-post id))
#|(define-route r-approve-articles ("/article/approve/") (v-articles-approve))|#
;; photo
(define-route r-photo-get ("/photo/") (v-photo-get))
(define-route r-photo-post ("/photo/" :method :post) (v-photo-post))
(define-route r-tmp-photo-get ("/tmp-photo/") (v-tmp-photo-get))
(define-route r-tmp-photo-post ("/tmp-photo/" :method :post) (v-tmp-photo-post))
;; cat/subcat
;(define-route r-cat-get ("/cat/") (v-cat-get))
;(define-route r-cat-post ("/cat/" :method :post) (v-cat-post))

;; robots
(define-route r-robots ("/robots.txt") (handle-static-file (merge-pathnames "../data/static/ed-robots.txt" *home*) "text/plain"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ajax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-route r-ajax-register-post ("/ajax/register/" :method :post
                                                        :content-type "text/json") (v-register-post :ajax t))
(define-route r-ajax-article-new-post ("/ajax/article/" :method :post
                                                        :content-type "text/json") (v-article-post :ajax t))
(define-route r-ajax-article-edit-post ("/ajax/article/:id/" :method :post
                                                             :parse-vars (list :id #'parse-integer)
                                                             :content-type "text/json")
  (v-article-post :id id :ajax t))
(define-route r-ajax-photos-select ("/ajax/photos/:who/:page/" :content-type "text/json"
                                                               :parse-vars (list :page #'parse-integer))
  (v-ajax-photos-select who page))
(define-route r-ajax-photo-get ("/ajax/photo/" :content-type "text/json")
  (v-ajax-photo-get))
(define-route r-ajax-photo-post ("/ajax/photo/" :method :post
                                                :content-type "text/json")
  (v-photo-post t))
(define-route r-ajax-tags ("/ajax/tags/" :content-type "text/json")
  (v-ajax-tags))

#|(
 (define-route r-articles ("/articles/") (v-articles))
 (define-route r-tag ("/tag/" :method :post) (v-tag-post)) ; only post
 (define-route r-photos ("/photos/") (v-photos))
 (define-route r-photo-id ("/photo/:id/") (v-photo-get id))
 ;; only for admin
 (define-route r-author ("/author/") (v-author-get))
 (define-route r-author ("/author/" :method :post) (v-author-post)))|#

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
