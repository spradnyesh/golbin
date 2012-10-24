(in-package :hawksbill.golbin.model)

(defun init-storage (dimension)
  (init-db-system dimension "article" :articles)
  (init-db-system dimension "author" :authors)
  (init-db-system dimension "category" :categorys)
  (init-db-system dimension "photo" :photos)
  (init-db-system dimension "tag" :tags))

(defun model-first-run ()
  (dolist (l '("article" "author" "category" "photo" "tag"))
    (execute *db* (make-transaction (intern (string-upcase (format nil "make-~as-root" l))))))
  (add-cat/subcat))

(defmethod model-init (dimension)
  (init-storage dimension))

(defun model-tmp-init ()
  (add-tags)
  (add-authors)
  #|(
   ;; XXX: need to do these step manually. also, authors need to be added _before_ photos, since a photo can only be uploaded by an existing author. this means that the (gr)avtar of an author can only be added _after_ the author has been created. add photos for both authors and articles
   (clean-photos-dir uploads static)
   (add-photos))|#
  #|(assign-photos-to-authors)|#
  (add-articles))
