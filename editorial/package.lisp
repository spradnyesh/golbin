(restas:define-module :hawksbill.golbin.editorial
  (:use :cl :hawksbill.utils :cl-who :cl-ppcre :cl-prevalence :local-time :split-sequence :restas :parenscript :json :split-sequence :css-lite :hunchentoot)
  (:shadow :% :prototype :size :acceptor :mime-type)
  (:shadowing-import-from :restas :redirect :start)
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
