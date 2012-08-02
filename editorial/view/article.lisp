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
                        (str (tr-td-input "lead-photo"))
                        (:tr (:td "Lead Photo Placement")
                             (:td (:select :id "pd"
                                           :name "pd"
                                           :class "td-input"
                                           (:option :value "center" "Center")
                                           (:option :value "left" "Left")
                                           (:option :value "right" "Right"))))
                        (str (tr-td-input "tags")))
                (:input :id "save"
                        :name "save"
                        :type "submit"
                        :value "Save")))))

(defun ed-v-article-post ()
  (let ((title (post-parameter "title"))
        (summary (post-parameter "summary"))
        (body (post-parameter "body"))
        (cat (post-parameter "cat"))
        (subcat (post-parameter "subcat"))
        (photo (post-parameter "photo"))
        (pd (post-parameter "pd"))
        (tags (split-sequence "," (post-parameter "tags") :test #'string-equal))
        (article-tags nil))
    (dolist (tag tags)
            (push (add-tag tag) article-tags))
    (add-article (make-instance 'article
                                :title title
                                :summary summary
                                :body body
                                :cat cat
                                :subcat subcat
                                :photo (when photo (get-mini-photo (get-photo-by-id photo)))
                                :photo-direction (cond ((string-equal pd "center") :b)
                                                       ((string-equal pd "left") :l)
                                                       ((string-equal pd "right") :r))
                                :tags article-tags))
    (redirect (genurl 'ed-r-article-get))))
