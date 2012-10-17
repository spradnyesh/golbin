(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun article-preamble-markup (article)
  (with-html
    (:h2 :id "a-title" (str (title article)))
    (:p :id "a-details" :class "small"
        (str #!"written by ")
        (:a :id "a-author"
            :href (genurl 'r-author :author (handle (author article)))
            (str (alias (author article))))
        (str #!" on ")
        (:span :id "a-date" (str (date article)))
        (str #!" in category ")
        (:a :id "a-cat"
            :href (genurl 'r-cat :cat (slug (cat article)))
            (str (name (cat article))))
        (when (subcat article)
          (str #!" / ")
          (htm
           (:a :id "a-cat-subcat"
               :href (genurl 'r-cat-subcat
                             :cat (slug (cat article))
                             :subcat (slug (subcat article)))
               (str (name (subcat article))))))
        (str #!", using tags ")
        (:span :id "a-tags" (str (fe-article-tags-markup article))))))

(defun article-body-markup (article)
  (with-html (:div :id "a-body"
                   (let ((photo (photo article)))
                     (when photo
                       (let* ((photo-direction (photo-direction article))
                              (pd (cond ((eql :l photo-direction) "left")
                                        ((eql :r photo-direction) "right")
                                        ((eql :b photo-direction) "block"))))
                         (htm (:div :class pd
                                    (str (article-lead-photo-url photo pd))
                                    (:p (str (title photo))))))))
                   (str (body article)))))

(defun article-related-markup (id article)
  (with-html
    (:div :id "related"
          (:span :class "hidden" (str id))
          (let ((related-length (get-config "pagination.article.related"))
                (cat (cat article))
                (subcat (subcat article))
                (author (author article))
                (cat-subcat-list (get-related-articles "cat-subcat" article))
                (author-list (get-related-articles "author" article)))
            (str (article-carousel-container #!"Articles in the same Category/Subcategory: "
                                             (:span (:a :href (genurl 'r-cat
                                                                      :cat (slug cat))
                                                        (str (name cat)))
                                                    " / "
                                                    (:a :href (genurl 'r-cat-subcat
                                                                      :cat (slug cat)
                                                                      :subcat (slug subcat))
                                                        (str (name subcat))))
                                             cat-subcat-list
                                             (genurl 'r-ajax-article-related
                                                     :id id
                                                     :typeof "cat-subcat"
                                                     :page 0)))
            (str (article-carousel-container #!"Articles authored by: "
                                             (:span (:a :href (genurl 'r-author
                                                                      :author (handle author))
                                                        (str (alias author))))
                                             author-list
                                             (genurl 'r-ajax-article-related
                                                     :id id
                                                     :typeof "author"
                                                     :page 0)))))))

(defun fe-article-tags-markup (article)
  (with-html
    (dolist (tag (tags article))
      (htm " "
       (:a :href (genurl 'r-tag :tag (slug tag))
           (str (name tag)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; views
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-article (slug-and-id &optional (editorial nil))
  (let* ((id (parse-integer (first (split-sequence "-" slug-and-id
                                                   :from-end t
                                                   :test #'string-equal
                                                   :count 1))))
         (article (get-article-by-id id)))
    (when (or (eql :a (status article))
              editorial)
      (fe-page-template
          (title article)
          nil
        (:div
         (:div :id "article"
               (str (article-preamble-markup article))
               (str (article-body-markup article)))
         (str (article-related-markup id article)))))))

(defun v-ajax-article-related (id typeof page)
  (let* ((related-length (get-config "pagination.article.related"))
         (list (splice (get-related-articles typeof (get-article-by-id id))
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
