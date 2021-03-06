(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro article-preamble-markup-common (photo key)
  `(let ((username (username (author article)))
         (cat (cat article))
         (subcat (subcat article)))
     (translate ,key
                (<:a :id "a-author"
                     :href (h-genurl 'r-author
                                     :author username)
                     (if ,photo
                         (fmtnil ,photo
                                username)
                         username))
                (prettyprint-date timestamp)
                (prettyprint-time timestamp)
                (<:a :id "a-cat"
                     :href (h-genurl 'r-cat
                                     :cat (slug cat))
                     (name cat))
                (if (string= "--" (name subcat))
                    ""
                    (concatenate 'string
                                 " / "
                                 (<:a :id "a-cat-subcat"
                                      :href (h-genurl 'r-cat-subcat
                                                      :cat (slug cat)
                                                      :subcat (slug subcat))
                                      (name subcat)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun article-preamble-markup (article)
  (let ((timestamp (universal-to-timestamp (date article))))
    (fmtnil
     (<:h2 :id "a-title" (title article))
     (<:div :class "a-cite small"
             (article-preamble-markup-common (get-author-photo (author article)
                                                               (get-config "photo.author.article-logo"))
                                             "article-cite")))))

(defun article-body-markup (article)
  (fmtnil (let ((photo (photo article)))
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
          (<:div :id "a-body" (body article))))

(defun article-related-markup (article)
  (let ((related-length (get-config "pagination.article.related"))
        (id (id article))
        #- (and) ; XXX: uncomment this when we have sufficient related articles
        (progn
          (cat (cat article))
          (subcat (subcat article))
          (cat-subcat-list (get-related-articles "cat-subcat" article)))
        (author (author article))
        (author-list (get-related-articles "author" article)))
    (<:div :id "related"
           (<:span :class "hidden" id)
           (fmtnil
            #- (and) ; XXX: uncomment this when we have sufficient related articles
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
                                                                     :author (username author))
                                                     (username author)))
                                        author-list
                                        (h-genurl 'r-ajax-article-related
                                                  :id id
                                                  :typeof "author"
                                                  :page 0))))))

(defun fe-article-tags-markup (tags)
  (join-string-list-with-delim ", "
                               (loop for tag in tags
                                  collect (<:a :href (h-genurl 'r-tag :tag (slug tag))
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
             (or (and editorial
                      (not (eql :p (status article))))
                 (eql :a (status article))))
        (template
         :title (title article)
         :js (ps ($event (window load)
                   (let ((comments t))
                     ($apply $
                         get-script
                       "http://www.google.com/recaptcha/api/js/recaptcha_ajax.js"
                       #'(lambda (data text-status jqxhr)
                           ($apply -recaptcha
                               create
                             "6LekB-YSAAAAAC55se2xnWzfaPKvvN0cm8b46mgi" ; (get-config "cipher.fe.comments.public")
                             "recaptcha"
                             (create :theme "white"
                                     :callback "Recaptcha.focus_response_field"))))
                     ($apply $
                         get-script
                       "http://malsup.github.io/jquery.form.js"))))
         :tags (append (loop for tag in (tags article)
                          collect (name tag))
                       (list (name (cat article))
                             (name (subcat article))))
         :description (summary article)
         :body (let ((background (or (when (background article)
                                       (new-filename (background article)))
                                     (background (author article)))))
                 (fmtnil (when background (<:style (format nil
                                                           "#bkgrnd {background-image: url('/uploads/photos/~a')}"
                                                           background)))
                         (<:div :id "article"
                                (article-preamble-markup article)
                                (article-body-markup article)
                                (let ((tags (tags article)))
                                  (when tags
                                    (<:p :class "a-tags"
                                         (translate "tags" (fe-article-tags-markup tags))))))
                         (article-related-markup article)
                         (article-comments-markup id))))
        (v-404))))

(defun v-ajax-article-related (id typeof page)
  (let* ((related-length (get-config "pagination.article.related"))
         (list (splice (get-related-articles typeof (get-article-by-id id))
                       :from (* page related-length)
                       :to (1- (* (1+ page) related-length)))))
    (if list
        (encode-json-to-string
          `((:status . "success")
            (:data . ,(article-carousel-markup list))))
        (encode-json-to-string
         `((:status . "failure")
           (:data . nil))))))
