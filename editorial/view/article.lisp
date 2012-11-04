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

(defun get-article-status-markup (article)
  (if article
      (case (status article)
        (:r "Draft")
        (:e "Deleted")
        (:s "Submitted")
        (:a "Approved")
        (:w "Withdrawn")
        (otherwise "New"))
      "New"))

(defun get-tags-markup (article)
  (let ((rslt nil))
    (dolist (tag (tags article))
      (push (name tag) rslt))
    (join-string-list-with-delim ", " rslt)))

(defmacro can-article-be-deleted? ()
  `(or (eql :r status)
       (eql :s status)
       (eql :a status)))

(defun get-thumb-side-photo-sizes-json ()
  (encode-json-to-string
   (list (format nil
                 "~ax~a"
                 (get-config "photo.article-lead.related-thumb.max-height")
                 (get-config "photo.article-lead.related-thumb.max-width"))
         (format nil
                 "~ax~a"
                 (get-config "photo.article-lead.side.max-height")
                 (get-config "photo.article-lead.side.max-width")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; views
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-article-get (&optional id)
  (with-ed-login
    (ed-page-template "Add Article"
        t
        (htm (:script :type "text/javascript"
                      (format t
                              "~%//<![CDATA[~%var categoryTree = ~a, imageSizes = ~a;~%~a~%//]]>~%"
                              (get-category-tree-json)
                              (get-thumb-side-photo-sizes-json)
                              (on-load)))
             (:script :type "text/javascript"
                      :src "/static/ckeditor/ckeditor.js"))
      (let* ((article (when id (get-article-by-id id)))
             (cats (get-root-categorys))
             (subcats (get-subcategorys (if article
                                            (id (cat article))
                                            1)))
             (photo (when article (photo article))))
        (htm (:form :action (if article
                                (genurl 'r-article-edit-post :id id)
                                (genurl 'r-article-new-post))
                    :method "POST"
                    (:table (str (tr-td-input "title" :value (when article (title article))))
                            (when article (htm
                                           (:tr
                                            (:td "URL")
                                            (:td (:input :class "td-input url"
                                                         :type "text"
                                                         :disabled "disabled"
                                                         :name "url"
                                                         :value (slug article))))))
                            (str (tr-td-text "summary" :value (when article (summary article))))
                            (:tr (:td "Non Lead Photos")
                                 (:td (:input :class "td-input"
                                              :type "hidden"
                                              :name "nonlead-photo"
                                              :id "nonlead-photo"
                                              :value (when photo (id photo)))
                                      (:span)
                                      (:a :id "select-nonlead-photo"
                                          :href ""
                                          "Select")
                                      " or "
                                      (:a :id "upload-nonlead-photo"
                                          :href ""
                                          "Upload")
                                      " a photo"))
                            (str (tr-td-text "body" :value (when article (body article)) :class "ckeditor"))
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
                                              :id "lead-photo"
                                              :value (when photo (id photo)))
                                      (:span (when photo
                                               (str (article-lead-photo-url (photo article) "related-thumb"))
                                               (htm (:a :id "unselect-lead-photo"
                                                 :href ""
                                                 "Unselect photo. "))))
                                      (:a :id "select-lead-photo"
                                          :href ""
                                          "Select")
                                      " or "
                                      (:a :id "upload-lead-photo"
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
                            (str (tr-td-input "tags" :value (when article (get-tags-markup article))))
                            (:tr (:td "Status")
                                 (let ((status (get-article-status-markup article)))
                                   (htm (:td :class (string-downcase status) (str status)))))
                            (:tr (:td (:input :id "save"
                                              :name "save"
                                              :type "submit"
                                              :value "Save")
                                      (when article (htm (:sup "#1"))))
                                 (when article
                                   (htm (:td (:a :href (genurl 'r-article
                                                               :slug-and-id (format nil
                                                                                    "~a-~a"
                                                                                    (slug article)
                                                                                    id))
                                                 "Preview") (:sup "#2"))))))
                    (when article
                      (htm (:div :class "notes"
                                 (:p "#1: On saving the article will go into the draft mode and will have to be approved before it will be visible on the site again.")
                                 (:p "#2: You can only preview after the article has been saved successfully."))))))))))

(defun v-article-post (&optional id)
  (with-ed-login
    (let* ((title (post-parameter "title"))
           (summary (post-parameter "summary"))
           (body (post-parameter "body"))
           (cat (get-category-by-id (parse-integer (post-parameter "cat"))))
           (subcat (post-parameter "subcat"))
           (subcat (unless (nil-or-empty subcat) (get-category-by-id (parse-integer subcat))))
           (photo (post-parameter "lead-photo"))
           (photo (unless (nil-or-empty photo) (get-mini-photo (get-photo-by-id (parse-integer photo)))))
           (pd (post-parameter "pd"))
           (pd (cond ((string-equal pd "center") :b)
                     ((string-equal pd "left") :l)
                     ((string-equal pd "right") :r)))
           (tags (post-parameter "tags"))
           (tags (unless (nil-or-empty tags) (split-sequence "," tags :test #'string-equal)))
           (article-tags nil))
      (dolist (tag tags)
        (let ((tag-added (add-tag tag)))
          (when tag-added
            (push tag-added article-tags))))
      (if id
          (progn
            (edit-article (make-instance 'article
                                         :id id
                                         :title title
                                         :slug (slug (get-article-by-id id))
                                         :summary summary
                                         :body body
                                         :status :r
                                         :cat cat
                                         :subcat subcat
                                         :photo photo
                                         :photo-direction pd
                                         :tags article-tags))
            (redirect (genurl 'r-article-edit-get :id (write-to-string id))))
          (let ((article (add-article (make-instance 'article
                                                     :id nil
                                                     :title title
                                                     :summary summary
                                                     :body body
                                                     :cat cat
                                                     :subcat subcat
                                                     :photo photo
                                                     :photo-direction pd
                                                     :tags article-tags))))
            (redirect (genurl 'r-article-edit-get :id (write-to-string (id article)))))))))

(defun v-article-delete-post (id)
  (with-ed-login
    (let ((article (get-article-by-id id)))
      (when article
        (setf (status article) :deleted)
        (edit-article article))
      (redirect (genurl 'r-home :page (parse-integer (post-parameter "page")))))))
