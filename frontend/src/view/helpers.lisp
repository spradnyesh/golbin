(in-package :hawksbill.golbin.frontend)

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

(defmacro view-index (title popular-markup articles-list route &rest route-params)
  `(let* ((page (parse-integer page))
          (offset (* page *article-pagination-limit*)))
     (page-template
         ,title
         ,popular-markup
       (htm
        (:div :id "articles"
              (:ul
               (dolist (article (paginate ,articles-list
                                          :offset offset
                                          :limit *article-pagination-limit*))
                 (htm
                  (:li
                   (:h3 (:a :class "a-title"
                            :href (genurl 'route-article
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
                       *article-pagination-limit*
                     ,@route-params)
                  `(pagination-markup ,route
                       page
                       (length ,articles-list)
                       *article-pagination-limit*)))))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun nav-categories-markup ()
  (with-html
    (dolist (cat (get-active-categorys))
      (htm
       (:li :class "cat"
        (:a :href (genurl 'route-cat
                          :cat (slug cat))
            (str (name cat)))
        (:ul
         (dolist-li-a (get-active-subcategorys cat) "subcat" 'route-cat-subcat name :cat (slug cat) :subcat (slug l))))))))

(defun nav-tags-markup ()
  (with-html
    (dolist-li-a (get-all-tags) "tag" 'route-tag name :tag (slug l))))

(defun nav-authors-markup ()
  (with-html
    (dolist-li-a (get-all-authors) "author" 'route-author name :author (handle l))))

(defun get-article-tags-markup (article)
  (with-html
    (dolist (tag (tags article))
      (htm " "
       (:a :href (genurl 'route-tag :tag (slug tag))
           (str (name tag)))))))

(defun latest-articles-markup (&key (offset 0) (category (most-popular-categories)))
  (declare (ignore offset))
  (latest-articles category))

(defun most-popular-articles-markup (&key (offset 0) (category (most-popular-categories)))
  (declare (ignore offset))
  (most-popular-articles category))
