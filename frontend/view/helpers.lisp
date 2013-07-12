(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro dolist-li-a (list class route value-fn &rest route-params)
  `(dolist (l ,list)
     (htm
      (<:li :class ,class
           (<:a :href ,(if route-params
                          `(h-genurl ,route ,@route-params)
                          `(h-genurl ,route))
               (,value-fn l))))))

(defmacro fe-intern (smbl)
  `(intern (string-upcase ,smbl) :hawksbill.golbin.frontend))

(defmacro nav-selected (cond then-str else-str &body body)
  `(if (and (nav-cat? route)
            ,cond)
       (progn
         ,@body
         (format nil ,then-str))
       (format nil ,else-str)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; should a cat/subcat be 'selected' in the primary/secondary navigation
;; only applicable for cat/subcat and article pages
(defun nav-cat? (route)
  (or (eq route (fe-intern :r-cat))
      (eq route (fe-intern :r-cat-page))
      (eq route (fe-intern :r-cat-subcat))
      (eq route (fe-intern :r-cat-subcat-page))
      (eq route (fe-intern :r-article))))

(defun get-nav-cat-subcat-slugs (uri)
  (let ((split (split-sequence "/" uri :test #'string-equal)))
    (if (string-equal (second split) "category")
        ;; cat/subcat page
        (list (third split) (fourth split))
        ;; article page
        (let ((article (get-article-by-id (get-id-from-slug-and-id (first (split-sequence "."
                                                                                          uri
                                                                                          :test #'string-equal))))))
          (when article (list (slug (cat article)) (slug (subcat article))))))))
