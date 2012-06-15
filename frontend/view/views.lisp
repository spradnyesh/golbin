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
                (:a :id "a-author"
                    :href (genurl 'route-author :author (handle (author article)))
                    (str (name (author article))))
                (:span :id "a-date" (str (date article))))
            (:p :id "a-body" (str (body article)))))))

(defun view-home (&optional (page "0"))
  (let* ((page (parse-integer page))
         (offset (* page *article-pagination-limit*)))
    (page-template
        "Home"
        (most-popular-articles-markup)
      (htm
       (:div :id "articles"
             (:ul
              (dolist (article (paginate (get-all-articles *article-storage*)
                                         :offset offset
                                         :limit *article-pagination-limit*))
                (htm
                 (:li
                  (:a :class "a-title"
                      :href (genurl 'route-article
                                    :slug-and-id (format nil "~A-~A"
                                                         (slug article)
                                                         (id article)))
                      (str (title article)))
                  (:p :class "a-date" (str (date article)))
                  (:p :class "a-summary" (str (summary article))))))))
       (str (pagination-markup 'route-home-page
                               page
                               (count-articles *article-storage*)
                               *article-pagination-limit*))))))

(defun view-cat (cat &optional (page "0"))
  (declare (ignore cat page)))

(defun view-cat-subcat (cat subcat &optional (page "0"))
  (declare (ignore cat subcat page)))

(defun view-author (author &optional (page "0"))
  (declare (ignore author page)))

(defun view-tag (tag &optional (page "0"))
  (declare (ignore tag page)))

(defun view-search ())
