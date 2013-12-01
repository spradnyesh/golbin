(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro view-rss (title description link articles-list)
  `(rss2:rss :version "2.0"
             (rss2:channel (fmtnil
                            (rss2:title ,title)
                            (rss2:description ,description)
                            (rss2:link ,link)
                            (join-loop article
                                       ,articles-list
                                       (fmtnil (rss2:item (rss2:title (title article))
                                                          (rss2:description (summary article))
                                                          (rss2:link (h-genurl 'r-article
                                                                               :slug-and-id (get-slug-and-id article))))))))))

(defun v-rss-home ()
  (view-rss ""
            ""
            (h-genurl 'r-home)
            (get-active-articles)))

(defun v-rss-cat (cat-slug)
  (let ((cat (get-category-by-slug (string-to-utf-8 cat-slug :latin1)
                                   0)))
    (view-rss (name cat)
              ""
              (h-genurl 'r-cat-page :cat (slug cat))
              (get-articles-by-cat cat))))

(defun v-rss-cat-subcat (cat-slug subcat-slug)
  (let* ((cat (get-category-by-slug (string-to-utf-8 cat-slug :latin1)
                                    0))
         (subcat (when cat
                   (get-category-by-slug (string-to-utf-8 subcat-slug :latin1)
                                         (id cat)))))
    (view-rss (format nil "~a, ~a" (name cat) (name subcat))
              ""
              (h-genurl 'r-cat-subcat-page :cat (slug cat) :subcat (slug subcat))
              (get-articles-by-cat-subcat cat subcat))))

(defun v-rss-author (username)
  (let ((author (get-author-by-username (string-to-utf-8 username :latin1))))
    (view-rss (name author)
              ""
              (h-genurl 'r-author-page :author (username author))
              (get-articles-by-author author))))
