(restas:define-module :hawksbill.golbin.frontend
  (:use :cl :hawksbill.utils :hawksbill.golbin :hawksbill.golbin.model :cl-who :cl-ppcre :cl-prevalence :split-sequence :restas :parenscript :json :css-lite :hunchentoot :trivial-utf-8 :flexi-streams)
  (:decorators #'hawksbill.utils:init-dimensions)
  (:shadow :% :prototype :size :acceptor :mime-type)
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
           ;; enable article to be previewed in editorial
           :v-article
           :fe-page-template
           :article-preamble-markup
           :article-body-markup
           :article-related-markup))

(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; default routes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; copied from ~/quicklisp/dists/quicklisp/software/restas-20120703-git/example/publish-rst.lisp
(mount-submodule -static- (#:restas.directory-publisher)
  (restas.directory-publisher:*baseurl* '("static"))
  (restas.directory-publisher:*directory* (merge-pathnames "../data/static/" *home*))
  (restas.directory-publisher:*autoindex* t))
