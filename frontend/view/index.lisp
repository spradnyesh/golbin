(in-package :hawksbill.golbin)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro view-index (title articles-list route &rest route-params)
  `(let* ((pagination-limit (get-config "pagination.article.limit"))
          (offset (* page pagination-limit)))
     (fe-page-template
         ,title
       (htm
        (:div :id "articles"
              (:ul
               (dolist (article (paginate ,articles-list
                                          offset
                                          pagination-limit))
                 (htm
                  (:li
                   (when (photo article)
                     (htm (:div :class "index-thumb"
                                (str (article-lead-photo-url (photo article) "index-thumb")))))
                   (:h3 (:a :class "a-title"
                            :href (genurl 'fe-r-article
                                          :slug-and-id (format nil "~A-~A"
                                                               (slug article)
                                                               (id article)))
                            (str (title article))))
                   (:cite :class "a-cite" (str (format nil
                                                       "~a, ~a - ~a"
                                                       (name (cat article))
                                                       (name (subcat article)) (date article))))
                   (:p :class "a-summary" (str (summary article))))))))
        (str ,(if route-params
                  `(pagination-markup ,route
                                      page
                                      (length ,articles-list)
                                      pagination-limit
                                      ,@route-params)
                  `(pagination-markup ,route
                                      page
                                      (length ,articles-list)
                                      pagination-limit)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun fe-v-home (&optional (page 0))
  (view-index "Home"
              (get-all-articles)
              'fe-r-home-page))

(defun fe-v-cat (cat-slug &optional (page 0))
  (let ((cat (get-category-by-slug cat-slug 0)))
    (view-index (name cat)
                (get-articles-by-cat cat)
                'fe-r-cat-page :cat (slug cat))))

(defun fe-v-cat-subcat (cat-slug subcat-slug &optional (page 0))
  (let* ((cat (get-category-by-slug cat-slug 0))
         (subcat (get-category-by-slug subcat-slug (id cat))))
    (view-index (format nil "~a, ~a" (name cat) (name subcat))
                (get-articles-by-cat-subcat cat subcat)
                'fe-r-cat-subcat-page :cat (slug cat) :subcat (slug subcat))))

(defun fe-v-author (author-handle &optional (page 0))
  (let ((author (get-author-by-handle author-handle)))
    (view-index (name author)
                (get-articles-by-author author)
                'fe-r-author-page :author (handle author))))

(defun fe-v-tag (slug &optional (page 0))
  (view-index (name (get-tag-by-slug slug))
              (get-articles-by-tag-slug slug)
              'fe-r-tag-page :tag slug))

(defun fe-v-search ())
