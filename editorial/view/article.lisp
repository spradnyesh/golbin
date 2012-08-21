(in-package :hawksbill.golbin.editorial)

(defun v-article-get (&optional message)
  (ed-page-template "Add Article"
      t
      (htm (:script :type "text/javascript"
                    (format t
                            "~%//<![CDATA[~%var categoryTree = ~a;~%~a~%//]]>~%"
                            (get-category-tree-json)
                            (on-load))))
      (when message (htm (:div :class "error" (str message))))
    (htm (:form :action (genurl 'r-article-post)
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
                        (:tr (:td "Lead Photo")
                             (:td (:input :class "td-input"
                                          :type "hidden"
                                          :name "lead-photo"
                                          :id "lead-photo")
                                  (:span)
                                  (:a :id "select-photo" :href "" "Select") " or " (:a :id "upload-photo" :href "" "Upload") " a photo"))
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

(defun v-article-post ()
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
    (redirect (genurl 'r-article-get))))
