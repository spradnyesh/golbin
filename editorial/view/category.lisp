(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; views
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-cat-get ()
  (with-ed-login
    (template
     :title "Edit Cat/Subcat"
     :js (<:script :type "text/javascript"
                  (on-load))
     :body (<:form :action (h-genurl 'r-cat-post)
                  :method "POST"
                  (<:ol :id "sort-catsubcat"
                       (dolist (cats (get-category-tree))
                         (<:li (<:div :class "cat" (name (first cats)))
                              (<:ol (dolist (subcat (second cats))
                                     (<:li (<:div :class "subcat" (name subcat))))))))))))

(defun v-cat-post ())
