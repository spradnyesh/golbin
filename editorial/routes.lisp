(in-package :hawksbill.golbin)

(define-route ed-r-login-get ("/login/" :method :get) (ed-v-login-get))
(define-route ed-r-login-post ("/login/" :method :post) (ed-v-login-post))
#|(
 ;; only for logged-in users
 (define-route ed-r-home ("/") (ed-v-home))
 (define-route ed-r-articles ("/articles/") (ed-v-articles))
 (define-route ed-r-article-id ("/article/:id/" :method :get) (ed-v-article-get id))
 (define-route ed-r-article-get ("/article/" :method :get) (ed-v-article-get))
 (define-route ed-r-article-post ("/article/" :method :post) (ed-v-article-post))
 (define-route ed-r-photos ("/photos/") (ed-v-photos))
 (define-route ed-r-photo-id ("/photo/:id/" :method :get) (ed-v-photo-get id))
 (define-route ed-r-photo-get ("/photo/" :method :get) (ed-v-photo-get))
 (define-route ed-r-photo-post ("/photo/" :method :post) (ed-v-photo-post))
 (define-route ed-r-tag ("/tag/" :method :post) (ed-v-tag-post)) ; only post
 ;; only for admin
 (define-route ed-r-author ("/author/" :method :get) (ed-v-author-get))
 (define-route ed-r-author ("/author/" :method :post) (ed-v-author-post)))|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; start/stop/restart various servers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(start/stop/restart-system "ed")
