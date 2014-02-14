(in-package :hawksbill.golbin.frontend)

;; home
(def-route r-home ("/") (v-home))
(def-route r-home-page ("/:page") (:sift-variables (page 'integer)) (v-home page))
;; category
(def-route r-cat ("/category/:cat/") (v-cat cat))
(def-route r-cat-page ("/category/:cat/:page") (:sift-variables (page 'integer)) (v-cat cat page))
;; category/subcategory
(def-route r-cat-subcat ("/category/:cat/:subcat/") (v-cat-subcat cat subcat))
(def-route r-cat-subcat-page ("/category/:cat/:subcat/:page") (:sift-variables (page 'integer))
           (v-cat-subcat cat subcat page))
;; tag
(def-route r-tag ("/tag/:tag/") (v-tag tag))
(def-route r-tag-page ("/tag/:tag/:page") (:sift-variables (page 'integer)) (v-tag tag page))
;; author
(def-route r-author ("/author/:author/") (v-author author))
(def-route r-author-page ("/author/:author/:page") (:sift-variables (page 'integer)) (v-author author page))
;; article
(def-route r-article ("/:(slug-and-id).html") (v-article slug-and-id))
(def-route r-comment-post ("/comment/:article-id/" :method :post)
  (:sift-variables (article-id 'integer))
  (v-comment-post article-id))
;; static pages
(def-route r-tos ("/tos.html") (v-tos))
(def-route r-privacy ("/privacy.html") (v-privacy))

;; RSS
(def-route r-rss-home ("/feed.xml") :content-type "application/rss+xml"
           (v-rss-home))
(def-route r-rss-cat ("/category/:cat/feed.xml") :content-type "application/rss+xml"
           (v-rss-cat cat))
(def-route r-rss-cat-subcat ("/category/:cat/:subcat/feed.xml") :content-type "application/rss+xml"
           (v-rss-cat-subcat cat subcat))
(def-route r-rss-author ("/author/:author/feed.xml") :content-type "application/rss+xml"
           (v-rss-author author))

;; robots
(def-route r-robots ("/robots.txt")
  (handle-static-file (merge-pathnames "../data/static/fe-robots.txt" *home*) "text/plain"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ajax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(def-route r-ajax-article-related ("/ajax/article-related/:id/:typeof/:page"
                                   :content-type "application/json")
  (:sift-variables (id 'integer)
                   (page 'integer)
                   (typeof #'(lambda (a)
                               (when (or (string= a "author")
                                         (string= a "cat-subcat"))
                                 a))))
  (v-ajax-article-related id typeof page))
(def-route r-ajax-home-category-articles ("/ajax/home/:cat-slug/:page"
                                          :content-type "application/json")
  (:sift-variables (page 'integer))
  (v-ajax-home-category-articles cat-slug page))
(def-route r-ajax-comment-get ("/comment/:article-id/" :content-type "application/json")
  (:sift-variables (article-id 'integer))
  (v-comment-get article-id t))
(def-route r-ajax-comment-post ("/ajax/comment/:article-id/" :method :post
                                                             :content-type "application/json")
  (:sift-variables (article-id 'integer))
  (v-comment-post article-id t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 404, define this as the last route
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(m-404 hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; start/stop/restart various servers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(start/stop/restart-system "fe")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; load cipher.fe.comments.private if not already loaded
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmethod fe-start-real :after ((instance fe-acceptor))
  (declare (ignore instance))
  (when (nil-or-empty (get-config "cipher.fe.comments.private"))
    (populate-config-from-secret "cipher.fe.comments.private"))
  (when (nil-or-empty (get-config "site.email.password"))
    (populate-config-from-secret "site.email.password")))
