(in-package :hawksbill.golbin.frontend)

;; home
#|(define-route r-home ("/") (v-home))|#
#|(define-route r-home-page ("/:page" :parse-vars (list :page #'parse-integer)) (v-home page))|#
;; category
(define-route r-cat ("/category/:cat/") (v-cat cat))
(define-route r-cat-page ("/category/:cat/:page" :parse-vars (list :page #'parse-integer)) (v-cat cat page))
;; category/subcategory
(define-route r-cat-subcat ("/category/:cat/:subcat/") (v-cat-subcat cat subcat))
(define-route r-cat-subcat-page ("/category/:cat/:subcat/:page" :parse-vars (list :page #'parse-integer)) (v-cat-subcat cat subcat page))
;; tag
(define-route r-tag ("/tag/:tag/") (v-tag tag))
(define-route r-tag-page ("/tag/:tag/:page" :parse-vars (list :page #'parse-integer)) (v-tag tag page))
;; author
(define-route r-author ("/author/:author/") (v-author author))
(define-route r-author-page ("/author/:author/:page" :parse-vars (list :page #'parse-integer)) (v-author author page))
;; article
(define-route r-article ("/:(slug-and-id).html") (v-article slug-and-id))
;; search
(define-route r-search ("/search/") (v-search))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ajax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; article related
(define-route r-ajax-article-related ("/ajax/article-related/:id/:typeof/:page/"
                                      :parse-vars (list :id #'parse-integer
                                                        :page #'parse-integer)
                                      :content-type "text/json")
  (v-ajax-article-related id typeof page))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; start/stop/restart various servers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(start/stop/restart-system "fe")
