(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro view-rss (title description link articles-list)
  `(>:rss :version "2.0"
             (>:channel (fmtnil
                            (>:title ,title)
                            (>:description ,description)
                            (>:link ,link)
                            (join-loop article
                                       ,articles-list
                                       (fmtnil (>:item (>:title (title article))
                                                          (>:description (summary article))
                                                          (>:link (h-gen-full-url 'r-article
                                                                               :slug-and-id (get-slug-and-id article))))))))))

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
