(defpackage :hawksbill.golbin.model
  (:use :cl :cl-memcached :cl-prevalence :hawksbill.utils :local-time)
  (:export :db-reconnect
           ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
           ;; slots
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
           ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
           ;; methods
           ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
           ;; common (generated by init-db-system)
           :get-all-article
           :get-article-by-id
           :get-all-author
           :get-author-by-id
           :get-all-category
           :get-category-by-id
           :get-all-photo
           :get-photo-by-id
           :get-all-tag
           :get-tag-by-id
           ;; article
           :add-article
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
           ;; photo
           :scale-photo
           :add-photo
           :get-photos-by-author
           :get-photos-by-tag-slug
           :get-mini-photo
           ;; tag
           :add-tag
           :get-tag-by-slug
           ;; user
           :add-author
           :get-mini-author-details-from-id
           :get-author-by-handle
           :get-random-author
           :get-current-author-id
           ;; init
           :model-init))