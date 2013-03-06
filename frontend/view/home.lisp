(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; view function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-ajax-home-category-articles (cat-slug page)
  (let* ((related-length (get-config "pagination.article.related"))
         (list (splice (get-articles-by-cat (get-category-by-slug cat-slug))
                       :from (* page related-length)
                       :to (1- (* (1+ page) related-length)))))
    (if list
        (regex-replace-all              ; need to remove the '\\' that
         "\\\\" ; encode-json-to-string adds before every '/' in the photo path :(
         (encode-json-to-string
          `((:status . "success")
            (:data . ,(article-carousel-markup list))))
         "")
        (encode-json-to-string
         `((:status . "failure")
           (:data . nil))))))

(defun v-home (&optional (page 0))
  (view-index "Home"                    ; XXX: translate
              (get-active-articles)
              'r-home-page)
  ;; TODO till we get more articles
  #- (and)
  (fe-page-template
      (get-config "site.name")
      nil
      nil
      nil
    (let ((carousel-tabs (get-config "pagination.home.carousel.tabs"))
          (related-length (get-config "pagination.article.related")))
      (htm (:div :id "jumbotron")
           (:div :id "categories-carousel"
                 (dolist (cat (get-home-page-categories carousel-tabs))
                   (str (article-carousel-container ""
                                                    (:span (:a :href (h-genurl 'r-cat :cat (slug cat))
                                                               (str (name cat))))
                                                    (get-articles-by-cat cat)
                                                    (h-genurl 'r-ajax-home-category-articles
                                                              :cat-slug (slug cat)
                                                              :page 0)))))
           (:div :id "authors")))))
