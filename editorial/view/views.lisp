(in-package :hawksbill.golbin)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; login
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ed-v-login-get ()
  (ed-page-template "Login"
    (:form :action (genurl 'ed-r-login)
           :method "POST"
           (str (label-input "name" "text"))
           (str (label-input "password" "text"))
           (:input :type "submit"
                   :name "submit"
                   :id "submit"
                   :value "Login"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; photo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ed-v-photo-get (&optional message)
  (ed-page-template "Add Photo"
    (when message (htm (:div :class "error"
                             (str message))))
    (htm
     (:form :action (genurl 'ed-r-photo-post)
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

(defun ed-v-photo-post ()
  (let ((title (post-parameter "title"))
        (tags (post-parameter "tags"))
        (typeof (post-parameter "typeof"))
        (photo (post-parameter "photo")))
    (when (and photo (listp photo))
      (multiple-value-bind (orig-filename new-path) (save-photo-to-disk photo)
        (when new-path
          (add-photo (make-instance 'photo
                                    :title title
                                    :typeof typeof
                                    :orig-filename orig-filename
                                    :path new-path
                                    :tags tags))
          #|(dolist (tag (split-sequence "," tags :test #'string-equal))
                    (add-tag tag))|#)))
    (redirect (genurl 'ed-r-photo-get))))
