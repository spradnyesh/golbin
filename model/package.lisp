
(defpackage :hawksbill.golbin.model
  (:use :cl :cl-memcached :cl-prevalence :hawksbill.utils :local-time :json :split-sequence :cl-ppcre :trivial-utf-8 :flexi-streams)
  (:import-from :hunchentoot :session-value :url-encode)
  (:export :db-reconnect
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; slots
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
           :id
           :article
           :title
           :slug
           :summary
           :date
           :body
           :status
           :photo
           :photo-direction
           :cat
           :subcat
           :tags
           :location
           :author
           :article-storage
           :articles
           :last-id
           :category
           :name
           :parent
           :rank
           :category-storage
           :categorys
           :typeof
           :orig-filename
           :new-filename
           :mini-photo
           :filename
           :photo-storage
           :photos
           :tag
           :tag-storage
           :user
           :username
           :handle
           :alias
           :password
           :salt
           :gender
           :age
           :email
           :address-1
           :address-2
           :address-3
           :city
           :state
           :country
           :zipcode
           :contact-1
           :contact-2
           :contact-3
           :bank-name
           :bank-account-no
           :bank-ifsc
           :author-type
           :education
           :visitor
           :preference
           :mini-author
           :author-storage
           :authors
           :token
           :comment
           :comment-storage
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
           ;; methods
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
           ;; common (generated by init-db-system)
           :get-all-articles
           :get-article-by-id
           :get-all-authors
           :get-author-by-id
           :get-all-categorys
           :get-category-by-id
           :get-all-photos
           :get-photo-by-id
           :get-all-tags
           :get-tag-by-id
           ;; article
           :add-article
           :add-article-comment
           :edit-article
           :get-active-articles
           :get-articles-by-author
           :get-articles-by-tag-slug
           :get-articles-by-cat
           :get-articles-by-cat-subcat
           :get-related-articles
           :get-all-articles-by-author
           ;; category
           :add-category
           :get-category-by-slug
           :get-subcategorys
           :get-root-categorys
           :get-category-tree
           :get-category-tree-json
           :get-home-page-categories
           ;; photo
           :scale-photo
           :add-photo
           :get-photos-by-author
           :get-photos-by-tag-slug
           :get-mini-photo
           :article-lead-photo-url
           :attribution
           :find-photo-by-img-tag
           ;; tag
           :add-tag
           :get-tag-by-slug
           :get-tags-for-autocomplete
           ;; user
           :add-author
           :get-mini-author-details-from-id
           :get-author-by-handle
           :get-author-by-username
           :get-author-by-email
           :get-random-author
           :get-current-author-id
           :verify-login
           :find-author-by-email-salt
           ;; comment
           :comment
           :userurl
           :userip
           :useragent
           :article-id
           :add-comment
           ;; init
           :model-init))
