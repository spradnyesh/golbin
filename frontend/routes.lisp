(in-package :hawksbill.golbin.frontend)

(restas:define-route home ("") (home-view))
(restas:define-route cat ("c/:(cat)") (cat-view cat))
(restas:define-route cat-subcat ("c/:(cat)/:(subcat)") (cat-subcat-view cat subcat))
(restas:define-route tag ("t/:(tag)") (tag-view tag))
(restas:define-route author ("a/:(author)") (author-view author))
(restas:define-route article (":(title)-:(id).html") (article-view title id))

(defun head-view ())

(defun foot-view ())

(defun home-view ()
  (who:with-html-output-to-string (out)
    (:html
     (:body
	  (:ul
	   (dolist (article (paginate (get-all-articles *article-storage*)))
		 (htm
		  (:li
		   (:a :class "a-title"
			   :href (restas:genurl 'article-view
									:title (article-title article)
									:id (article-id article))
			   (str (article-title article)))
		   (:p :class "a-date" (str (article-date article)))
		   (:p :class "a-summary" (str (article-summary article)))))))))))

(defun cat-view (cat)
  (who:with-html-output-to-string (out)
    (:html
     (:body
	  (:ul
	   (dolist (article (paginate (get-articles-by-cat *article-storage* cat)))
		 (htm
		  (:li
		   (:p :class "a-title" (str (article-title article)))
		   (:p :class "a-date" (str (article-date article)))
		   (:p :class "a-summary" (str (article-summary article)))))))))))

(defun cat-subcat-view (cat subcat)
  (who:with-html-output-to-string (out)
    (:html
     (:body
	  (:ul
	   (dolist (article (paginated-list-of-articles *article-storage*))
		 (htm
		  (:li
		   (:p :class "a-title" (str (article-title article)))
		   (:p :class "a-date" (str (article-date article)))
		   (:p :class "a-summary" (str (article-summary article)))))))))))

(defun author-view (author)
  (who:with-html-output-to-string (out)
    (:html
     (:body
	  (:ul
	   (dolist (article (paginated-list-of-articles *article-storage*))
		 (htm
		  (:li
		   (:p :class "a-title" (str (article-title article)))
		   (:p :class "a-date" (str (article-date article)))
		   (:p :class "a-summary" (str (article-summary article)))))))))))

(defun tag-view (tag)
  (who:with-html-output-to-string (out)
    (:html
     (:body
	  (:ul
	   (dolist (article (paginated-list-of-articles *article-storage*))
		 (htm
		  (:li
		   (:p :class "a-title" (str (article-title article)))
		   (:p :class "a-date" (str (article-date article)))
		   (:p :class "a-summary" (str (article-summary article)))))))))))

(defun article-view (title id)
  (declare (ignore title))
  (let ((article (storage-get-article *article-storage* (parse-integer id))))
	(who:with-html-output-to-string (out)
	  (:html
	   (:body
		(:div (:p (str (article-title article)))
			  (:p (str (article-date article)))
			  (:p (str (article-body article)))))))))
