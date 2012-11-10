(in-package :hawksbill.golbin.editorial)

;; login
(define-route r-login-get ("/login/") (v-login-get))
(define-route r-login-post ("/login/" :method :post) (v-login-post))

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
  (v-article-post id))
(define-route r-article-delete-post ("/article/:id/delete/" :method :post :parse-vars (list :id #'parse-integer))
  (v-article-delete-post id))
#|(define-route r-approve-articles ("/article/approve/") (v-articles-approve))|#
;; photo
(define-route r-photo-get ("/photo/") (v-photo-get))
(define-route r-photo-post ("/photo/" :method :post) (v-photo-post))
(define-route r-tmp-photo-get ("/tmp-photo/") (v-tmp-photo-get))
(define-route r-tmp-photo-post ("/tmp-photo/" :method :post) (v-tmp-photo-post))
;; cat/subcat
(define-route r-cat-get ("/cat/") (v-cat-get))
(define-route r-cat-post ("/cat/" :method :post) (v-cat-post))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ajax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-route r-ajax-photos-select ("/ajax/photos/:who/:page/" :content-type "text/json")
  (v-ajax-photos-select who page))
(define-route r-ajax-photo-get ("/ajax/photo/" :content-type "text/json")
  (v-ajax-photo-get))
(define-route r-ajax-photo-post ("/ajax/photo/" :method :post :content-type "text/json")
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; start/stop/restart various servers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(start/stop/restart-system "ed")
