(in-package :hawksbill.golbin.frontend)

(defun init-config ()
  (setf *config-storage* (make-instance 'config-storage))
  (init-config-tree *config*))

(defmacro init-prevalence (name system)
  `(progn
     (defun ,(intern (string-upcase (format nil "make-~as-root" `,name))) (system)
       (setf (get-root-object system ,system)
             (make-instance ',(intern (string-upcase (format nil "~a-storage" `,name))))))))
(defun init-storage ()
  (init-prevalence "article" :articles)
  (init-prevalence "author" :authors)
  (init-prevalence "category" :categorys)
  (init-prevalence "tag" :tags))
