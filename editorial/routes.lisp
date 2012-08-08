(in-package :hawksbill.golbin.editorial)

;; login
(define-route r-login-get ("/login/" :method :get) (v-login-get))
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
(define-route r-photos-get ("/ajax/photos/:who/:page/"
                            :method :get
                            :content-type "text/json")
  (v-photos-get who page))

#|(
 ;; only for logged-in users
 (define-route r-home ("/") (v-home))
 (define-route r-articles ("/articles/") (v-articles))
 (define-route r-article-id ("/article/:id/" :method :get) (v-article-get id))
 (define-route r-tag ("/tag/" :method :post) (v-tag-post)) ; only post
 (define-route r-login-post ("/login/" :method :post) (v-login-post))
 (define-route r-photos ("/photos/") (v-photos))
 (define-route r-photo-id ("/photo/:id/" :method :get) (v-photo-get id))
 ;; only for admin
 (define-route r-author ("/author/" :method :get) (v-author-get))
 (define-route r-author ("/author/" :method :post) (v-author-post)))|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; start/stop/restart various servers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(start/stop/restart-system "ed")
