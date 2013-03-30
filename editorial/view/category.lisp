(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; views
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-cat-get ()
  (with-ed-login
    (template
     :title "Edit Cat/Subcat"
     :logged-in t
     :js (htm (:script :type "text/javascript"
                       (str (on-load))))
     :body (let ()
             (htm (:form :action (h-genurl 'r-cat-post)
                         :method "POST"
                         (:ol :id "sort-catsubcat"
                              (dolist (cats (get-category-tree))
                                (htm (:li (:div :class "cat" (str (name (first cats))))
                                          (:ol (dolist (subcat (second cats))
                                                 (htm (:li (:div :class "subcat" (str (name subcat)))))))))))))))))

(defun v-cat-post ())
