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
    (redirect (genurl 'ed-r-photo-get))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; required for tmp-init
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ed-v-tmp-photo-get (&optional message)
  (ed-page-template "Add Photo"
    (when message (htm (:div :class "error"
                             (str message))))
	(let ((count 10))
	  (htm
	   (:form :action (genurl 'ed-r-tmp-photo-post)
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

(defun ed-v-tmp-photo-post ()
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
										  :typeof typeof
										  :orig-filename orig-filename
										  :new-filename (format nil
																"~A.~A"
																(pathname-name new-path)
																(pathname-type new-path))
										  :tags photo-tags)))))))))
  (redirect (genurl 'ed-r-tmp-photo-get)))
