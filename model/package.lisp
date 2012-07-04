(defpackage :hawksbill.golbin.model
  (:use :cl :hawksbill.utils :cl-prevalence :split-sequence :local-time)
  (:export :tmp-init
           ;;;;;;;;;;;;;;;;;;;;;;;;;;;
           ;; article
           ;;;;;;;;;;;;;;;;;;;;;;;;;;;
           :article
           :article-storage
           :add-article
           :edit-article
           :get-active-articles
           :get-all-articles-by-author
           :get-articles-by-author
           :get-articles-by-tag-slug
           :get-articles-by-cat
           :get-articles-by-cat-subcat
           :latest-articles
           :most-popular-articles
           ;;;;;;;;;;;;;;;;;;;;;;;;;;;
           ;; category
           ;;;;;;;;;;;;;;;;;;;;;;;;;;;
           :category
           :category-storage
           :add-category
           :add-cat/subcat
           :get-category-by-slug
           :get-active-categorys
           :get-active-subcategorys
           ;;;;;;;;;;;;;;;;;;;;;;;;;;;
           ;; tag
           ;;;;;;;;;;;;;;;;;;;;;;;;;;;
           :tag
           :tag-storage
           :add-tag
           :get-tag-by-slug
           :get-active-tags
           ;;;;;;;;;;;;;;;;;;;;;;;;;;;
           ;; user
           ;;;;;;;;;;;;;;;;;;;;;;;;;;;
           :author
           :mini-author
           :author-storage
           :add-author
           :get-author-by-handle
           :get-active-authors
           ;;;;;;;;;;;;;;;;;;;;;;;;;;;
           ;; init
           ;;;;;;;;;;;;;;;;;;;;;;;;;;;
           :model-first-run
           :model-init
           :model-tmp-init
           ;;;;;;;;;;;;;;;;;;;;;;;;;;;
           ;; created from utils.db using "init-storage" below
           ;;;;;;;;;;;;;;;;;;;;;;;;;;;
           :make-articles-root
           :get-all-articles
           :incf-article-last-id
           :insert-article
           :update-article
           :get-article-by-id

           :make-authors-root
           :get-all-authors
           :incf-author-last-id
           :insert-author
           :update-author
           :get-author-by-id

           :make-categorys-root
           :get-all-categorys
           :incf-category-last-id
           :insert-category
           :update-category
           :get-category-by-id

           :make-tags-root
           :get-all-tags
           :incf-tag-last-id
           :insert-tag
           :update-tag
           :get-tag-by-id))

(in-package :hawksbill.golbin.model)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setf *dimensions* '("envt"))
(defvar *valid-envts* '("dev" "prod"))
(setf *current-dimensions-string* "envt:dev") ; TODO: need to set this dynamically for every request (thread safe)
