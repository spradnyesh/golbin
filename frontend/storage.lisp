(in-package :hawksbill.golbin.frontend)

(setf *article-storage* (make-instance 'article-storage))
(setf *category-storage* (make-instance 'category-storage))
(setf *view-storage* (make-instance 'views-storage))
(setf *count-storage* (make-instance 'count-storage))
(setf *tag-storage* (make-instance 'tag-storage))
(setf *author-storage* (make-instance 'author-storage))
(setf *config-storage* (make-instance 'config-storage))
