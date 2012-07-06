(in-package :hawksbill.golbin)

(define-route fe-r-home ("/") (fe-v-home))
(define-route fe-r-home-page ("/:page" :parse-vars (list :page #'parse-integer)) (fe-v-home page))
(define-route fe-r-cat ("c/:cat/") (fe-v-cat cat))
(define-route fe-r-cat-page ("c/:cat/:page" :parse-vars (list :page #'parse-integer)) (fe-v-cat cat page))
(define-route fe-r-cat-subcat ("c/:cat/:subcat/") (fe-v-cat-subcat cat subcat))
(define-route fe-r-cat-subcat-page ("c/:cat/:subcat/:page" :parse-vars (list :page #'parse-integer)) (fe-v-cat-subcat cat subcat page))
(define-route fe-r-tag ("t/:tag/") (fe-v-tag tag))
(define-route fe-r-tag-page ("t/:tag/:page" :parse-vars (list :page #'parse-integer)) (fe-v-tag tag page))
(define-route fe-r-author ("a/:author/") (fe-v-author author))
(define-route fe-r-author-page ("a/:author/:page" :parse-vars (list :page #'parse-integer)) (fe-v-author author page))
(define-route fe-r-article (":(slug-and-id).html") (fe-v-article slug-and-id))
(define-route fe-r-search ("search/") (fe-v-search))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; start/stop/restart various servers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(start/stop/restart-system "fe")
