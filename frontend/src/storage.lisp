(in-package :hawksbill.golbin.frontend)

(defun init-config ()
  (setf *config-storage* (make-instance 'config-storage))
  (init-config-tree *config*))

(defmacro init-cl-prevalence (system class)
  `(setf (get-root-object *db* ,system) (make-instance ,class)))
(defun init-storage ()
  (init-cl-prevalence :articles 'article-storage)
  (init-cl-prevalence :authors 'author-storage)
  (init-cl-prevalence :categories 'category-storage)
  (init-cl-prevalence :tags 'tag-storage)
  #|(setf *view-storage* (make-instance 'views-storage))|#
  #|(setf *count-storage* (make-instance 'page-count-storage))|#)
