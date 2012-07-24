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

(defmacro view-index (title popular-markup articles-list route &rest route-params)
  `(let* ((offset (* page *article-pagination-limit*)))
     (fe-page-template
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
                       *article-pagination-limit*
                     ,@route-params)
                  `(pagination-markup ,route
                       page
                       (length ,articles-list)
                       *article-pagination-limit*)))))))


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

(defun get-article-lead-photo-url (photo photo-direction)
  (let* ((pd (cond ((eql :l photo-direction) "left")
				   ((eql :r photo-direction) "right")
				   ((eql :b photo-direction) "block")))
		 (photo-size-config-name (format nil "photo.article-lead.~a" pd))
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
	(with-html (:div :class pd
					 (:img :src (format nil
										"/static/photos/~a_~a.~a"
										(first name-extn)
										photo-size
										(second name-extn))
						   :alt (title photo))
					 (:p (str (title photo)))))))

(defun fe-latest-articles-markup (&key (offset 0) (category (most-popular-categories)))
  (declare (ignore offset))
  (latest-articles category))

(defun fe-most-popular-articles-markup (&key (offset 0) (category (most-popular-categories)))
  (declare (ignore offset))
  (most-popular-articles category))
