(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; helper functions and macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun inline-ads-markup ()
  (<:div :id "i-ads"
         (ads-markup (get-config "ads.client") "9310803587" 234 60)
         (ads-markup (get-config "ads.client") "1787536781" 234 60)))

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
        (:r (translate "draft"))
        (:e (translate "deleted"))
        (:s (translate "submitted"))
        (:a (translate "published"))
        (:w (translate "withdrawn"))
        (otherwise (translate "new")))
      (translate "new")))

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
                 "~a"
                 (get-config "photo.article-lead.related-thumb"))
         (format nil
                 "~a"
                 (get-config "photo.article-lead.block")))))

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
      (let ((photo (find-photo-by-img-tag img)))
        (when photo
          (setf body
                (regex-replace img
                               body
                               (make-photo-attribution-div (regex-replace "<img" img "<img data-a=\"1\"")
                                                           photo)))))))
  body)

(defun update-anchors (body)
  (dolist (anchor (all-matches-as-strings "<a .*?>" body))
    (unless (search "target=\"_blank\"" anchor :test #'string-equal)
      (setf body
            (regex-replace anchor
                           body
                           (regex-replace "<a " anchor "<a target=\"_blank\"")))))
  body)

;;; adding <p> tag at end so that if there is no </p> in article, then we will add inline g-ads at end of article
(defun add-trailing-p (body)
  (if (not (string= "<p class=\"last\">
	&nbsp;</p>
"                                    ; add only if not already present
                    (subseq body (- (length body) 29))))
      (concatenate 'string
                   body
                   "<p class='last'></p>")
      body))

(defun get-localtime (date hour min)
  (destructuring-bind (dd mm yyyy)
      (split-sequence "-" date :test #'string=)
    (encode-timestamp 0 0 (parse-integer min) (parse-integer hour) (parse-integer dd) (parse-integer mm) (parse-integer yyyy)
                      :offset 19800)))

(defun validate-article (title body date hour min)
  (let ((err0r nil)
        (script-tags (all-matches-as-strings "<script(.*?)>"
                                             body)))
    (cannot-be-empty title "title" err0r)
    (cannot-be-empty body "body" err0r)
    (if (or (and (is-null-or-empty date)
                 (or (not (is-null-or-empty hour))
                     (not (is-null-or-empty min))))
            (and (is-null-or-empty hour)
                 (or (not (is-null-or-empty date))
                     (not (is-null-or-empty min))))
            (and (is-null-or-empty min)
                 (or (not (is-null-or-empty date))
                     (not (is-null-or-empty hour)))))
        (push (translate "date-hour-empty-not-empty-error") err0r)
        (handler-case (when (and (not (is-null-or-empty date))
                                 (not (is-null-or-empty hour))
                                 (not (is-null-or-empty min))
                                 (< (timestamp-to-universal (get-localtime date hour min))
                                    (timestamp-to-universal (now))))
                        (push (translate "date-time-error") err0r))
          (sb-int:simple-parse-error () ; parse-integer
            (push (translate "invalid-date-time-error") err0r))
          (sb-int:simple-program-error () ; encode-timestamp
            (push (translate "invalid-date-time-error") err0r))
          (type-error () ; encode-timestamp
            (push (translate "invalid-date-time-error") err0r))
          (sb-kernel::arg-count-error () ; destructuring-bind
            (push (translate "invalid-date-time-error") err0r))))
    (when script-tags
      (push (translate "script-tags" (join-string-list-with-delim "," script-tags)) err0r))
    err0r))

;;; development helper
(defun republish-author-articles (author)
  (let ((ia-markup (inline-ads-markup)))
    (dolist (a (get-articles-by-author author))
      ;; remove and insert inline ads
      (setf (body a) (insert-inline-ads (remove-inline-ads (body a))
                                        ia-markup))
      (edit-article a))))

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
                 (ck-js lang)
                 (<:script :type "text/javascript"
                           :src "/static/js/jsDatePick.jquery.min.1.3.js"))
     :css (<:link :rel "stylesheet"
                          :type "text/css"
                          :href "/static/css/jsDatePick_ltr.min.css")
     :body (let* ((article (when id (get-article-by-id id)))
                  (cats (get-root-categorys))
                  (subcats (get-subcategorys (if article
                                                 (id (cat article))
                                                 1)))
                  (photo (when article (photo article)))
                  (background (when article (background article))))
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
                                     (<:tr (<:td (translate "background"))
                                           (<:td (<:input :class "td-input"
                                                          :type "hidden"
                                                          :name "background"
                                                          :id "background"
                                                          :value (when background (id background)))
                                                 (<:span (when background
                                                           (fmtnil (article-lead-photo-url (background article)
                                                                                           "related-thumb")
                                                                   (<:a :id "unselect-background"
                                                                        :href ""
                                                                        (translate "unselect-background")))))
                                                 (<:span :class (if background
                                                                    "hidden"
                                                                    "")
                                                         (translate "select-or-upload"
                                                                    (<:a :id "select-background"
                                                                         :href ""
                                                                         (translate "select"))
                                                                    (<:a :id "upload-background"
                                                                         :href ""
                                                                         (translate "upload"))))))
                                     (<:tr (<:td (translate "lead-photo"))
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
                                                 :value (when article (remove-inline-ads (body article)))
                                                 :mandatory t)
                                     (unless (string-equal (get-dimension-value "lang") "en-IN")
                                       (<:tr (<:td (get-dimension-value "lang"))
                                             (<:td "Click " ; XXX: translate
                                                   (<:a :href (get-config "helper.url.g-transliterate")
                                                        :target "_blank"
                                                        "here")
                                                   " to use Google Transliterate or "
                                                   (<:a :href (get-config "helper.url.g-inputtools")
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
                                     (tr-td-input "ed-tags"
                                                  :value (when article (get-tags-markup article))
                                                  :tooltip "comma-separated")
                                     (<:tr (<:td (translate "status"))
                                           (let ((status (get-article-status-markup article)))
                                             (<:td status
                                                   " "
                                                   (unless (string-equal status (translate "new"))
                                                     (<:a :href (h-genurl 'r-article
                                                                          :slug-and-id (get-slug-and-id article))
                                                          :target "_blank"
                                                          (translate "preview"))))))
                                     (when (or (not article)
                                               (eq :r (status article)))
                                       (<:tr (<:td (fmtnil (translate "publish-date-time")
                                                           (tooltip "publish-date-time-tooltip")))
                                             (<:td (<:input :class "td-input"
                                                            :type "text"
                                                            :name "date"
                                                            :id "a-date"
                                                            :value "")
                                                   (<:select :name "hour"
                                                             :class "td-input"
                                                             (fmtnil (<:option :selected "selected"
                                                                               :value "")
                                                                     (join-loop i (range 24)
                                                                                (fmtnil (<:option :value i i)))))
                                                   (<:select :name "min"
                                                             :class "td-input"
                                                             (fmtnil (<:option :selected "selected"
                                                                               :value "")
                                                                     (join-loop i (range 60)
                                                                                (fmtnil (<:option :value i i))))))))
                                     (when article
                                       (<:tr (<:td (translate "archive-url"))
                                             (<:td (let ((archive (archive article)))
                                                     (<:a :href (concatenate 'string
                                                                             (get-config "helper.url.webarchive")
                                                                             archive)
                                                          :target "_blank"
                                                          archive)))))
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
                                                          :value (translate "publish")))))))))))

(defun v-article-post (&key (id nil) (ajax nil))
  (with-ed-login
    (let* ((title (post-parameter "title"))
           (summary (post-parameter "summary"))
           (p-submit-type (post-parameter "submit-type"))
           (submit-type (cond ((string-equal p-submit-type "save") :r) ; draft/save
                              ((string-equal p-submit-type "submit") :a))) ; active/publish
           (body (post-parameter "body"))
           (p-cat (post-parameter "cat"))
           (cat (get-category-by-id (parse-integer p-cat)))
           (p-subcat (post-parameter "subcat"))
           (subcat (unless (nil-or-empty p-subcat) (get-category-by-id (parse-integer p-subcat))))
           (p-photo (post-parameter "lead-photo"))
           (photo (unless (nil-or-empty p-photo) (get-mini-photo (get-photo-by-id (parse-integer p-photo)))))
           (p-background (post-parameter "background"))
           (background (unless (nil-or-empty p-background)
                         (get-mini-photo (get-photo-by-id (parse-integer p-background)))))
           (p-pd (post-parameter "pd"))
           (pd (cond ((string-equal p-pd "center") :b)
                     ((string-equal p-pd "left") :l)
                     ((string-equal p-pd "right") :r)))
           (p-tags (post-parameter "ed-tags"))
           (tags (unless (nil-or-empty p-tags) (split-sequence "," p-tags :test #'string-equal)))
           (date (post-parameter "date"))
           (hour (post-parameter "hour"))
           (min (post-parameter "min"))
           (article-tags nil))
      (let ((err0r (validate-article title body date hour min)))
        (if (not err0r)
            (let ((body (add-trailing-p (update-anchors (add-photo-attribution (cleanup-ckeditor-text body)))))
                  (pub-date (when (and (not (is-null-or-empty date))
                                       (not (is-null-or-empty hour))
                                       (not (is-null-or-empty min)))
                              (timestamp-to-universal (get-localtime date hour min)))))

              ;; add new tags if needed
              (dolist (tag tags)
                (let ((tag-added (add-tag tag)))
                  (when tag-added
                    (push tag-added article-tags))))

              ;; support publishing in the future
              ;; (do this by saving article as "draft" (here)
              ;; and publish it later routes.ed-start-real)
              (when pub-date
                (setf submit-type :r))

              ;; add inline google-ads markup
              ;; (for existing articles (edit + publish),
              ;; inline ads markup was removed during v-article-get)
              (when (eq submit-type :a)
                (setf body (insert-inline-ads body (inline-ads-markup))))

              (if (not id)
                  ;; adding a new article

                  ;; # -- status(parent-status) -- action -- end-result -- remarks
                  ;; ========================================================
                  ;; 1 -- nil(nil) -- draft -- draft(nil) -- **new ID**
                  ;; 2 -- nil(nil) -- publish -- published(nil) -- **new ID**
                  (setf id (id (add-article (make-instance 'article
                                                           :id (get-new-article-id)
                                                           :title title
                                                           :slug (slugify title)
                                                           :summary summary
                                                           :body body
                                                           :date (get-universal-time)
                                                           :pub-date pub-date
                                                           :status submit-type
                                                           :cat cat
                                                           :subcat subcat
                                                           :photo photo
                                                           :photo-direction pd
                                                           :background background
                                                           :tags article-tags
                                                           :author (get-mini-author)))))
                  ;; editing an existing article
                  ;; # -- status(parent) -- action -- end-result    -- remarks
                  ;; =========================================================
                  ;; 1 -- draft(nil)     -- save   -- draft(nil)    -- no new ID
                  ;; 2 -- draft(nil)     -- submit -- active(nil)   -- no new ID
                  ;; =========================================================
                  ;; 3 -- active(nil)    -- save   -- draft(parent) -- **new ID**
                  ;; 4 -- active(nil)    -- submit -- active(nil)   -- no new ID
                  ;; =========================================================
                  ;; 5 -- draft(parent)  -- save   -- draft(parent) -- no new ID
                  ;; 6 -- draft(parent)  -- submit -- active(nil)   -- **delete new ID**
                  (let* ((article (get-article-by-id id))
                         (parent (parent article))
                         (status (status article)))
                    (cond ((or (and (eq status :r) (null parent) (eq submit-type :r)) ; 1
                               (and (eq status :r) (null parent) (eq submit-type :a)) ; 2
                               (and (eq status :a) (null parent) (eq submit-type :a)) ; 4
                               (and (eq status :r) parent (eq submit-type :r))) ; 5
                           (edit-article (make-instance 'article
                                                        :id id
                                                        :parent parent
                                                        :title title
                                                        :slug (slug article)
                                                        :summary summary
                                                        :body body
                                                        :date (date article)
                                                        :pub-date pub-date
                                                        :status submit-type
                                                        :cat cat
                                                        :subcat subcat
                                                        :photo photo
                                                        :photo-direction pd
                                                        :background background
                                                        :tags article-tags
                                                        :author (author article))))
                          ((and (eq status :a) (null parent) (eq submit-type :r)) ; 3
                           (setf id (id (add-article (make-instance 'article
                                                                    :id (get-new-article-id)
                                                                    :parent id
                                                                    :title title
                                                                    :slug (slug article)
                                                                    :summary summary
                                                                    :body body
                                                                    :date (date article)
                                                                    :pub-date pub-date
                                                                    :status submit-type
                                                                    :cat cat
                                                                    :subcat subcat
                                                                    :photo photo
                                                                    :photo-direction pd
                                                                    :background background
                                                                    :tags article-tags
                                                                    :author (author article))))))
                          ((and (eq status :r) parent (eq submit-type :a)) ; 6
                           (let ((parent-article (get-article-by-id parent)))
                             ;; edit and publish parent-article
                             (edit-article (make-instance 'article
                                                          :id parent
                                                          :parent nil
                                                          :title title
                                                          :slug (slug parent-article)
                                                          :summary summary
                                                          :body body
                                                          :date (date parent-article)
                                                          :pub-date pub-date
                                                          :status submit-type
                                                          :cat cat
                                                          :subcat subcat
                                                          :photo photo
                                                          :photo-direction pd
                                                          :background background
                                                          :tags article-tags
                                                          :author (author parent-article)))
                             ;; discard article
                             (edit-article (make-instance 'article
                                                          :id id
                                                          :status :p))
                             (setf id parent))))))

              ;; archive at http://archive.org/web/web.php
              (when (eq submit-type :a)
                (let* ((article (get-article-by-id id))
                       (uri (get-article-url article)))
                  (web-archive uri (lambda (uri)
                                     ;; update DB only when
                                     (when (and (null (archive article)) ; publishing 1st time
                                                uri) ; archival was successful
                                       (setf (archive article) uri)
                                       (edit-article article))))))
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

(defun article-future-publish ()
  (dolist (a (get-future-articles))
    (when (> (pub-date a)
             (timestamp-to-universal (now)))
      (edit-article (make-instance 'article
                                   :pub-date nil
                                   :status :a
                                   :id (id a)
                                   :parent (parent a)
                                   :title (title a)
                                   :slug (slug a)
                                   :summary (summary a)
                                   :body (body a)
                                   :date (date a)
                                   :cat (cat a)
                                   :subcat (subcat a)
                                   :photo (photo a)
                                   :photo-direction (photo-direction a)
                                   :background (background a)
                                   :tags (tags a)
                                   :author (author a))))))
