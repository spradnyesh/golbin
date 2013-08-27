(restas:define-module :hawksbill.golbin.editorial
  (:use :cl :hawksbill.utils :hawksbill.golbin :hawksbill.golbin.model :sexml :cl-ppcre :cl-prevalence :split-sequence :restas :parenscript :json :css-lite :hunchentoot :local-time :cl-gd :routes)
  (:decorators #'hawksbill.utils:init-dimensions)
  (:import-from :hawksbill.golbin.frontend :v-article)
  (:shadow :% :prototype :size :acceptor :mime-type)
  (:shadowing-import-from :restas :redirect :start :route)
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
           :r-ajax-login-post
           :r-ajax-photo-get
           :r-ajax-photo-post
           :r-ajax-photos-select
           :r-ajax-article-new-post
           :r-ajax-article-edit-post
           :r-logout
           :r-ajax-tags
           :r-robots
           :r-404
           :r-register-get
           :r-register-post
           :r-why-register
           :r-register-hurdle
           :r-register-do-confirm
           :r-register-done-confirm
           :r-ajax-register-post
           :r-account-password-get
           :r-account-password-post
           :r-account-password-done
           :r-account-email-get
           :r-account-email-post
           :r-account-email-hurdle
           :r-account-email-verify
           :r-account-email-done
           :r-account-token-get
           :r-account-token-post
           :r-account-token-done
           :r-ajax-account-password-post
           :r-ajax-account-email-post
           :r-ajax-account-token-post
           :r-password-get
           :r-password-post
           :r-password-email
           :r-password-change-get
           :r-password-change-post
           :r-password-changed
           :r-ajax-password-post
           :r-ajax-password-change-post))

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

(with-compiletime-active-layers
    (standard-sexml xml-doctype)
  (support-dtd
   (merge-pathnames "html5.dtd" (asdf:system-source-directory "sexml"))
   :<))
(<:augment-with-doctype "html" "")

(defparameter *whitelist* '(r-login-get
                            r-password-get
                            r-password-email
                            r-password-change-get
                            r-password-changed
                            r-register-get
                            r-why-register
                            r-register-hurdle
                            r-register-do-confirm
                            r-register-done-confirm)
  "list of routes that can be accessed in a non-logged-in state")
