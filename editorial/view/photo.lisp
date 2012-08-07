(in-package :hawksbill.golbin.editorial)

(defun v-photo-get (&optional message)
  (ed-page-template "Add Photo"
    (when message (htm (:div :class "error" (str message))))
    (htm (:form :action (genurl 'r-photo-post)
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
                        (str (tr-td-input "tags"))
                        (str (tr-td-input "photo" :typeof "file")))
                (:input :id "upload"
                        :name "upload"
                        :type "submit"
                        :value "Upload")))))

(defun v-photo-post ()
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
    (redirect (genurl 'r-photo-get))))

;; return a json-encoded list of <img src="" alt="[title]">
(defun v-photos-get (who start)
  (let ((photos-per-page (get-config "pagination.article.editorial.lead-photo-select-pane")))
    (encode-json-to-string
     (loop for photo in (paginate (conditionally-accumulate #'(lambda (photo)
                                                                (eq (typeof photo) :a))
                                                            (if (string-equal who "me")
                                                                (get-photos-by-author (who-am-i))
                                                                (get-all-photos)))
                                  (* start photos-per-page)
                                  photos-per-page)
        collect ((lambda (p) (article-lead-photo-url p "related-thumb")) photo)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; required for tmp-init
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-tmp-photo-get (&optional message)
  (ed-page-template "Add Photo"
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
