(in-package :hawksbill.golbin)

(defun init-storage ()
  (init-db-system "article" :articles)
  (init-db-system "author" :authors)
  (init-db-system "category" :categorys)
  (init-db-system "tag" :tags)
  (init-db-system "photo" :photos))

(defun model-first-run ()
  (dolist (l '("article" "author" "category" "tag"))
    (execute *db* (make-transaction (intern (string-upcase (format nil "make-~as-root" l))))))
  (add-cat/subcat))

(defmethod model-init ()
  (init-storage))

(defun model-tmp-init ()
  (add-authors)
  (add-tags)
  (add-articles))
