(restas:define-module :hawksbill.golbin.frontend
  (:use :cl :hawksbill.utils :hawksbill.golbin :hawksbill.golbin.model :cl-who :cl-ppcre :cl-prevalence :split-sequence :restas :parenscript :json :split-sequence :css-lite :hunchentoot)
  (:shadow :% :prototype :size :acceptor :mime-type)
  (:shadowing-import-from :restas :redirect :start)
  (:shadowing-import-from :hawksbill.golbin.model :typeof)
  (:export :r-home
           :r-home-page
           :r-cat
           :r-cat-page
           :r-cat-subcat
           :r-cat-subcat-page
           :r-author
           :r-author-page
           :r-tag
           :r-tag-page
           :r-article
           :r-search))

(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; default routes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; copied from ~/quicklisp/dists/quicklisp/software/restas-20120703-git/example/publish-rst.lisp
(mount-submodule -static- (#:restas.directory-publisher)
  (restas.directory-publisher:*baseurl* '("static"))
  (restas.directory-publisher:*directory* (merge-pathnames "../data/static/" *home*))
  (restas.directory-publisher:*autoindex* t))
