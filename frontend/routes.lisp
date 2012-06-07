(in-package :hawksbill.golbin.frontend)

(restas:define-route route-home ("") (view-home))
(restas:define-route route-cat ("c/:cat") (view-cat cat))
(restas:define-route route-cat-subcat ("c/:cat/:subcat") (view-cat-subcat cat subcat))
(restas:define-route route-tag ("t/:tag") (view-tag tag))
(restas:define-route route-author ("a/:author") (view-author author))
#|(restas:define-route route-article (":(title)-:(id).html"
									:parse-vars (list :title (lambda (str)
															   (check-article-title str))
													  :id (lambda (str)
															(check-article-id str))))
  (view-article title id))|#
#|(restas:define-route route-article (":(id)-:(title).html"
									:parse-vars (list :title (lambda (str)
															   (check-article-title str))
													  :id (lambda (str)
															(check-article-id str))))
  (view-article title id))|#


(restas:define-route route-article (":(title)-:(id).html"
									:parse-vars (list :title (lambda (str)
															   (check-article-title str))
													  :id (lambda (str)
															(check-article-id str))))
  (view-article title id))


(defun check-article-id (str)
  "article id can only be an integer"
  (match-str (compile-str "^[0-9]+$") str))

(defun check-article-title (str)
  "article title can only be an alphanum string interspersed w/ dashes"
  (match-str (compile-str "^[-0-9a-zA-Z]+$") str))
