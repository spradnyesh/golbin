(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro article-related (div-name entity-name list route-name &rest route-params)
  `(with-html
     (when ,list
       (let ((related-length (get-config "pagination.article.related")))
         (htm (:div (:h3 (format nil "~a~a~a~a"
                                 (str "Related articles for ")
                                 (str ,div-name)
                                 (str ": ")
                                 (htm (:a :href (genurl ,route-name
                                                        ,@route-params)
                                          (str ,entity-name)))))
                    (:div :class "prev hidden")
                    (:p :class "prev left" (:a :href "" "prev"))
                    (:div :class "current"
                          (str (related-article-markup
                                (splice ,list :to (min (length ,list)
                                                       (1- related-length))))))
                    (:p :class "next right" (:a :href "" "next"))
                    (:div :class "next hidden"
                          (str (related-article-markup
                                (splice ,list
                                        :from related-length
                                        :to (min (length ,list)
                                                 (1- (* 2 related-length)))))))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun related-article-markup (article-list)
  (with-html
    (:ul :class "related"
          (dolist (article article-list)
            (htm (:li
                  (when (photo article)
                    (htm (:div :class "related-thumb"
                               (str (article-lead-photo-url (photo article) "related-thumb")))))
                  (:a :class "a-title"
                      :href (genurl 'r-article
                                    :slug-and-id (format nil "~A-~A"
                                                         (slug article)
                                                         (id article)))
                      (str (title article)))))))))

(defun fe-article-tags-markup (article)
  (with-html
    (dolist (tag (tags article))
      (htm " "
       (:a :href (genurl 'r-tag :tag (slug tag))
           (str (name tag)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; views
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-article (slug-and-id)
  (let ((article (get-article-by-id (parse-integer (first (split-sequence "-" slug-and-id :from-end t :test #'string-equal :count 1))))))
    (fe-page-template
        (title article)
        nil
        (:div
         (:div :id "article"
          (:h2 :id "a-title" (str (title article)))
          (:p :id "a-details" :class "small"
              "written by "
              (:a :id "a-author"
                  :href (genurl 'r-author :author (handle (author article)))
                  (str (name (author article))))
              " on "
              (:span :id "a-date" (str (date article)))
              " in category "
              (:a :id "a-cat"
                  :href (genurl 'r-cat :cat (slug (cat article)))
                  (str (name (cat article))))
              ", "
              (:a :id "a-cat-subcat"
                  :href (genurl 'r-cat-subcat :cat (slug (cat article)) :subcat (slug (subcat article)))
                  (str (name (subcat article))))
              " using tags "
              (:span :id "a-tags" (str (fe-article-tags-markup article))))
          (:div :id "a-body"
                (let ((photo (photo article)))
                  (when photo
                    (let* ((photo-direction (photo-direction article))
                           (pd (cond ((eql :l photo-direction) "left")
                                     ((eql :r photo-direction) "right")
                                     ((eql :b photo-direction) "block"))))
                      (htm (:div :class pd
                                 (str (article-lead-photo-url photo pd))
                                 (:p (str (title photo))))))))
                (str (body article))))
         (:div :id "related"
               (multiple-value-bind (cat-subcat author) (get-related-articles article)
                 (str (article-related "Category/Subcategory"
                                       (format nil "~a/~a" (name (cat article)) (name (subcat article)))
                                       cat-subcat
                                       'r-cat-subcat
                                       :cat (slug (cat article))
                                       :subcat (slug (subcat article))))
                 (str (article-related "Author"
                                       (name (author article))
                                       author
                                       'r-author
                                       :author (handle (author article))))))))))
