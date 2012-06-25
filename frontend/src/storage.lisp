(in-package :hawksbill.golbin.frontend)

(defun init-config ()
  (setf *config-storage* (make-instance 'config-storage))
  (init-config-tree *config*))

(defmacro init-cl-prevalence (name system class)
  `(progn
     (defun ,(intern (string-upcase (format nil "make-~as-root" `,name))) (system)
       (setf (get-root-object system ,system)
             (make-instance ',(intern (string-upcase (format nil "~a-storage" `,name))))))
     (execute *db* (make-transaction ',(intern (string-upcase (format nil "make-~as-root" `,name)))))))
(defun init-storage ()
  (init-cl-prevalence "article" :articles 'article-storage)
  (init-cl-prevalence "author" :authors 'author-storage)
  (init-cl-prevalence "category" :categorys 'category-storage)
  (init-cl-prevalence "tag" :tags 'tag-storage))
