(in-package :hawksbill.golbin.frontend)

(defun init-config ()
  (setf *config-storage* (make-instance 'config-storage))
  (init-config-tree *config*))

(defun init-storage ()
  (init-db-system "article" :articles)
  (init-db-system "author" :authors)
  (init-db-system "category" :categorys)
  (init-db-system "tag" :tags))
