(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro article-preamble-markup-common (key &optional tags)
  `(translate ,key
              (<:a :id "a-author"
                  :href (h-genurl 'r-author
                                  :author (handle (author article)))
                  (alias (author article)))
              (prettyprint-date timestamp)
              (prettyprint-time timestamp)
              (<:a :id "a-cat"
                  :href (h-genurl 'r-cat
                                  :cat (slug (cat article)))
                  (name (cat article)))
              (if (string= "--" (name (subcat article)))
                  ""
                  (<:a :id "a-cat-subcat"
                      :href (h-genurl 'r-cat-subcat
                                      :cat (slug (cat article))
                                      :subcat (slug (subcat article)))
                      (name (subcat article))))
              ,tags))

(defun article-preamble-markup (article)
  (let ((timestamp (universal-to-timestamp (date article)))
        (tags (tags article)))
    (<:h2 :id "a-title" (title article))
    (<:span :id "a-cite" :class "small"
           (if tags
               (article-preamble-markup-common
                "written-by-with-tags"
                (<:span :id "a-tags"
                        (fe-article-tags-markup tags)))
               (article-preamble-markup-common "written-by-without-tags")))))

(defun do-child-comments (parent-id children)
  (<:ul :class "comment"
       (let ((i 0)
             (str-i nil))
         (dolist (child children)
           (setf str-i (write-to-string i))
           (get-comment-markup child
                               (if (string= "-1" parent-id)
                                   str-i
                                   (join-string-list-with-delim "." (list parent-id str-i))))
           (incf i)))))

(defun get-comment-markup (comment parent-id)
  (<:li (<:p :class "c-name-says"
           (<:span :class "c-name" (username comment))
           (<:span :class "c-says" " says:")) ; XXX: translate
       (<:p :class "c-date-at" (date comment))
       (let ((url (userurl comment)))
         (when url
           (<:p :class "c-url" url)))
       (<:p :class "c-body" (body comment))
       (<:p :class "c-reply" (<:a :id parent-id :href "" "Reply")) ; XXX: translate
       (let ((children (children comment)))
         (when children
           (do-child-comments parent-id children)))))

(defun article-comments-markup (article slug-and-id)
  (<:form :id "a-comments"
         :method "POST"
         :action (h-genurl 'r-article-comment :slug-and-id slug-and-id)
         (let ((children (comments article)))
           (when children
             (do-child-comments "-1" children)))
         (<:input :class "td-input parent"
                 :type "hidden"
                 :name "parent")
         (<:p :class "c-reply"
              (<:a :id "-1" :href "" "Add a comment") ; XXX: translate
             (<:table :id "c-table"
                     (tr-td-input "name *")
                     (tr-td-input "email *")
                     (tr-td-input "url")
                     (tr-td-text "comment *")
                     (tr-td-input "submit" :value "Submit" :typeof "submit"))))) ; XXX: translate

(defun article-body-markup (article)
  (let ((photo (photo article)))
    (when photo
      (let* ((photo-direction (photo-direction article))
             (pd (cond ((eql :l photo-direction) "left")
                       ((eql :r photo-direction) "right")
                       ((eql :b photo-direction) "block")))
             (a-photo-pd (join-string-list-with-delim " "
                                                      (list "a-photo"
                                                            pd))))
        (<:div :class a-photo-pd
              (article-lead-photo-url photo pd)
              (let ((attr (attribution photo)))
                (unless (nil-or-empty attr)
                  (<:a :class "p-attribution small" :href attr "photo attribution")))
              (<:p :class "p-title" (title photo))))))
  (<:div :id "a-body" (body article)))

(defun article-related-markup (id article)
  (<:div :id "related"
        (<:span :class "hidden" id)
        (let ((related-length (get-config "pagination.article.related"))
              (cat (cat article))
              (subcat (subcat article))
              (author (author article))
              (cat-subcat-list (get-related-articles "cat-subcat" article))
              (author-list (get-related-articles "author" article)))
          (article-carousel-container "Articles in the same Category / Subcategory:- "
                                      (<:span (<:a :href (h-genurl 'r-cat
                                                                 :cat (slug cat))
                                                 (name cat))
                                             " / "
                                             (<:a :href (h-genurl 'r-cat-subcat
                                                                 :cat (slug cat)
                                                                 :subcat (slug subcat))
                                                 (name subcat)))
                                      cat-subcat-list
                                      (h-genurl 'r-ajax-article-related
                                                :id id
                                                :typeof "cat-subcat"
                                                :page 0))
          (article-carousel-container "Articles authored by:- "
                                      (<:span (<:a :href (h-genurl 'r-author
                                                                 :author (handle author))
                                                 (alias author)))
                                      author-list
                                      (h-genurl 'r-ajax-article-related
                                                :id id
                                                :typeof "author"
                                                :page 0)))))

(defun fe-article-tags-markup (tags)
  (join-string-list-with-delim ", "
                               (dolist (tag tags)
                                 (<:a :href (h-genurl 'r-tag :tag (slug tag))
                                     (name tag)))))

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
         (article (get-article-by-id id)))
    (if (and article
             (or editorial
                 (eql :a (status article))))
        (template
         :title (title article)
         :js nil
         :tags (append (loop for tag in (tags article)
                          collect (name tag))
                       (list (name (cat article))
                             (name (subcat article))))
         :description (summary article)
         :body (<:div
                (<:div :id "article"
                      (article-preamble-markup article)
                      (article-body-markup article)
                      #- (and)
                      (article-comments-markup article slug-and-id))
                (article-related-markup id article)))
        (v-404))))

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
        (email (post-parameter "email"))
        (url (post-parameter "url"))
        (body (post-parameter "comment")))
    (add-article-comment (get-article-by-id (get-id-from-slug-and-id slug-and-id))
                         parent
                         (make-instance 'comment
                                        :body body
                                        :date (get-universal-time)
                                        :status :a
                                        :username name
                                        :useremail email
                                        :userurl url
                                        :userip (remote-addr *request*)
                                        :useragent (user-agent)))
    (redirect (h-genurl 'r-article :slug-and-id slug-and-id))))
