(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun photo-get-markup (&optional (ajax nil))
  (let ((cats (get-root-categorys))
        (subcats (get-subcategorys 1)))
    (with-html
      (:form :action (if ajax
                         (genurl 'r-ajax-photo-post)
                         (genurl 'r-photo-post))
             :method "POST"
             :enctype "multipart/form-data"
             (:table (str (tr-td-input "title"))
                     (:tr
                      (:td "Type of")
                      (:td (:select :name "typeof"
                                    :class "td-input"
                                    (:option :value "article" "Article")
                                    (:option :value "author" "Author")
                                    #|(:option :value "slideshow" "Slideshow")|#))) ; TODO
                     (:tr (:td "Category")
                          (:td (:select :name "cat"
                                        :class "td-input cat"
                                        (:option :selected "selected"
                                                 :value (id (first cats)) (str (name (first cats))))
                                        (dolist (cat (rest cats))
                                          (htm (:option :value (id cat) (str (name cat))))))))
                     (:tr (:td "Sub Category")
                          (:td (:select :name "subcat"
                                        :class "td-input subcat"
                                        (:option :selected "selected"
                                                 :value (id (first subcats)) (str (name (first subcats))))
                                        (dolist (subcat (rest subcats))
                                          (htm (:option :value (id subcat) (str (name subcat))))))))
                     (str (tr-td-input "tags"))
                     (str (tr-td-input "photo" :typeof "file")))
             (:input :id "upload"
                     :name "upload"
                     :type "submit"
                     :value "Upload")))))

(defun normalize-photo-tags (tags)
  (remove-duplicates (remove nil tags)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; views
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-photo-get (&optional message)
  (ed-page-template "Add Photo"
      t
      (htm (:script :type "text/javascript"
                    (format t
                            "~%//<![CDATA[~%var categoryTree = ~a;~%~a~%//]]>~%"
                            (get-category-tree-json)
                            (on-load))))
    (when message (htm (:div :class "error" (str message))))
    (str (photo-get-markup))))

(defun v-photo-post (&optional (ajax nil))
  (let ((title (post-parameter "title"))
        (cat (post-parameter "cat"))
        (subcat (post-parameter "subcat"))
        (tags (split-sequence "," (post-parameter "tags") :test #'string-equal))
        (photo-tags nil)
        (typeof (post-parameter "typeof"))
        (photo (post-parameter "photo")))
    (when (and photo (listp photo))
      (multiple-value-bind (orig-filename new-path) (save-photo-to-disk photo)
        (when new-path
          (dolist (tag tags)
            (push (add-tag tag) photo-tags))
          (setf photo (add-photo (make-instance 'photo
                                                :title title
                                                :typeof (cond ((string-equal typeof "article") :a)
                                                              ((string-equal typeof "author") :u)
                                                              ((string-equal typeof "slideshow") :s))
                                                :orig-filename orig-filename
                                                :new-filename (format nil
                                                                      "~A.~A"
                                                                      (pathname-name new-path)
                                                                      (pathname-type new-path))
                                                :cat (get-category-by-id (when cat (parse-integer cat)))
                                                :subcat (get-category-by-id (when subcat (parse-integer subcat)))
                                                :tags (normalize-photo-tags photo-tags))))
          (if ajax
              ;; need to remove the '\\' that encode-json-to-string adds before every '/' in the photo path :(
              (regex-replace-all
               "\\\\"
               (encode-json-to-string
                `((:status . "success")
                  (:data . ,(list (id photo) (article-lead-photo-url photo "related-thumb")))))
               "")
              (redirect (genurl 'r-photo-get))))))))

;; return a json-encoded list of [<id>, <img src="" alt="[title]">]
(defun v-ajax-photos-select (who start)
  (let* ((cat (parse-integer (get-parameter "cat")))
         (subcat (parse-integer (get-parameter "subcat")))
         (tags (get-parameter "tags"))
         (photos-per-page (get-config "pagination.article.editorial.lead-photo-select-pane"))
         (list (paginate (conditionally-accumulate
                          #'(lambda (photo)
                              (and (eq (typeof photo) :a)
                                   (if (/= cat 0)
                                       (= cat (id (cat photo)))
                                       t)
                                   (if (/= subcat 0)
                                       (= subcat (id (subcat photo)))
                                       t)
                                   (if tags
                                       (when (subset (split-string-by-delim tags ",")
                                                     (mapcar #'slug (tags photo)))
                                         t)
                                       t)))
                          (if (string-equal who "me")
                              (get-photos-by-author (who-am-i))
                              (get-all-photos)))
                         (* (parse-integer start) photos-per-page)
                         photos-per-page)))
    (if list
        (regex-replace-all              ; need to remove the '\\' that
         "\\\\" ; encode-json-to-string adds before every '/' in the photo path :(
         (encode-json-to-string
          `((:status . "success")
            (:data . ,(loop for
                         photo in list
                         collect (list (id photo) ((lambda (p)
                                                     (article-lead-photo-url p "related-thumb"))
                                                   photo))))))
         "")
        (encode-json-to-string
         `((:status . "failure")
           (:data . nil))))))

(defun v-ajax-photo-get ()
  (regex-replace-all                  ; need to remove the '\\' that
   "\\\\" ; encode-json-to-string adds before every '/' in the photo path :(
   (encode-json-to-string
    `((:status . "success")
      (:data . ,(photo-get-markup t))))
   ""))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; required for tmp-init
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-tmp-photo-get (&optional message)
  (ed-page-template "Add Photo"
      t
    (when message (htm (:div :class "error"
                             (str message))))
    (let ((count 10))
      (htm
       (:form :action (genurl 'r-tmp-photo-post)
              :method "POST"
              :enctype "multipart/form-data"
              (:table (:input :class "td-input"
                              :type "hidden"
                              :name "count"
                              :value count)
                      (:tr
                       (:td "Type of")
                       (:td (:select :name "typeof"
                                     :class "td-input"
                                     (:option :value "article" "Article")
                                     (:option :value "author" "Author")
                                     #|(:option :value "slideshow" "Slideshow")|#)))
                      (dotimes (i count)
                        (str (tr-td-input (format nil "photo-~a" i) :typeof "file"))))
              (:input :id "upload"
                      :name "upload"
                      :type "submit"
                      :value "Upload"))))))

(defun v-tmp-photo-post ()
  (let ((count (post-parameter "count"))
        (typeof (post-parameter "typeof")))
    (dotimes (i (parse-integer count))
      (let* ((photo (post-parameter (format nil "photo-~A" i)))
             (photo-tags nil))
        (when (and photo (listp photo))
          (multiple-value-bind (orig-filename new-path) (save-photo-to-disk photo)
            (when new-path
              (let ((tags (butlast (split-sequence "_"
                                                   orig-filename
                                                   :test #'string-equal))))
                (dolist (tag tags)
                  (push (add-tag tag) photo-tags))
                (add-photo (make-instance 'photo
                                          :title orig-filename
                                          :typeof (cond ((string-equal typeof "article") :a)
                                                        ((string-equal typeof "author") :u)
                                                        ((string-equal typeof "slideshow") :s))
                                          :orig-filename orig-filename
                                          :new-filename (format nil
                                                                "~A.~A"
                                                                (pathname-name new-path)
                                                                (pathname-type new-path))
                                          :tags photo-tags)))))))))
  (redirect (genurl 'r-tmp-photo-get)))
