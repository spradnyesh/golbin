(in-package :hawksbill.golbin)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro article-related (div-name entity-name list route-name &rest route-params)
  `(with-html
     (when ,list
       (htm (:div (:h3 (format nil "~a~a~a~a"
                               (str "Related articles for ")
                               (str ,div-name)
                               (str ": ")
                               (htm (:a :href (genurl ,route-name
                                                      ,@route-params)
                                        (str ,entity-name)))))
                  (str (related-article-markup
                        (splice ,list :to (min (length ,list)
                                               (1- (get-config "pagination.article.related")))))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun article-lead-photo-url (photo photo-direction)
  (let* ((photo-size-config-name (format nil "photo.article-lead.~a" photo-direction))
         (photo-size (format nil
                             "~ax~a"
                             (get-config (format nil
                                                 "~a.max-width"
                                                 photo-size-config-name))
                             (get-config (format nil
                                                 "~a.max-height"
                                                 photo-size-config-name))))
         ;; XXX: photo filename should contain *exactly* 1 dot
         (name-extn (split-sequence "." (filename photo) :test #'string-equal)))
    (with-html (:img :src (format nil
                                  "/static/photos/~a_~a.~a"
                                  (first name-extn)
                                  photo-size
                                  (second name-extn))
                     :alt (title photo)))))

(defun related-article-markup (article-list)
  (with-html
    (:div :class "related"
          (dolist (article article-list)
            (htm (:li
                  (when (photo article)
                    (htm (:div :class "related-thumb"
                               (str (article-lead-photo-url (photo article) "related-thumb")))))
                  (:a :class "a-title"
                      :href (genurl 'fe-r-article
                                    :slug-and-id (format nil "~A-~A"
                                                         (slug article)
                                                         (id article)))
                      (str (title article)))))))))

(defun fe-article-tags-markup (article)
  (with-html
    (dolist (tag (tags article))
      (htm " "
       (:a :href (genurl 'fe-r-tag :tag (slug tag))
           (str (name tag)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; views
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun fe-v-article (slug-and-id)
  (let* ((id (first (split-sequence "-" slug-and-id :from-end t :test #'string-equal :count 1)))
         (article (get-article-by-id (parse-integer id))))
    (fe-page-template
        (title article)
        (:div
         (:div :id "article"
          (:h2 :id "a-title" (str (title article)))
          (:p :id "a-details" :class "small"
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
                                       'fe-r-cat-subcat
                                       :cat (slug (cat article))
                                       :subcat (slug (subcat article))))
                 (str (article-related "Author"
                                       (name (author article))
                                       author
                                       'fe-r-author
                                       :author (handle (author article))))))))))
