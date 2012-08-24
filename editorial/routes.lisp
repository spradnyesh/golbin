(in-package :hawksbill.golbin.editorial)

;; login
(define-route r-login-get ("/login/" :method :get) (v-login-get))
(define-route r-login-post ("/login/" :method :post) (v-login-post))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; only for logged-in users
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-route r-home ("/") (v-home))
(define-route r-logout ("/logout/") (v-logout))
;; article
(define-route r-article-get ("/article/" :method :get) (v-article-get))
(define-route r-article-post ("/article/" :method :post) (v-article-post))
;; photo
(define-route r-photo-get ("/photo/" :method :get) (v-photo-get))
(define-route r-photo-post ("/photo/" :method :post) (v-photo-post))
(define-route r-tmp-photo-get ("/tmp-photo/" :method :get) (v-tmp-photo-get))
(define-route r-tmp-photo-post ("/tmp-photo/" :method :post) (v-tmp-photo-post))

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
 (define-route r-article-id ("/article/:id/" :method :get) (v-article-get id))
 (define-route r-tag ("/tag/" :method :post) (v-tag-post)) ; only post
 (define-route r-photos ("/photos/") (v-photos))
 (define-route r-photo-id ("/photo/:id/" :method :get) (v-photo-get id))
 ;; only for admin
 (define-route r-author ("/author/" :method :get) (v-author-get))
 (define-route r-author ("/author/" :method :post) (v-author-post)))|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; start/stop/restart various servers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(start/stop/restart-system "ed")
