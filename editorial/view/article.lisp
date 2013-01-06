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

(defun make-photo-attribution-div (img-tag photo)
  (with-html (:div :class "a-photo"
                   (str img-tag)
                   (let ((attr (attribution photo)))
                     (unless (nil-or-empty attr)
                       (htm (:a :class "p-attribution small"
                                :href attr "photo attribution"))))
                   (:p :class "p-title" (str (title photo))))))

(defun add-photo-attribution (body)
  (dolist (img-tag (all-matches-as-strings "<img (.*?)\/>" body))
    (let ((photo-div (make-photo-attribution-div img-tag (find-photo-by-img-tag img-tag))))
      (setf body (regex-replace img-tag body photo-div))))
  body)

(defun validate (data)
  (let ((err0r nil))
    (let ((matches (all-matches-as-strings "<img(.*?)src=\\\"(?!\/static\/photos\/)(.*?)\/>"
                                           (cdr (assoc :body data)))))
      (when matches
        (push (cons :non-golbin-images matches) err0r)))
    err0r))

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
        (htm (:div :id "article"
                   (:form :action (if article
                                      (h-genurl 'r-article-edit-post :id id)
                                      (h-genurl 'r-article-new-post))
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
                                  (unless (string-equal (get-dimension-value "lang") "en-IN")
                                    (htm (:tr (:td (str (get-dimension-value "lang")))
                                              (:td "Click " ; XXX: translate
                                                   (:a :href "http://www.google.co.in/transliterate"
                                                       :target "_blank"
                                                       "here")
                                                   " to use Google Transliterate or "
                                                   (:a :href "http://www.google.com/inputtools/windows/index.html"
                                                       :target "_blank"
                                                       "here")
                                                   " to download Google Transliterate software on your PC."))))
                                  (:tr (:td "Category")
                                       (:td (:select :name "cat"
                                                     :class "td-input cat"
                                                     (str (get-cat-subcat-markup article cats :c)))))
                                  (:tr (:td "Sub Category")
                                       (:td (:select :name "subcat"
                                                     :class "td-input subcat"
                                                     (str (get-cat-subcat-markup article subcats :s)))))
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
                                         (htm (:td (:a :href (h-genurl 'r-article
                                                                       :slug-and-id (format nil
                                                                                            "~a-~a"
                                                                                            (slug article)
                                                                                            id))
                                                       "Preview") (:sup "#2"))))))
                          (when article
                            (htm (:div :class "notes"
                                       (:p "#1: On saving the article will go into the draft mode and will have to be approved before it will be visible on the site again.")
                                       (:p "#2: You can only preview after the article has been saved successfully.")))))))))))

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
                                                           :date (prettyprint-datetime)
                                                           :cat cat
                                                           :subcat subcat
                                                           :photo photo
                                                           :photo-direction pd
                                                           :tags article-tags)))))
              (if ajax
                  ;; need to remove the '\\' that encode-json-to-string adds before every '/'
                  (regex-replace-all "\\\\"
                                     (encode-json-to-string
                                      `((:status . "success")
                                        (:data . ,(h-genurl 'r-article-edit-get :id (write-to-string id)))))
                                     "")

                  (redirect (h-genurl 'r-article-edit-get :id (write-to-string id)))))
            ;; validation failed
            (if ajax
                ;; need to remove the '\\' that encode-json-to-string adds before every '/'
                (regex-replace-all "\\\\"
                                   (encode-json-to-string
                                    `((:status . "failure")
                                      (:errors . ,err0r)))
                                   "")
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
