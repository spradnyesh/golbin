(in-package :hawksbill.golbin.model)

(defun init-storage (dim-str)
  (init-db-system "article" :articles dim-str)
  (init-db-system "author" :authors dim-str)
  (init-db-system "category" :categorys dim-str)
  (init-db-system "photo" :photos dim-str)
  (init-db-system "tag" :tags dim-str)
  (init-db-system "comment" :comments dim-str))

(defun model-first-run ()
  (dolist (l '("article" "author" "category" "photo" "tag" "comment"))
    (db-execute (intern (string-upcase (format nil "make-~as-root" l)))))
  (add-cat/subcat))

(defmethod model-init (dim-str)
  (init-storage dim-str))

(defun model-tmp-init ()
  (add-tags)
  (add-authors)
  ;; XXX: need to do these step manually. also, authors need to be added _before_ photos, since a photo can only be uploaded by an existing author. this means that the (gr)avtar of an author can only be added _after_ the author has been created. add photos for both authors and articles
  #- (and)
  ((clean-photos-dir uploads static)
   (add-photos))
  #- (and)
  (assign-photos-to-authors)
  (add-articles))
