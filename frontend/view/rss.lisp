(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun prepend-lead-photo-to-body (photo body)
  (if photo
      (regex-replace "^"
                     body
                     (<:div :class "a-photo" (article-lead-photo-url photo "left")))
      body))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro view-rss (title description link articles-list)
  (let ((article-link (gensym))
        (article-datetime (gensym)))
    `(>:rss :version "2.0"
            (>:channel
             (fmtnil
              (>:title (concatenate 'string (get-config "site.name") " - " ,title))
              (>:description ,description)
              (>:link ,link)
              (>:image (>:url "http://www.golb.in/static/css/images/golbin.png")
                       (>:link ,link))
              (>:ttl 60)
              (join-loop article
                         ,articles-list
                         (progn
                           (setf ,article-link (h-gen-full-url 'r-article
                                                               :slug-and-id (get-slug-and-id article)))
                           (setf ,article-datetime (universal-to-timestamp (date article)))
                           (fmtnil (>:item (>:title (title article))
                                           (>:description (escape-for-html
                                                           (prepend-lead-photo-to-body (photo article)
                                                                                       (body article))))
                                           (>:link ,article-link)
                                           (>:guid ,article-link)
                                           #- (and)
                                           (>:pubDate (concatenate 'string
                                                                   (prettyprint-date ,article-datetime)
                                                                   " "
                                                                   (prettyprint-time ,article-datetime)))
                                           (>:category (name (cat article))))))))))))

(defun v-rss-home ()
  (view-rss ""
            ""
            (h-gen-full-url 'r-home)
            (get-active-articles)))

(defun v-rss-cat (cat-slug)
  (let ((cat (get-category-by-slug (string-to-utf-8 cat-slug :latin1)
                                   0)))
    (view-rss (name cat)
              ""
              (h-gen-full-url 'r-cat :cat (slug cat))
              (get-articles-by-cat cat))))

(defun v-rss-cat-subcat (cat-slug subcat-slug)
  (let* ((cat (get-category-by-slug (string-to-utf-8 cat-slug :latin1)
                                    0))
         (subcat (when cat
                   (get-category-by-slug (string-to-utf-8 subcat-slug :latin1)
                                         (id cat)))))
    (view-rss (format nil "~a, ~a" (name cat) (name subcat))
              ""
              (h-gen-full-url 'r-cat-subcat :cat (slug cat) :subcat (slug subcat))
              (get-articles-by-cat-subcat cat subcat))))

(defun v-rss-author (username)
  (let ((author (get-author-by-username (string-to-utf-8 username :latin1))))
    (view-rss (name author)
              ""
              (h-gen-full-url 'r-author :author (username author))
              (get-articles-by-author author))))
