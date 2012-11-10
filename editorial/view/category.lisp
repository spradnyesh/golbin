(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; helper functions and macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; views
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-cat-get ()
  (with-ed-login
    (ed-page-template "Edit Cat/Subcat"
        t
        (htm (:script :type "text/javascript"
                      (str (on-load))))
      (let ()
        (htm (:form :action (genurl 'r-cat-post)
                    :method "POST"
                    (:ol :id "sort-catsubcat"
                         (dolist (cats (get-category-tree))
                           (htm (:li (:div :class "cat" (str (name (first cats))))
                                     (:ol (dolist (subcat (second cats))
                                            (htm (:li (:div :class "subcat" (str (name subcat)))))))))))))))))

(defun v-cat-post ())
