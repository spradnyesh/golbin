(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro nav- (list class route-name route-param field)
  `(with-html
     (dolist (l ,list)
       (htm
        (:li :class ,class
             (:a :href (genurl ',route-name
                               ,route-param (,field l))
                 (str (name l))))))))

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
    (dolist (cat-node (get-category-tree *category-storage*))
      (let* ((cat (first cat-node))
             (subcat-node (second cat-node)))
        (htm
         (:li
          (:a :href (genurl 'route-cat
                            :cat (slug cat))
              (str (name cat)))
          (:ul
           (dolist (subcat subcat-node)
             (htm
              (:li
               (:a :href (genurl 'route-cat-subcat
                                 :cat (slug cat)
                                 :subcat (slug subcat))
                   (str (name subcat)))))))))))))

(defmacro dolist-li-a (list route value-fn &rest route-params)
  `(with-html
     (dolist (l ,list)
       (htm
        (:li
         (:a :href ,(if route-params
                        `(genurl ,route ,@route-params)
                        `(genurl ,route))

             (str (,value-fn l))))))))
(defun nav-tags-markup ()
  (dolist-li-a (get-all-tags *tag-storage*) 'route-tag name :tag (slug l)))

(defun nav-authors-markup ()
  (dolist-li-a (get-all-authors *author-storage*) 'route-author name :author (handle l)))

(defun nav-tags ()
  (nav- (get-all-tags *tag-storage*) "tag" route-tag :tag slug))

(defun nav-authors ()
  (nav- (get-all-authors *author-storage*) "author" route-author :author handle))

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
