(in-package :hawksbill.golbin)

(defun ed-v-article-get (&optional message)
  (ed-page-template "Add Article"
      (:script :type "text/javascript"
               (str (format nil
                            "~%//<![CDATA[~%var categoryTree = ~a;~%//]]>~%"
                            (get-category-tree-json)))
               (str (on-load)))
    (when message (htm (:div :class "error" (str message))))
    (htm (:form :action (genurl 'ed-r-article-post)
                :method "POST"
                (:table (str (tr-td-input "title"))
                        (str (tr-td-text "summary"))
                        (str (tr-td-text "body"))
                        (:tr (:td "Category")
                             (:td (:select :id "cat"
                                           :name "cat"
                                           :class "td-input"
                                           (dolist (cat (get-root-categorys))
                                             (htm (:option :value (id cat) (str (name cat))))))))
                        (:tr (:td "Sub Category")
                             (:td (:select :id "subcat"
                                           :name "subcat"
                                           :class "td-input"
                                           (dolist (subcat (get-subcategorys 1))
                                             (htm (:option :value (id subcat) (str (name subcat))))))))
                        (str (tr-td-input "tags")))
                (:input :id "save"
                        :name "save"
                        :type "submit"
                        :value "Save")))))

(defun ed-v-article-post ()
  (let ((title (post-parameter "title"))
        (tags (split-sequence "," (post-parameter "tags") :test #'string-equal))
        (photo-tags nil)
        (typeof (post-parameter "typeof"))
        (photo (post-parameter "photo")))
    (when (and photo (listp photo))
      (multiple-value-bind (orig-filename new-path) (save-photo-to-disk photo)
        (when new-path
          (dolist (tag tags)
            (push (add-tag tag) photo-tags))
          (add-photo (make-instance 'photo
                                    :title title
                                    :typeof (cond ((string-equal typeof "article") :a)
                                                  ((string-equal typeof "author") :u)
                                                  ((string-equal typeof "slideshow") :s))
                                    :orig-filename orig-filename
                                    :new-filename (format nil
                                                          "~A.~A"
                                                          (pathname-name new-path)
                                                          (pathname-type new-path))
                                    :tags photo-tags)))))
    (redirect (genurl 'ed-r-photo-get))))
