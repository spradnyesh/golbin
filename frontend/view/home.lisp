(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; view function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-ajax-home-category-articles (cat-slug page)
  (declare (ignore cat-slug page)))

(defun v-home ()
  (fe-page-template (get-config "site.name")
      nil
    (let ((carousel-tabs (get-config "pagination.home.carousel.tabs"))
          (related-length (get-config "pagination.article.related")))
      (htm (:div :id "jumbotron")
           (:div :id "categories-carousel"
                 (dolist (cat (get-home-page-categories carousel-tabs))
                   (str (article-carousel-container ""
                                                    (:span (:a :href (genurl 'r-cat :cat (slug cat))
                                                               (str (name cat))))
                                                    (get-articles-by-cat cat)
                                                    (genurl 'r-ajax-home-category-articles
                                                            :cat-slug (slug cat)
                                                            :page 0)))))
           (:div :id "authors")))))
