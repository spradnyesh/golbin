(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro view-index (title articles-list route &rest route-params)
  `(if ,articles-list
       (let* ((num-per-page (get-config "pagination.article.limit"))
              (num-pages (get-config "pagination.article.range"))
              (offset (* page num-per-page)))
         (template
          :title ,title
          :js nil
          :tags (list ,title)
          :description nil
          :body (progn
                  (<:div :id "articles"
                         (<:ul
                          (dolist (article (paginate ,articles-list
                                                     offset
                                                     num-per-page))
                            (<:li
                             (when (photo article)
                               (<:div :class "index-thumb"
                                      (article-lead-photo-url (photo article) "index-thumb")))
                             (<:h3 (<:a :class "a-title"
                                        :href (h-genurl 'r-article
                                                        :slug-and-id (format nil "~A-~A"
                                                                             (slug article)
                                                                             (id article)))
                                        (title article)))
                             (<:span :class "a-cite small"
                                     (format nil
                                             "~a - ~a ~a- ~a"
                                             (alias (author article))
                                             (name (cat article))
                                             (let ((subcat-name (name (subcat article))))
                                               (if (not (string= "--" subcat-name))
                                                   (format nil ", ~a " subcat-name)
                                                   ""))
                                             (prettyprint-date (universal-to-timestamp (date article)))))
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
                                           ,route)))))
       (v-404)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; view functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-cat (cat-slug &optional (page 0))
  (let ((cat (get-category-by-slug (utf-8-bytes-to-string (string-to-octets cat-slug)) 0)))
    (view-index (name cat)
                (get-articles-by-cat cat)
                'r-cat-page :cat (slug cat))))

(defun v-cat-subcat (cat-slug subcat-slug &optional (page 0))
  (let* ((cat (get-category-by-slug (utf-8-bytes-to-string (string-to-octets cat-slug)) 0))
         (subcat (when cat
                   (get-category-by-slug (utf-8-bytes-to-string (string-to-octets subcat-slug)) (id cat)))))
    (view-index (format nil "~a, ~a" (name cat) (name subcat))
                (get-articles-by-cat-subcat cat subcat)
                'r-cat-subcat-page :cat (slug cat) :subcat (slug subcat))))

(defun v-author (author-handle &optional (page 0))
  (let ((author (get-author-by-handle (utf-8-bytes-to-string (string-to-octets author-handle)))))
    (view-index (name author)
                (get-articles-by-author author)
                'r-author-page :author (handle author))))

(defun v-tag (slug &optional (page 0))
  (view-index (name (get-tag-by-slug (utf-8-bytes-to-string (string-to-octets slug))))
              (get-articles-by-tag-slug slug)
              'r-tag-page :tag slug))

(defun v-search ())
