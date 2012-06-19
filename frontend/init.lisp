(in-package :hawksbill.golbin.frontend)

(defun r-stop ()
  (restas:stop-all))
(defun r-start ()
  (tmp-init)
  (restas:start :hawksbill.golbin.frontend :port 8000))
(defun r-restart ()
  (r-stop)
  (r-start))

(defun add-articles (&optional (article-storage *article-storage*) (category-storage *category-storage*))
  "add a new articles to the db"
  (dotimes (i 1000)
    (multiple-value-bind (cat subcat) (get-random-cat-subcat category-storage)
      (add-article (make-instance 'article
                                  :title (format nil "title  of $ % ^ * the ~Ath article" (1+ i))
                                  :summary (format nil "~A: There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain... --http://lipsum.com/" (1+ i))
                                  :tags (format nil "tags-~A" (1+ i))
                                  :body (format nil "~A: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.

It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)." (1+ i))
                                  :cat cat
                                  :subcat subcat)
                   article-storage))))

(defun tmp-init ()
  (setf *author-storage* (make-instance 'author-storage))
  (add-author (make-instance 'author
                             :name "Hawksbill"
                             :handle "hawksbill")
              *author-storage*)
  (setf *article-storage* (make-instance 'article-storage))
  (add-articles *article-storage* *category-storage*))
