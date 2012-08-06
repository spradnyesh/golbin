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

(defmacro fe-intern (smbl)
  `(intern (string-upcase ,smbl) :hawksbill.golbin.frontend))

(defmacro nav-selected (cond if-str else-str &body body)
  `(if (and (nav-cat? route)
            ,cond)
       (progn
         ,@body
         (format nil ,if-str))
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
        (let ((article (get-article-by-id (parse-integer (first (split-sequence
                                                                 "-"
                                                                 (first (split-sequence
                                                                         "."
                                                                         uri
                                                                         :test #'string-equal))
                                                                 :from-end t
                                                                 :test #'string-equal
                                                                 :count 1))))))
          (list (slug (cat article)) (slug (subcat article)))))))