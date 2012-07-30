(in-package :hawksbill.golbin)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro dolist-li-a (list class route value-fn &rest route-params)
  `(with-html
     (dolist (l ,list)
       (htm
        (:li :class ,class
             (:a :href ,(if route-params
                            `(genurl ,route ,@route-params)
                            `(genurl ,route))
                 (str (,value-fn l))))))))

(defmacro view-index (title articles-list route &rest route-params)
  `(let* ((pagination-limit (get-config "pagination.article.limit"))
          (offset (* page pagination-limit)))
     (fe-page-template
         ,title
       (htm
        (:div :id "articles"
              (:ul
               (dolist (article (paginate ,articles-list
                                          offset
                                          pagination-limit))
                 (htm
                  (:li
                   (when (photo article)
                     (htm (:div :class "index-thumb"
                                (str (article-lead-photo-url (photo article) "index-thumb")))))
                   (:h3 (:a :class "a-title"
                            :href (genurl 'fe-r-article
                                          :slug-and-id (format nil "~A-~A"
                                                               (slug article)
                                                               (id article)))
                            (str (title article))))
                   (:cite :class "a-cite" (str (format nil
                                                       "~a, ~a - ~a"
                                                       (name (cat article))
                                                       (name (subcat article)) (date article))))
                   (:p :class "a-summary" (str (summary article))))))))
        (str ,(if route-params
                  `(pagination-markup ,route
                                      page
                                      (length ,articles-list)
                                      pagination-limit
                                      ,@route-params)
                  `(pagination-markup ,route
                                      page
                                      (length ,articles-list)
                                      pagination-limit)))))))

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
(defun fe-nav-categories-markup ()
  (with-html
    (dolist (cat (get-root-categorys))
      (htm
       (:li :class "cat"
        (:a :href (genurl 'fe-r-cat
                          :cat (slug cat))
            (str (name cat)))
        (:ul
         (dolist (subcat (get-subcategorys (id cat)))
           (htm
            (:li :class "subcat"
                 (:a :href (genurl 'fe-r-cat-subcat :cat (slug cat) :subcat (slug subcat))
                     (str (name subcat))))))))))))

(defun fe-nav-tags-markup ()
  (with-html
    (dolist-li-a (get-all-tags) "tag" 'fe-r-tag name :tag (slug l))))

(defun fe-nav-authors-markup ()
  (with-html
    (dolist-li-a (get-all-authors) "author" 'fe-r-author name :author (handle l))))

(defun fe-get-article-tags-markup (article)
  (with-html
    (dolist (tag (tags article))
      (htm " "
       (:a :href (genurl 'fe-r-tag :tag (slug tag))
           (str (name tag)))))))

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