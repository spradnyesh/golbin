(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; views
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun view-article (slug-and-id)
  (let* ((id (first (split-sequence "-" slug-and-id :from-end t :test #'string-equal :count 1)))
         (article (get-article-by-id (parse-integer id))))
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
                ", "
                (:a :id "a-cat-subcat"
                    :href (genurl 'route-cat-subcat :cat (slug (cat article)) :subcat (slug (subcat article)))
                    (str (name (subcat article))))
                " using tags "
                (:span :id "a-tags" (str (get-article-tags-markup article))))
            (:p :id "a-body" (str (body article)))))))

(defun view-home (&optional (page "0"))
  (view-index "Home"
              (most-popular-articles-markup)
              (get-active-articles)
              'route-home-page))

(defun view-cat (cat-slug &optional (page "0"))
  (let ((cat (get-category-by-slug cat-slug 0)))
    (view-index (name cat)
                (most-popular-articles-markup)
                (get-articles-by-cat cat)
                'route-cat-page :cat (slug cat))))

(defun view-cat-subcat (cat-slug subcat-slug &optional (page "0"))
  (let* ((cat (get-category-by-slug cat-slug 0))
         (subcat (get-category-by-slug subcat-slug (id cat))))
    (view-index (format nil "~a, ~a" (name cat) (name subcat))
                (most-popular-articles-markup)
                (get-articles-by-cat-subcat cat subcat)
                'route-cat-subcat-page :cat (slug cat) :subcat (slug subcat))))

(defun view-author (author-handle &optional (page "0"))
  (let ((author (get-author-by-handle author-handle)))
    (view-index (name author)
                (most-popular-articles-markup)
                (get-articles-by-author author)
                'route-author-page :author (handle author))))

(defun view-tag (slug &optional (page "0"))
  (view-index (name (get-tag-by-slug slug))
              (most-popular-articles-markup)
              (get-articles-by-tag-slug slug)
              'route-tag-page :tag slug))

(defun view-search ())
