(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page header
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun logo ()
  (with-html
    (:img :id "logo"
          :source ""
          :alt "logo")))

(defun site-search ()
  (with-html
    (:form :method "GET"
           :action "/search/"
           :name "search"
           :id "search"
           (:input :type "input"
                   :name "q"
                   :value "Search")
           (:input :type "submit"
                   :value "Submit"))))

(defun trending ()
  (with-html
    (:div :id "trending-tags")))

(defun navigation ()
  (with-html
    (:div :id "navigation")))

(defun header ()
  (with-html
    (:div :id "hd"
          (:div :id "banner"
                (str (logo))
                (str (site-search)))
          (str (trending))
          (str (navigation)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page footer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun footer ()
  (with-html
    (:div :id "ft")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ads
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ads-1 ()
  (with-html
    (:div :id "ads-1")))

(defun ads-2 ()
  (with-html
    (:div :id "ads-2")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page template
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro page-template (&body content)
  `(with-html
     (:html
      (:body
       (str (header))
       (:div :id "bd"
             (:div :id "col-1"
                   (:div :id "popular")
                   (str (ads-1)))
             (:div :id "col-2"
                   ,@content)
             (:div :id "col-3"
                   (str (ads-2))))
       (str (footer))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun latest-articles (offset)
  (declare (ignore offset)))

(defun latest-articles-in-category (offset &optional (category (most-viewed-category)))
  (declare (ignore offset category)))

(defun most-popular-articles (offset)
  (declare (ignore offset)))

(defun most-popular-articles-in-category (offset &optional (category (most-viewed-category)))
  (declare (ignore offset category)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; views
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun view-article (title-and-id)
  (let* ((id (first (split-sequence:split-sequence "-" title-and-id :from-end t :test #'string-equal :count 1)))
         (article (get-article-by-id *article-storage* (parse-integer id))))
    (page-template
      (:div (:p :id "a-title" (str (title article)))
              (:p :id "a-date" (str (date article)))
              (:p :id "a-body" (str (body article)))))))

(defun view-home (&optional (page-number "0"))
  (let ((offset (* (parse-integer page-number) *article-pagination-limit*)))
    (page-template
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
                                                                      (slug article)
                                                                      (id article)))
                           (str (title article)))
                       (:p :class "a-date" (str (date article)))
                       (:p :class "a-summary" (str (summary article))))))))
            #|(:div :class "popular" (htm (most-popular-articles offset)))|#))))

(defun view-cat (cat)
  (declare (ignore cat)))

(defun view-cat-subcat (cat subcat)
  (declare (ignore cat subcat)))

(defun view-author (author)
  (declare (ignore author)))

(defun view-tag (tag)
  (declare (ignore tag)))

(defun view-search ())
