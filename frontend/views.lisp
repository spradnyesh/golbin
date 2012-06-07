(in-package :hawksbill.golbin.frontend)

(defun head ())

(defun foot ())

(defun view-home ()
  (who:with-html-output-to-string (out)
    (:html
     (:body
	  (:ul
	   (dolist (article (paginate (get-all-articles *article-storage*)))
		 (htm
		  (:li
		   (:a :class "a-title"
			   :href (restas:genurl 'route-article
									:title (article-title article)
									:id (article-id article))
			   (str (article-title article)))
		   (:p :class "a-date" (str (article-date article)))
		   (:p :class "a-summary" (str (article-summary article)))))))))))

(defun view-cat (cat)
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

(defun view-cat-subcat (cat subcat)
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

(defun view-author (author)
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

(defun view-tag (tag)
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

(defun view-article (title id)
  (declare (ignore title))
  (let ((article (get-article-by-id *article-storage* (parse-integer id))))
	(who:with-html-output-to-string (out)
	  (:html
	   (:body
		(:div (:p (str (article-title article)))
			  (:p (str (article-date article)))
			  (:p (str (article-body article)))))))))
