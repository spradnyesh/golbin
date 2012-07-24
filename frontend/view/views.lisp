(in-package :hawksbill.golbin)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; views
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun fe-v-article (slug-and-id)
  (let* ((id (first (split-sequence "-" slug-and-id :from-end t :test #'string-equal :count 1)))
         (article (get-article-by-id (parse-integer id))))
    (fe-page-template
        (title article)
        (fe-most-popular-articles-markup :category (cat article))
      (:div (:p :id "a-title" (str (title article)))
            (:p :id "a-details"
                "written by "
                (:a :id "a-author"
                    :href (genurl 'fe-r-author :author (handle (author article)))
                    (str (name (author article))))
                " on "
                (:span :id "a-date" (str (date article)))
                " in category "
                (:a :id "a-cat"
                    :href (genurl 'fe-r-cat :cat (slug (cat article)))
                    (str (name (cat article))))
                ", "
                (:a :id "a-cat-subcat"
                    :href (genurl 'fe-r-cat-subcat :cat (slug (cat article)) :subcat (slug (subcat article)))
                    (str (name (subcat article))))
                " using tags "
                (:span :id "a-tags" (str (fe-get-article-tags-markup article))))
            (:div :id "a-body"
				  (let ((photo (photo article)))
					(when photo
					  (let* ((photo-direction (photo-direction article))
							 (pd (cond ((eql :l photo-direction) "left")
									   ((eql :r photo-direction) "right")
									   ((eql :b photo-direction) "block"))))
						(htm (:div :class pd
								   (str (get-article-lead-photo-url photo pd))
								   (:p (str (title photo))))))))
				  (str (body article)))))))

(defun fe-v-home (&optional (page 0))
  (view-index "Home"
              (fe-most-popular-articles-markup)
              (get-all-articles)
              'fe-r-home-page))

(defun fe-v-cat (cat-slug &optional (page 0))
  (let ((cat (get-category-by-slug cat-slug 0)))
    (view-index (name cat)
                (fe-most-popular-articles-markup)
                (get-articles-by-cat cat)
                'fe-r-cat-page :cat (slug cat))))

(defun fe-v-cat-subcat (cat-slug subcat-slug &optional (page 0))
  (let* ((cat (get-category-by-slug cat-slug 0))
         (subcat (get-category-by-slug subcat-slug (id cat))))
    (view-index (format nil "~a, ~a" (name cat) (name subcat))
                (fe-most-popular-articles-markup)
                (get-articles-by-cat-subcat cat subcat)
                'fe-r-cat-subcat-page :cat (slug cat) :subcat (slug subcat))))

(defun fe-v-author (author-handle &optional (page 0))
  (let ((author (get-author-by-handle author-handle)))
    (view-index (name author)
                (fe-most-popular-articles-markup)
                (get-articles-by-author author)
                'fe-r-author-page :author (handle author))))

(defun fe-v-tag (slug &optional (page 0))
  (view-index (name (get-tag-by-slug slug))
              (fe-most-popular-articles-markup)
              (get-articles-by-tag-slug slug)
              'fe-r-tag-page :tag slug))

(defun fe-v-search ())
