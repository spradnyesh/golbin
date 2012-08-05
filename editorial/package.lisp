(restas:define-module :hawksbill.golbin.editorial
  (:use :cl :hawksbill.utils :hawksbill.golbin :hawksbill.golbin.model :cl-who :cl-ppcre :cl-prevalence :split-sequence :restas :parenscript :json :split-sequence :css-lite :hunchentoot)
  (:shadow :% :prototype :size :acceptor :mime-type)
  (:shadowing-import-from :restas :redirect :start)
  (:shadowing-import-from :hawksbill.golbin.model :typeof)
  (:export :r-home
           :r-photos
           :r-photo-id
           :r-photo-get
           :r-photo-post
           :r-tmp-photo-get
           :r-tmp-photo-post
           :r-articles
           :r-article-id
           :r-article-get
           :r-article-post
           :r-tag
           :r-login-get
           :r-login-post))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; default routes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; copied from ~/quicklisp/dists/quicklisp/software/restas-20120703-git/example/publish-rst.lisp
(restas:mount-submodule -static- (#:restas.directory-publisher)
  (restas.directory-publisher:*baseurl* '("static"))
  (restas.directory-publisher:*directory* (merge-pathnames "../data/static/" *home*))
  (restas.directory-publisher:*autoindex* t))
