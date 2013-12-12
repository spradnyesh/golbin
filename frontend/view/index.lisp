(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro view-index (title prelude postlude rss-url articles-list route &rest route-params)
  `(if ,articles-list
       (let* ((num-per-page (get-config "pagination.article.limit"))
              (num-pages (get-config "pagination.article.range"))
              (offset (* page num-per-page)))
         (template
          :title ,title
          :js nil
          :tags (list ,title)
          :description nil
          :body (fmtnil
                 ,prelude
                 (<:div :id "articles"
                        (<:ul
                         (join-loop article
                                    (paginate ,articles-list
                                              offset
                                              num-per-page)
                                    (<:li
                                     (when (photo article)
                                       (<:div :class "index-thumb"
                                              (article-lead-photo-url (photo article) "index-thumb")))
                                     (<:h3 (<:a :class "a-title"
                                                :href (h-genurl 'r-article
                                                                :slug-and-id (get-slug-and-id article))
                                                (title article)))
                                     (let ((timestamp (universal-to-timestamp (date article))))
                                       (<:span :class "a-cite small"
                                               (article-preamble-markup-common nil "article-cite")))
                                     (<:p :class "a-summary" (summary article))))))
                 ,(if route-params
                      `(pagination-markup page
                                          (length ,articles-list)
                                          num-per-page
                                          num-pages
                                          ,route
                                          ,@route-params)
                      `(pagination-markup page
                                          (length ,articles-list)
                                          num-per-page
                                          num-pages
                                          ,route))
                 (<:a :class "rss" :href ,rss-url (translate "rss"))
                 ,postlude)))
       (v-404)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; view functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-cat (cat-slug &optional (page 0))
  (let ((cat (get-category-by-slug (string-to-utf-8 cat-slug :latin1)
                                   0)))
    (view-index (name cat)
                nil
                nil
                (h-gen-full-url 'r-rss-cat :cat (slug cat))
                (get-articles-by-cat cat)
                'r-cat-page :cat (slug cat))))

(defun v-cat-subcat (cat-slug subcat-slug &optional (page 0))
  (let* ((cat (get-category-by-slug (string-to-utf-8 cat-slug :latin1)
                                    0))
         (subcat (when cat
                   (get-category-by-slug (string-to-utf-8 subcat-slug :latin1)
                                         (id cat)))))
    (view-index (format nil "~a, ~a" (name cat) (name subcat))
                nil
                nil
                (h-gen-full-url 'r-rss-cat-subcat
                                :cat (slug cat)
                                :subcat (slug subcat))
                (get-articles-by-cat-subcat cat subcat)
                'r-cat-subcat-page :cat (slug cat) :subcat (slug subcat))))

(defun v-author (username &optional (page 0))
  (let ((author (get-author-by-username (string-to-utf-8 username :latin1))))
    (view-index (name author)
                (let ((description (description author)))
                  (fmtnil (<:style (format nil
                                           "#bkgrnd {background-image: url('/uploads/photos/~a')}"
                                           (background author)))
                          (when description
                            (<:div :id "a-details"
                                   (get-author-photo author (get-config "photo.author.avatar.size"))
                                   (<:p description)))))
                nil
                (h-gen-full-url 'r-rss-author :author (username author))
                (get-articles-by-author author)
                'r-author-page :author (username author))))

(defun v-tag (slug &optional (page 0))
  (let ((slug (string-to-utf-8 slug :latin1)))
    (view-index (name (get-tag-by-slug slug))
                nil
                nil
                nil
                (get-articles-by-tag-slug slug)
                'r-tag-page :tag slug)))

(defun v-404 ()
  (let ((page 0))
    (view-index "404"
                (<:p :class "error"
                     (translate "404" (<:a :href "javascript:history.go(-1)" (translate "here"))))
                nil
                nil
                (get-active-articles)
                'r-home)))

(defun v-search ())
