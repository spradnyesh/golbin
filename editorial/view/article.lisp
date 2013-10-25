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
  (dolist (img (all-matches-as-strings "<img.*?/>" body))
    (unless (search "data-a=\"1\"" img :test #'string-equal)
      (setf body
            (regex-replace img
                           body
                           (make-photo-attribution-div (regex-replace "<img" img "<img data-a=\"1\"")
                                                       (find-photo-by-img-tag img))))))
  body)

(defun update-anchors (body)
  (dolist (anchor (all-matches-as-strings "<a .*?>" body))
    (unless (search "target=\"_blank\"" anchor :test #'string-equal)
      (setf body
            (regex-replace anchor
                           body
                           (regex-replace "<a " anchor "<a target=\"_blank\"")))))
  body)

(defun validate-article (title body)
  (let ((err0r nil)
        (non-golbin-images (all-matches-as-strings "<img(.*?)src=\\\"(?!\/static\/photos\/)(.*?)\/>"
                                                   body))
        (script-tags (all-matches-as-strings "<script(.*?)>"
                                             body)))
    (cannot-be-empty title "title" err0r)
    (cannot-be-empty body "body" err0r)
    (when non-golbin-images
      (push (translate "non-golbin-images" (join-string-list-with-delim "," non-golbin-images)) err0r))
    (when script-tags
      (push (translate "script-tags" (join-string-list-with-delim "," script-tags)) err0r))
    err0r))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; views
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-article-get (&optional id)
  (with-ed-login
    (template
     :title "Add Article"
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
                           (fmtnil "$('.ckeditor td textarea').ckeditor();"))
                 ;; http://ckeditor.com/forums/FCKeditor-2.x/Change-default-font-editor
                 (unless (string= "en-IN" lang)
                   (<:script :type "text/javascript" "
CKEDITOR.on('instanceReady', function(e) {
    e.editor.document.getBody().setStyle('font-family', 'Lohit Devanagari');
    e.editor.on('mode', function(a) {
        if (a.data.previousMode == 'source') {
            a.editor.document.getBody().setStyle('font-family', 'Lohit Devanagari');
        } else { // a.data.previousMode == 'wysiwyg'
            a.editor.textarea.setStyle('font-family', 'Lohit Devanagari');
        }
    });
});
")))
     :body (let* ((article (when id (get-article-by-id id)))
                  (cats (get-root-categorys))
                  (subcats (get-subcategorys (if article
                                                 (id (cat article))
                                                 1)))
                  (photo (when article (photo article))))
             (<:div :id "article"
                    :class "wrapper"
                    (<:form :action (if article
                                        (h-genurl 'r-article-edit-post :id id)
                                        (h-genurl 'r-article-new-post))
                            :method "POST"
                            (<:table (tr-td-input "title"
                                                  :value (when article (title article))
                                                  :mandatory t)
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
                                                           (fmtnil (article-lead-photo-url (photo article)
                                                                                           "related-thumb")
                                                                   (<:a :id "unselect-lead-photo"
                                                                        :href ""
                                                                        "Unselect photo. "))))
                                                 (<:span :class (if photo
                                                                    "hidden"
                                                                    "")
                                                         (translate "select-or-upload"
                                                                    (<:a :id "select-lead-photo"
                                                                         :href ""
                                                                         (translate "select"))
                                                                    (<:a :id "upload-lead-photo"
                                                                         :href ""
                                                                         (translate "upload"))))))
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
                                                 :class "ckeditor"
                                                 :value (when article (body article))
                                                 :mandatory t)
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
                                     (tr-td-input "ed-tags" :value (when article (get-tags-markup article)))
                                     (<:tr (<:td "Status")
                                           (let ((status (get-article-status-markup article)))
                                             (<:td status
                                                   " "
                                                   (unless (string-equal status "New")
                                                     (<:a :href (h-genurl 'r-article
                                                                          :slug-and-id (get-slug-and-id article))
                                                          :target "_blank"
                                                          (translate "preview"))))))
                                     (<:tr (<:td (<:a :class "submit"
                                                      :href "#"
                                                      (translate "save"))
                                                 (<:input :type "hidden"
                                                          :name "submit-type"
                                                          :value "submit")
                                                 (tooltip "to-view"))
                                           (<:td (<:input :class "submit"
                                                          :type "submit"
                                                          :name "submit"
                                                          :value (translate "submit"))
                                                 (tooltip "for-approval"))))))))))

(defun v-article-post (&key (id nil) (ajax nil))
  (with-ed-login
    (let* ((title (post-parameter "title"))
           (summary (post-parameter "summary"))
           (submit-type (post-parameter "submit-type"))
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
           (p-tags (post-parameter "ed-tags"))
           (tags p-tags)
           (tags (unless (nil-or-empty tags) (split-sequence "," tags :test #'string-equal)))
           (article-tags nil))
      (let ((err0r (validate-article title body)))
        (if (not err0r)
            (let ((body (update-anchors (add-photo-attribution (cleanup-ckeditor-text body)))))
              (dolist (tag tags)
                (let ((tag-added (add-tag tag)))
                  (when tag-added
                    (push tag-added article-tags))))
              (if id
                  ;; editing an existing article
                  (let* ((article (get-article-by-id id))
                         (parent (or (parent article)
                                     id)))
                    (setf id (get-new-article-id))
                    (add-article (make-instance 'article
                                                :id id
                                                :parent parent
                                                :title title
                                                :slug (slug article)
                                                :summary summary
                                                :body body
                                                :date (date article)
                                                :status (cond ((equal submit-type "submit") :s)
                                                              ((equal submit-type "save") :r))
                                                :cat cat
                                                :subcat subcat
                                                :photo photo
                                                :photo-direction pd
                                                :tags article-tags
                                                :author (author article))))
                  ;; adding a new article
                  (setf id (id (add-article (make-instance 'article
                                                           :id (get-new-article-id)
                                                           :title title
                                                           :slug (slugify title)
                                                           :summary summary
                                                           :body body
                                                           :status :r
                                                           :date (get-universal-time)
                                                           :status :r
                                                           :cat cat
                                                           :subcat subcat
                                                           :photo photo
                                                           :photo-direction pd
                                                           :tags article-tags
                                                           :author (get-mini-author))))))
              (sendmail :to (get-config "site.email.address")
                        :subject (translate "article-submitted-for-approval" id)
                        :body (translate "article-submitted-for-approval-body" id))
              (submit-success ajax
                              (h-genurl 'r-article-edit-get :id (write-to-string id))))
            ;; validation failed
            (submit-error ajax
                          err0r
                          (if id
                              (h-genurl 'r-article-edit-get :id (write-to-string id))
                              (h-genurl 'r-article-new-get))))))))

(defun v-article-delete-post (id &key (ajax nil))
  (with-ed-login
    (let ((article (get-article-by-id id))
          (delete (post-parameter "delete")))
      (when article
        (cond ((string-equal "d" delete)
               (setf (status article) :e))
              ((string-equal "u" delete)
               (setf (status article) :r)))
        (edit-article article))
      (submit-success ajax
                      (h-genurl 'r-home :page (parse-integer (post-parameter "page")))))))

(defun v-articles-approve-get ()
  (with-ed-login
    (template
     :title (translate "article-approval")
     :js nil
     :body (let ((articles-list (get-all-articles-for-approval)))
             (<:div :id "approve"
                    :class "wrapper"
                    (<:ul (join-loop article
                                     articles-list
                                     (<:li :class "crud"
                                           (<:form :method "POST"
                                                   :action (h-genurl 'r-approve-article-post :id (id article))
                                                   (<:input :name "approve"
                                                            :type "submit"
                                                            :value (translate "approve"))
                                                   (<:input :name "reject"
                                                            :type "submit"
                                                            :class "reject"
                                                            :value (translate "reject"))
                                                   (<:textarea :name "message"
                                                               :class "hidden")
                                                   (<:input :name "submit-type"
                                                            :type "text"
                                                            :class "hidden"
                                                            :value "approve"))
                                           (<:div :class "new"
                                                  (<:h3
                                                   (<:a :href (h-genurl 'r-article
                                                                        :slug-and-id (get-slug-and-id article))
                                                        (title article)))
                                                  (<:span :class "small"
                                                          (translate "new")))
                                           (let ((orig-article (get-article-by-id (parent article))))
                                             (when orig-article
                                               (<:div :class "orig"
                                                      (<:h3
                                                       (<:a :href (h-genurl 'r-article
                                                                            :slug-and-id (get-slug-and-id orig-article))
                                                            (title orig-article)))
                                                      (<:span :class "small"
                                                              (translate "original")))))))))))))

(defun v-article-approve-post (id &key (ajax nil))
  (with-ed-login
    (let* ((submit-type (post-parameter "submit-type"))
           (message (post-parameter "message"))
           (article (get-article-by-id id))
           (parent-id (parent article))
           (approver (who-am-i)))
      (if (= (id approver)
                   (id (author article)))
          (submit-error ajax (list (translate "cannot-approve-own-articles")) (h-genurl 'r-approve-articles))
          (when article
            ;; process all intemediate edits (including current)
            (dolist (l (get-intermediate-articles parent-id))
              (setf (status l) :p)
              (edit-article l))
            (cond ((string-equal submit-type "approve")
                   ;; process parent article (w/ content of current article)
                   (setf (status article) :a)
                   (setf (id article) parent-id)
                   (setf (parent article) nil)
                   (edit-article article)

                   (sendmail :to (email (get-author-by-id (id (author article))))
                             :cc (list (get-config "site.email.address") (email (get-author-by-id (id approver))))
                             :subject (translate "article-approved" id)
                             :body (translate "article-approved-body" id)))
                  ((string-equal submit-type "reject")
                   (let ((parent (get-article-by-id parent-id)))
                     ;; append approval-history to parent
                     (setf (approval-history parent)
                           (append (approval-history parent)
                                   (list (make-instance 'approval
                                                        :editor approver
                                                        :date (get-universal-time)
                                                        :message message))))
                     (edit-article parent)

                     ;; make current article status as "draft" (from submitted)
                     (setf (status article) :r)
                     (edit-article article)

                     ;; send notification email to author
                     (sendmail :to (email (get-author-by-id (id (author article))))
                               :cc (list (get-config "site.email.address") (email (get-author-by-id (id approver))))
                               :subject (translate "article-rejected" id)
                               :body (translate "article-rejected-body" id message))))
                  (t (submit-error ajax (list (translate "invalid-submission")) (h-genurl 'r-approve-articles))))
            (submit-success ajax (h-genurl 'r-approve-articles)))))))
