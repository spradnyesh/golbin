(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun article-preamble-markup (article)
  (with-html
    (:h2 :id "a-title" (str (title article)))
    (:p :id "a-details" :class "small"
        (str "written by ") ; XXX: translate
        (:a :id "a-author"
            :href (h-genurl 'r-author :author (handle (author article)))
            (str (alias (author article))))
        (str " on ")
        (:span :id "a-date" (str (date article)))
        (str " in category ")
        (:a :id "a-cat"
            :href (h-genurl 'r-cat :cat (slug (cat article)))
            (str (name (cat article))))
        (when (not (string= "--" (name (subcat article))))
          (str " / ")
          (htm
           (:a :id "a-cat-subcat"
               :href (h-genurl 'r-cat-subcat
                             :cat (slug (cat article))
                             :subcat (slug (subcat article)))
               (str (name (subcat article))))))
        (str ", using tags ")
        (:span :id "a-tags" (str (fe-article-tags-markup article))))))

(defun do-child-comments (parent-id children)
  (with-html (:ul :class "comment"
                  (let ((i 0)
                        (str-i nil))
                    (dolist (child children)
                      (setf str-i (write-to-string i))
                      (str (get-comment-markup child
                                               (if (string= "-1" parent-id)
                                                   str-i
                                                   (join-string-list-with-delim "." (list parent-id str-i)))))
                      (incf i))))))

(defun get-comment-markup (comment parent-id)
  (with-html (:li (:p :class "c-name" (str (username comment)))
                  (let ((url (userurl comment)))
                    (when url
                      (htm (:p :class "c-url" (str url)))))
                  (:p :class "c-body" (str (body comment)))
                  (:p :class "c-reply" (:a :id parent-id :href "" "Reply")) ; XXX: translate
                  (let ((children (children comment)))
                    (when children
                      (str (do-child-comments parent-id children)))))))

(defun article-comments-markup (article slug-and-id)
  (with-html (:form :id "a-comments"
                    :method "POST"
                    :action (h-genurl 'r-article-comment :slug-and-id slug-and-id)
                   (let ((children (comments article)))
                     (when children
                       (str (do-child-comments "-1" children))))
                   (:input :class "td-input parent"
                                             :type "hidden"
                                             :name "parent")
                   (:p :class "c-reply" (:a :id "-1" :href "" "Add a comment") ; XXX: translate
                       (:table :id "c-table"
                               (str (tr-td-input "name"))
                               (str (tr-td-input "email/url"))
                               (str (tr-td-text "comment"))
                               (str (tr-td-input "submit" :value "Submit" :typeof "submit"))))))) ; XXX: translate

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
                                    (:p :class "title" (str (title photo)))
                                    (let ((attr (attribution photo)))
                                      (when attr
                                        (htm (:a :class "attribution" :href attr "photo attribution")))))))))
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
            (str (article-carousel-container "Articles in the same Category/Subcategory: "
                                             (:span (:a :href (h-genurl 'r-cat
                                                                      :cat (slug cat))
                                                        (str (name cat)))
                                                    " / "
                                                    (:a :href (h-genurl 'r-cat-subcat
                                                                      :cat (slug cat)
                                                                      :subcat (slug subcat))
                                                        (str (name subcat))))
                                             cat-subcat-list
                                             (h-genurl 'r-ajax-article-related
                                                     :id id
                                                     :typeof "cat-subcat"
                                                     :page 0)))
            (str (article-carousel-container "Articles authored by: "
                                             (:span (:a :href (h-genurl 'r-author
                                                                      :author (handle author))
                                                        (str (alias author))))
                                             author-list
                                             (h-genurl 'r-ajax-article-related
                                                     :id id
                                                     :typeof "author"
                                                     :page 0)))))))

(defun fe-article-tags-markup (article)
  (with-html
    (dolist (tag (tags article))
      (htm " "
       (:a :href (h-genurl 'r-tag :tag (slug tag))
           (str (name tag)))))))

(defun get-id-from-slug-and-id (slug-and-id)
  (parse-integer (first (split-sequence "-" slug-and-id
                                        :from-end t
                                        :test #'string-equal
                                        :count 1))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; views
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-article (slug-and-id &optional (editorial nil))
  (let* ((id (get-id-from-slug-and-id slug-and-id))
         (article (get-article-by-id id))
         (tags (append (loop for tag in (tags article)
                          collect (name tag))
                       (list (name (cat article))
                             (name (subcat article))))))
    (when (or (eql :a (status article))
              editorial)
      (fe-page-template
          (title article)
          nil
          tags
          (summary article)
        (:div :id "articles" ; HACK: needed for css
         (:div :id "article"
               (str (article-preamble-markup article))
               (str (article-body-markup article))
               (str (article-comments-markup article slug-and-id)))
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; comments
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-comment (slug-and-id)
  (let ((parent (post-parameter "parent"))
        (name (post-parameter "name"))
        (email/url (post-parameter "email/url"))
        (body (post-parameter "comment")))
    (add-article-comment (get-article-by-id (get-id-from-slug-and-id slug-and-id))
                         parent
                         (make-instance 'comment
                                        :body body
                                        :status :a
                                        :username name
                                        :userurl email/url
                                        :userip (remote-addr *request*)
                                        :useragent (user-agent)))
    (redirect (h-genurl 'r-article :slug-and-id slug-and-id))))
