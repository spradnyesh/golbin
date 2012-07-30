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
