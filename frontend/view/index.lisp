(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro view-index (title articles-list route &rest route-params)
  `(if ,articles-list
     (let* ((num-per-page (get-config "pagination.article.limit"))
            (num-pages (get-config "pagination.article.range"))
            (offset (* page num-per-page)))
       (fe-page-template
           ,title
           nil
           (list ,title)
           nil
         (htm
          (:div :id "articles"
                (:ul
                 (dolist (article (paginate ,articles-list
                                            offset
                                            num-per-page))
                   (htm
                    (:li
                     (when (photo article)
                       (htm (:div :class "index-thumb"
                                  (str (article-lead-photo-url (photo article) "index-thumb")))))
                     (:h3 (:a :class "a-title"
                              :href (h-genurl 'r-article
                                            :slug-and-id (format nil "~A-~A"
                                                                 (slug article)
                                                                 (id article)))
                              (str (title article))))
                     (:cite :class "a-cite small" (str (format nil
                                                               "~a, ~a - ~a"
                                                               (name (cat article))
                                                               (name (subcat article)) (date article))))
                     (:p :class "a-summary" (str (summary article))))))))
          (str ,(if route-params
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
                                        ,route))))))
     (fe-page-template
         ,title
         nil
         nil
         nil
       (htm (:div :id "articles"
                  (:div :id "error" "Sorry! We were unable to find the content that you are looking for. Please click "
                        (:a :href "javascript:history.go(-1)" "here")
                        " to go back.")))))) ; XXX: translate

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; view functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-cat (cat-slug &optional (page 0))
  (let ((cat (get-category-by-slug cat-slug 0)))
    (view-index (name cat)
                (get-articles-by-cat cat)
                'r-cat-page :cat (slug cat))))

(defun v-cat-subcat (cat-slug subcat-slug &optional (page 0))
  (let* ((cat (get-category-by-slug cat-slug 0))
         (subcat (get-category-by-slug subcat-slug (id cat))))
    (view-index (format nil "~a, ~a" (name cat) (name subcat))
                (get-articles-by-cat-subcat cat subcat)
                'r-cat-subcat-page :cat (slug cat) :subcat (slug subcat))))

(defun v-author (author-handle &optional (page 0))
  (let ((author (get-author-by-handle author-handle)))
    (view-index (name author)
                (get-articles-by-author author)
                'r-author-page :author (handle author))))

(defun v-tag (slug &optional (page 0))
  (view-index (name (get-tag-by-slug slug))
              (get-articles-by-tag-slug slug)
              'r-tag-page :tag slug))

(defun v-search ())
