(in-package :hawksbill.golbin.frontend)

(defun head ())

(defun navigation ())

(defun foot ())

(defun ads-left ())

(defun ads-right ())

(defun latest-articles (offset)
  (declare (ignore offset)))

(defun most-popular-articles (offset)
  (declare (ignore offset)))

(defun view-home (&optional (page-number "0"))
  (let ((offset (* (parse-integer page-number) *article-pagination-limit*)))
	(with-html-output-to-string (out)
	  (:html
	   (:body
		(:div :class "hd"
			  (:div :class "banner"
					(:img :class "logo"
						  :source ""
						  :alt "logo")
					(:div :class "search"
						  (:form :method "GET"
								 :action "/search/"
								 (:input :type "input"
										 :name "q"
										 :value "Search")
								 (:input :type "submit"
										 :value "Submit"))))
			  (:div :class "trending-tags")
			  (:div :class "navigation"))
		(:div :class "bd"
			  (:div :class "articles"
					(:div :class "latest"
						  (:ul
						   (dolist (article (paginate (get-all-articles *article-storage*)
													  :offset offset))
							 (htm
							  (:li
							   (:a :class "a-title"
								   :href (restas:genurl 'route-article
														:title-and-id (format nil "~A-~A"
																			  (article-title article)
																			  (article-id article)))
								   (str (article-title article)))
							   (:p :class "a-date" (str (article-date article)))
							   (:p :class "a-summary" (str (article-summary article))))))))
					#|(:div :class "popular" (htm (most-popular-articles offset)))|#))
		(:div :class "ft"))))))

(defun view-cat (cat)
  (with-html-output-to-string (out)
    (:html
     (:body
	  (:ul
	   (dolist (article (paginate (get-articles-by-cat *article-storage* cat)))
		 (htm
		  (:li
		   (:p :class "a-title" (str (article-title article)))
		   (:p :class "a-date" (str (article-date article)))
		   (:p :class "a-summary" (str (article-summary article)))))))))))

(defun view-cat-subcat (cat subcat)
  (with-html-output-to-string (out)
    (:html
     (:body
	  (:ul
	   (dolist (article (paginated-list-of-articles *article-storage*))
		 (htm
		  (:li
		   (:p :class "a-title" (str (article-title article)))
		   (:p :class "a-date" (str (article-date article)))
		   (:p :class "a-summary" (str (article-summary article)))))))))))

(defun view-author (author)
  (with-html-output-to-string (out)
    (:html
     (:body
	  (:ul
	   (dolist (article (paginated-list-of-articles *article-storage*))
		 (htm
		  (:li
		   (:p :class "a-title" (str (article-title article)))
		   (:p :class "a-date" (str (article-date article)))
		   (:p :class "a-summary" (str (article-summary article)))))))))))

(defun view-tag (tag)
  (with-html-output-to-string (out)
    (:html
     (:body
	  (:ul
	   (dolist (article (paginated-list-of-articles *article-storage*))
		 (htm
		  (:li
		   (:p :class "a-title" (str (article-title article)))
		   (:p :class "a-date" (str (article-date article)))
		   (:p :class "a-summary" (str (article-summary article)))))))))))

(defun view-article (title-and-id)
  (let* ((id (first (split-sequence:split-sequence "-" title-and-id :from-end t :test #'string-equal :count 1)))
		 (article (get-article-by-id *article-storage* (parse-integer id))))
	(with-html-output-to-string (out)
	  (:html
	   (:body
		(:div (:p :class "a-title" (str (article-title article)))
			  (:p :class "a-date" (str (article-date article)))
			  (:p :class "a-body" (str (article-body article)))))))))

(defun view-search ())
