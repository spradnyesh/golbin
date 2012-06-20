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

#|(defmacro li-a-rest (list route-name route-param-1 route-fn-1 value-fn &optional route-param-2 route-fn-2 rest)
  `(dolist (l ,list)
      (htm
       (:li
        (:a :href (genurl ,route-name
                          ,route-param-1 (,route-fn-1 l)
                          ,(when route-param-2
                                 `,route-param-2 `(,route-fn-2 l)))
            (str (,value-fn l)))
        ,@rest))))|#

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

(defun nav-tags-markup ()
  (with-html
    (dolist (tag (get-all-tags *tag-storage*))
      (htm
       (:li
        (:a :href (genurl 'route-tag
                          :tag (slug tag))
            (str (name tag))))))))

(defun nav-authors-markup ()
  (with-html
    (dolist (author (get-all-authors *author-storage*))
      (htm
       (:li
        (:a :href (genurl 'route-author
                          :author (handle author))
            (str (name author))))))))

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
