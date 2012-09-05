(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; helper functions and macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-cat-subcat-markup (article list cat-subcat)
  (with-html
    (let ((i 0))
      (dolist (l list)
        (incf i)
        (if (or (and (not article) (= i 1))
                (and article (= (id l) (id (if (eql :c cat-subcat)
                                          (cat article)
                                          (subcat article))))))
            (htm (:option :selected "selected" :value (id l) (str (name l))))
            (htm (:option :value (id l) (str (name l)))))))))

(defmacro get-photo-direction-markup (dir direction)
  `(with-html
     (if (and article
              (eql ,dir (photo-direction article)))
         (htm (:option :selected "selected" :value ,direction (str ,(string-capitalize `,direction))))
         (htm (:option :value ,direction (str ,(string-capitalize `,direction)))))))

(defun get-tags-markup (article)
  (let ((rslt nil))
    (dolist (tag (tags article))
      (push (name tag) rslt))
    (join-string-list-with-delim ", " rslt)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; views
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-article-get (&optional id)
  (ed-page-template "Add Article"
      t
      (htm (:script :type "text/javascript"
                    (format t
                            "~%//<![CDATA[~%var categoryTree = ~a;~%~a~%//]]>~%"
                            (get-category-tree-json)
                            (on-load))))
    (let* ((article (when id (get-article-by-id id)))
           (cats (get-root-categorys))
           (subcats (get-subcategorys (if article
                                          (id (cat article))
                                          1))))
      (htm (:form :action (if article
                              (genurl 'r-article-edit-post :id id)
                              (genurl 'r-article-new-post))
                  :method "POST"
                  (:table (str (tr-td-input "title" :value (when article (title article))))
                          (str (tr-td-text "summary" :value (when article (summary article))))
                          (str (tr-td-text "body" :value (when article (body article))))
                          (:tr (:td "Category")
                               (:td (:select :name "cat"
                                             :class "td-input cat"
                                             (str (get-cat-subcat-markup article cats :c)))))
                          (:tr (:td "Sub Category")
                               (:td (:select :name "subcat"
                                             :class "td-input subcat"
                                             (str (get-cat-subcat-markup article subcats :s)))))
                          (:tr (:td "Lead Photo")
                               (:td (:input :class "td-input"
                                            :type "hidden"
                                            :name "lead-photo"
                                            :id "lead-photo")
                                    (:span (when article
                                             (str (article-lead-photo-url (photo article) "related-thumb"))))
                                    (:a :id "select-photo"
                                        :href ""
                                        "Select")
                                    " or "
                                    (:a :id "upload-photo"
                                        :href ""
                                        "Upload")
                                    " a photo"))
                          (:tr (:td "Lead Photo Placement")
                               (:td (:select :id "pd"
                                             :name "pd"
                                             :class "td-input"
                                             (str (get-photo-direction-markup :b "center"))
                                             (str (get-photo-direction-markup :l "left"))
                                             (str (get-photo-direction-markup :r "right")))))
                          (str (tr-td-input "tags" :value (when article (get-tags-markup article)))))
                  (:input :id "save"
                          :name "save"
                          :type "submit"
                          :value "Save"))))))

(defun v-article-post (&optional id)
  (declare (ignore id))
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
                                :cat (get-category-by-id cat)
                                :subcat (get-category-by-id subcat)
                                :photo (when photo (get-mini-photo (get-photo-by-id photo)))
                                :photo-direction (cond ((string-equal pd "center") :b)
                                                       ((string-equal pd "left") :l)
                                                       ((string-equal pd "right") :r))
                                :tags article-tags))
    (redirect (genurl 'r-article-new-get))))
