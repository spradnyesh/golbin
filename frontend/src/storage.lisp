(in-package :hawksbill.golbin.frontend)

(defun init-storage ()
  (dbm-put *db* "article" (make-instance 'article-storage) :mode :keep)
  (dbm-put *db* "category" (make-instance 'category-storage) :mode :keep)
  (dbm-put *db* "view" (make-instance 'views-storage) :mode :keep)
  (dbm-put *db* "count" (make-instance 'page-count-storage) :mode :keep)
  (dbm-put *db* "tag" (make-instance 'tag-storage) :mode :keep)
  (dbm-put *db* "author" (make-instance 'author-storage) :mode :keep)
  (dbm-put *db* "config" (make-instance 'config-storage) :mode :keep))
