(restas:define-module :hawksbill.golbin.editorial
  (:use :cl :hawksbill.utils :hawksbill.golbin :hawksbill.golbin.model :cl-who :cl-ppcre :cl-prevalence :split-sequence :restas :parenscript :json :css-lite :hunchentoot :local-time :cl-gd)
  (:decorators #'hawksbill.utils:init-dimensions)
  (:import-from :hawksbill.golbin.frontend :v-article :fe-page-template :article-preamble-markup :article-body-markup :article-related-markup)
  (:shadow :% :prototype :size :acceptor :mime-type)
  (:shadowing-import-from :restas :redirect :start)
  (:shadowing-import-from :hawksbill.golbin.model :typeof :comment)
  (:export :r-home
           :r-photos
           :r-photo-id
           :r-photo-get
           :r-photo-post
           :r-tmp-photo-get
           :r-tmp-photo-post
           :r-articles
           :r-article
           :r-article-new-get
           :r-article-new-post
           :r-article-edit-get
           :r-article-edit-post
           :r-article-delete-post
           :r-login-get
           :r-login-post
           :r-ajax-photo-get
           :r-ajax-photo-post
           :r-ajax-photos-select
           :r-ajax-article-new-post
           :r-ajax-article-edit-post
           :r-logout
           :r-ajax-tags
           :r-robots
           :r-404))

(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; default routes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; copied from ~/quicklisp/dists/quicklisp/software/restas-20120703-git/example/publish-rst.lisp
(mount-submodule -static- (#:restas.directory-publisher)
  (restas.directory-publisher:*baseurl* '("static"))
  (restas.directory-publisher:*directory* (merge-pathnames "../data/static/" *home*))
  (restas.directory-publisher:*autoindex* t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; login
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro with-ed-login (&body body)
  `(with-login
       (h-genurl 'r-login-get)
     ,@body))
