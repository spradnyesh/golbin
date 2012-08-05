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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun fe-nav-categories-markup ()
  (with-html
    (dolist (cat (get-root-categorys))
      (htm
       (:li :class "cat"
            (:h2 (:a :href (genurl 'r-cat
                                   :cat (slug cat))
                     (str (name cat))))
            (:ul
             (dolist (subcat (get-subcategorys (id cat)))
               (htm
                (:li :class "subcat"
                     (:h3 (:a :href (genurl 'r-cat-subcat :cat (slug cat) :subcat (slug subcat))
                              (str (name subcat)))))))))))))
