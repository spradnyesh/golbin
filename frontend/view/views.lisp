(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; views
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun view-article (slug-and-id)
  (let* ((id (first (split-sequence:split-sequence "-" slug-and-id :from-end t :test #'string-equal :count 1)))
         (article (get-article-by-id (parse-integer id) *article-storage*)))
    (page-template
        (title article)
        (most-popular-articles-markup :category (cat article))
      (:div (:p :id "a-title" (str (title article)))
            (:p :id "a-details"
                "written by "
                (:a :id "a-author"
                    :href (genurl 'route-author :author (handle (author article)))
                    (str (name (author article))))
                " on "
                (:span :id "a-date" (str (date article)))
                " in category "
                (:a :id "a-cat"
                    :href (genurl 'route-cat :cat (slug (cat article)))
                    (str (name (cat article))))
                ", subcategory "
                (:a :id "a-cat-subcat"
                    :href (genurl 'route-cat-subcat :cat (slug (cat article)) :subcat (slug (subcat article)))
                    (str (name (subcat article))))
                " using tags "
                (:span :id "a-tags" (str (get-article-tags-markup article))))
            (:p :id "a-body" (str (body article)))))))

(defmacro view-index (title popular-markup articles-list route &rest route-params)
  `(let* ((page (parse-integer page))
          (offset (* page *article-pagination-limit*)))
     (page-template
         ,title
         ,popular-markup
       (htm
        (:div :id "articles"
              (:ul
               (dolist (article (paginate ,articles-list
                                          :offset offset
                                          :limit *article-pagination-limit*))
                 (htm
                  (:li
                   (:h3 (:a :class "a-title"
                            :href (genurl 'route-article
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
                       (count-articles *article-storage*)
                       *article-pagination-limit*
                     ,@route-params)
                  `(pagination-markup ,route
                       page
                       (count-articles *article-storage*)
                       *article-pagination-limit*)))))))

(defun view-home (&optional (page "0"))
  (view-index "Home"
              (most-popular-articles-markup)
              (get-all-articles)
              'route-home-page))

(defun view-cat (cat &optional (page "0"))
  (view-index cat
              (most-popular-articles-markup)
              (get-articles-by-cat-slug cat *article-storage* *category-storage*)
              'route-cat-page :cat cat))

(defun view-cat-subcat (cat subcat &optional (page "0"))
  (view-index (format nil "~a, ~a" cat subcat)
              (most-popular-articles-markup)
              (get-articles-by-cat-subcat-slugs cat subcat *article-storage* *category-storage*)
              'route-cat-subcat-page :cat cat :subcat subcat))

(defun view-author (author &optional (page "0"))
  (view-index author
              (most-popular-articles-markup)
              (get-articles-by-author-handle author *article-storage*)
              'route-author-page :author author))

(defun view-tag (tag &optional (page "0"))
  (view-index tag
              (most-popular-articles-markup)
              (get-articles-by-tag-slug tag *article-storage*)
              'route-tag-page :tag tag))

(defun view-search ())
