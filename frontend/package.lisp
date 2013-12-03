(restas:define-module :hawksbill.golbin.frontend
  (:use :cl :hawksbill.utils :hawksbill.golbin :hawksbill.golbin.model :sexml :cl-ppcre :cl-prevalence :split-sequence :restas :parenscript :json :css-lite :hunchentoot :trivial-utf-8 :flexi-streams :local-time :cl-recaptcha :html-entities :trivial-timeout :sanitize)
  (:decorators #'hawksbill.utils:init-dimensions)
  (:shadow :% :prototype :size :acceptor :mime-type :v-404)
  (:shadowing-import-from :restas :redirect :start)
  (:shadowing-import-from :hawksbill.golbin.model :typeof :comment)
  (:export :r-home
           :r-home-page
           :r-tos
           :r-privacy
           :r-cat
           :r-cat-page
           :r-cat-subcat
           :r-cat-subcat-page
           :r-author
           :r-author-page
           :r-tag
           :r-tag-page
           :r-article
           :r-article-comment
           :r-search
           :r-ajax-home-category-articles
           :r-ajax-article-related
           :r-ajax-article-comment
           :r-comment-post
           :r-ajax-comment-post
           :r-ajax-comment-get
           :r-rss-home
           :r-rss-cat
           :r-rss-cat-subcat
           :r-rss-author
           ;; enable article to be previewed in editorial
           :v-article
           :r-robots
           :r-404))

(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; default routes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; copied from ~/quicklisp/dists/quicklisp/software/restas-20120703-git/example/publish-rst.lisp
(mount-submodule -static- (#:restas.directory-publisher)
  (restas.directory-publisher:*baseurl* '("static"))
  (restas.directory-publisher:*directory* (merge-pathnames "../data/static/" *home*))
  (restas.directory-publisher:*autoindex* t))


(with-compiletime-active-layers
    (standard-sexml xml-doctype)
  (support-dtd
   (merge-pathnames "html5.dtd" (asdf:system-source-directory "sexml"))
   :<)
  (support-dtd
   (merge-pathnames "data/static/rss2.dtd" (asdf:system-source-directory "golbin"))
   :>))
(<:augment-with-doctype "html" "")
