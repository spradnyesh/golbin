(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; helper functions and macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-cat-subcat-markup (article list cat-subcat)
  (loop
     for l in list
     for i from 1
     collecting (if (or (and (not article)
                             (= i 1))
                        (and article
                             (= (id l) (id (if (eql :c cat-subcat)
                                               (cat article)
                                               (subcat article))))))
                    (<:option :selected "selected" :value (id l) (name l))
                    (<:option :value (id l) (name l))) into a
     finally (return (apply #'concatenate 'string a))))

(defmacro get-photo-direction-markup (dir direction)
  `(if (and article
            (eql ,dir (photo-direction article)))
       (<:option :selected "selected" :value ,direction ,(string-capitalize `,direction))
       (<:option :value ,direction ,(string-capitalize `,direction))))

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

(defun make-photo-attribution-div (img-tag photo)
  (<:div :class "a-photo"
        img-tag
        (fmtnil
         (let ((attr (attribution photo)))
           (unless (nil-or-empty attr)
             (<:a :class "p-attribution small"
                  :href attr "photo attribution")))
         (<:p :class "p-title" (title photo)))))

(defun add-photo-attribution (body)
  (dolist (img-tag (all-matches-as-strings "<img (.*?)\/>" body))
    (let ((photo-div (make-photo-attribution-div img-tag (find-photo-by-img-tag img-tag))))
      (setf body (regex-replace img-tag body photo-div))))
  body)

(defun validate (data)
  (let ((err0r nil)
        (non-golbin-images (all-matches-as-strings "<img(.*?)src=\\\"(?!\/static\/photos\/)(.*?)\/>"
                                                   (cdr (assoc :body data)))))
    (when (or nil
              non-golbin-images)
      (setf err0r (make-hash-table))
      (setf (gethash 'non-golbin-images err0r) non-golbin-images))
    err0r))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; views
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-article-get (&optional id)
  (with-ed-login
    (template
     :title "Add Article"
     :logged-in t
     :js (fmtnil (<:script :type "text/javascript"
                           (format nil
                                   "~%//<![CDATA[~%var categoryTree = ~a, imageSizes = ~a;~%//]]>~%"
                                   (get-category-tree-json)
                                   (get-thumb-side-photo-sizes-json)))
                 (<:script :type "text/javascript"
                           :src "/static/ckeditor/ckeditor.js")
                 (<:script :type "text/javascript"
                           :src "/static/ckeditor/adapters/jquery.js")
                 (<:script :type "text/javascript"
                           (format nil "$('#body').ckeditor()")))
     #- (and)
     (if (string-equal "en-IN" (get-dimension-value "lang"))
         (progn (<:script :type "text/javascript"
                          :src "/static/ckeditor/ckeditor.js")
                (<:script :type "text/javascript"
                          :src "http://ilit.microsoft.com/bookmarklet/script/Hindi.js"
                          :defer "defer")))
     :body (let* ((article (when id (get-article-by-id id)))
                  (cats (get-root-categorys))
                  (subcats (get-subcategorys (if article
                                                 (id (cat article))
                                                 1)))
                  (photo (when article (photo article))))
             (<:div :id "article"
                    (<:form :action (if article
                                        (h-genurl 'r-article-edit-post :id id)
                                        (h-genurl 'r-article-new-post))
                            :method "POST"
                            (<:table (tr-td-input "title" :value (when article (title article)))
                                     (when article (<:tr
                                                    (<:td "URL")
                                                    (<:td (<:input :class "td-input url"
                                                                   :type "text"
                                                                   :disabled "disabled"
                                                                   :name "url"
                                                                   :value (slug article)))))
                                     (tr-td-text "summary" :value (when article (summary article)))
                                     (<:tr (<:td "Lead Photo")
                                           (<:td (<:input :class "td-input"
                                                          :type "hidden"
                                                          :name "lead-photo"
                                                          :id "lead-photo"
                                                          :value (when photo (id photo)))
                                                 (<:span (when photo
                                                           (article-lead-photo-url (photo article) "related-thumb")
                                                           (<:a :id "unselect-lead-photo"
                                                                :href ""
                                                                "Unselect photo. ")))
                                                 (<:a :id "select-lead-photo"
                                                      :href ""
                                                      "Select")
                                                 " or "
                                                 (<:a :id "upload-lead-photo"
                                                      :href ""
                                                      "Upload")
                                                 " a photo"))
                                     (<:tr (<:td "Lead Photo Placement")
                                           (<:td (<:select :id "pd"
                                                           :name "pd"
                                                           :class "td-input"
                                                           (get-photo-direction-markup :b "center")
                                                           (get-photo-direction-markup :l "left")
                                                           (get-photo-direction-markup :r "right"))))
                                     (<:tr (<:td "Non Lead Photos")
                                           (<:td (<:input :class "td-input"
                                                          :type "hidden"
                                                          :name "nonlead-photo"
                                                          :id "nonlead-photo"
                                                          :value (when photo (id photo)))
                                                 (<:span)
                                                 (<:a :id "select-nonlead-photo"
                                                      :href ""
                                                      "Select")
                                                 " or "
                                                 (<:a :id "upload-nonlead-photo"
                                                      :href ""
                                                      "Upload")
                                                 " a photo"))
                                     (tr-td-text "body"
                                                 :value (when article (body article)))
                                     #- (and)
                                     (if (string-equal "en-IN" (get-dimension-value "lang"))
                                         (tr-td-text "body"
                                                     :value (when article (body article))
                                                     :class "ckeditor")
                                         (progn (<:tr (<:td "Body")
                                                      (<:td (let ((trimmed-name "body")
                                                                  (value (when article (body article))))
                                                              (<:textarea :cols 40
                                                                          :rows 7
                                                                          :name (format nil "~A" trimmed-name)
                                                                          :id (format nil "~A" trimmed-name)
                                                                          value
                                                                          :MicrosoftILITWebAttach "true"))))
                                                (<:input :type "hidden"
                                                         :id "MicrosoftILITWebEmbedInfo"
                                                         :attachMode "optin"
                                                         :value "")
                                                (<:script :type "text/javascript"
                                                          :src "http://ilit.microsoft.com/bookmarklet/script/Hindi.js"
                                                          :defer "defer")))
                                     (unless (string-equal (get-dimension-value "lang") "en-IN")
                                       (<:tr (<:td (get-dimension-value "lang"))
                                             (<:td "Click " ; XXX: translate
                                                   (<:a :href "http://www.google.co.in/transliterate"
                                                        :target "_blank"
                                                        "here")
                                                   " to use Google Transliterate or "
                                                   (<:a :href "http://www.google.com/inputtools/windows/index.html"
                                                        :target "_blank"
                                                        "here")
                                                   " to download Google Transliterate software on your PC.")))
                                     (<:tr (<:td "Category")
                                           (<:td (<:select :name "cat"
                                                           :class "td-input cat"
                                                           (get-cat-subcat-markup article cats :c))))
                                     (<:tr (<:td "Sub Category")
                                           (<:td (<:select :name "subcat"
                                                           :class "td-input subcat"
                                                           (get-cat-subcat-markup article subcats :s))))
                                     (tr-td-input "tags" :value (when article (get-tags-markup article)))
                                     (<:tr (<:td "Status")
                                           (let ((status (get-article-status-markup article)))
                                             (<:td :class (string-downcase status) status)))
                                     (<:tr (<:td)
                                           (<:td (<:input :id "save"
                                                          :name "save"
                                                          :type "submit"
                                                          :value "Save")
                                                 (when article (<:sup "#1")))
                                           (when article
                                             (<:td (<:a :href (h-genurl 'r-article
                                                                        :slug-and-id (format nil
                                                                                             "~a-~a"
                                                                                             (slug article)
                                                                                             id))
                                                        "Preview") (<:sup "#2")))))
                            (when article
                              (<:div :class "notes"
                                     (<:p "#1: On saving the article will go into the draft mode and will have to be approved before it will be visible on the site again.")
                                     (<:p "#2: You can only preview after the article has been saved successfully.")))))))))

(defun v-article-post (&key (id nil) (ajax nil))
  (with-ed-login
    (let* ((title (post-parameter "title"))
           (summary (post-parameter "summary"))
           (body (post-parameter "body"))
           (p-cat (post-parameter "cat"))
           (cat (get-category-by-id (parse-integer p-cat)))
           (p-subcat (post-parameter "subcat"))
           (subcat p-subcat)
           (subcat (unless (nil-or-empty subcat) (get-category-by-id (parse-integer subcat))))
           (p-photo (post-parameter "lead-photo"))
           (photo p-photo)
           (photo (unless (nil-or-empty photo) (get-mini-photo (get-photo-by-id (parse-integer photo)))))
           (p-pd (post-parameter "pd"))
           (pd p-pd)
           (pd (cond ((string-equal pd "center") :b)
                     ((string-equal pd "left") :l)
                     ((string-equal pd "right") :r)))
           (p-tags (post-parameter "tags"))
           (tags p-tags)
           (tags (unless (nil-or-empty tags) (split-sequence "," tags :test #'string-equal)))
           (article-tags nil))
      (let ((err0r (validate (list (cons :body body)))))
        (if (not err0r)
            (let ((body (add-photo-attribution (cleanup-ckeditor-text (remove-all-style body)))))
              (dolist (tag tags)
                (let ((tag-added (add-tag tag)))
                  (when tag-added
                    (push tag-added article-tags))))
              (if id
                  (let ((article (get-article-by-id id)))
                    (edit-article (make-instance 'article
                                                 :id id
                                                 :title title
                                                 :slug (slug article)
                                                 :summary summary
                                                 :body body
                                                 :date (date article)
                                                 :status :r
                                                 :cat cat
                                                 :subcat subcat
                                                 :photo photo
                                                 :photo-direction pd
                                                 :tags article-tags)))
                  (setf id (id (add-article (make-instance 'article
                                                           :title title
                                                           :summary summary
                                                           :body body
                                                           :status :r
                                                           :date (get-universal-time)
                                                           :cat cat
                                                           :subcat subcat
                                                           :photo photo
                                                           :photo-direction pd
                                                           :tags article-tags)))))
              (if ajax
                  (encode-json-to-string `((:status . "success")
                                           (:data . ,(h-genurl 'r-article-edit-get :id (write-to-string id)))))
                  (redirect (h-genurl 'r-article-edit-get :id (write-to-string id)))))
            ;; validation failed
            (if ajax
                (encode-json-to-string `((:status . "error")
                                         (:errors . ,err0r)))
                ;; no-ajax => we lose all changes here
                (if id
                    (redirect (h-genurl 'r-article-edit-get :id (write-to-string id)))
                    (redirect (h-genurl 'r-article-new-get)))))))))

(defun v-article-delete-post (id)
  (with-ed-login
    (let ((article (get-article-by-id id)))
      (when article
        (setf (status article) :deleted)
        (edit-article article))
      (redirect (h-genurl 'r-home :page (parse-integer (post-parameter "page")))))))
