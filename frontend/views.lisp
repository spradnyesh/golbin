(in-package :hawksbill.golbin.frontend)

(defun head ())

(defun navigation ())

(defun foot ())

(defun ads-left ())

(defun ads-right ())

(defun latest-articles (offset)
  (declare (ignore offset)))

(defun most-popular-articles (offset)
  (declare (ignore offset)))

(defun view-home (&optional (page-number "0"))
  (let ((offset (* (parse-integer page-number) *article-pagination-limit*)))
    (with-html-output-to-string (out)
      (:html
       (:body
        (:div :class "hd"
              (:div :class "banner"
                    (:img :class "logo"
                          :source ""
                          :alt "logo")
                    (:div :class "search"
                          (:form :method "GET"
                                 :action "/search/"
                                 (:input :type "input"
                                         :name "q"
                                         :value "Search")
                                 (:input :type "submit"
                                         :value "Submit"))))
              (:div :class "trending-tags")
              (:div :class "navigation"))
        (:div :class "bd"
              (:div :class "articles"
                    (:div :class "latest"
                          (:ul
                           (dolist (article (paginate (get-all-articles *article-storage*)
                                                      :offset offset))
                             (htm
                              (:li
                               (:a :class "a-title"
                                   :href (restas:genurl 'route-article
                                                        :title-and-id (format nil "~A-~A"
                                                                              (title article)
                                                                              (id article)))
                                   (str (title article)))
                               (:p :class "a-date" (str (date article)))
                               (:p :class "a-summary" (str (summary article))))))))
                    #|(:div :class "popular" (htm (most-popular-articles offset)))|#))
        (:div :class "ft"))))))

(defun view-cat (cat)
  (declare (ignore cat)))

(defun view-cat-subcat (cat subcat)
  (declare (ignore cat subcat)))

(defun view-author (author)
  (declare (ignore author)))

(defun view-tag (tag)
  (declare (ignore tag)))

(defun view-article (title-and-id)
  (let* ((id (first (split-sequence:split-sequence "-" title-and-id :from-end t :test #'string-equal :count 1)))
         (article (get-article-by-id *article-storage* (parse-integer id))))
    (with-html-output-to-string (out)
      (:html
       (:body
        (:div (:p :class "a-title" (str (title article)))
              (:p :class "a-date" (str (date article)))
              (:p :class "a-body" (str (body article)))))))))

(defun view-search ())
