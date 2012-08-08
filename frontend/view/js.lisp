(in-package :hawksbill.golbin.frontend)

(import-macros-from-lisp '$$)

(defun on-load ()
  (ps ($$ (document ready)
        ;; define variables
        (let ((that nil)
              (subnav nil)
              (in-nav nil))

          ;; define functions
          (flet ((display-subcategory ()
                   (unless in-nav
                     (setf subnav ((@ ($ "#subnav") children)))
                     ((@ ($ "#subnav") empty))
                     ((@ ($ "#subnav") append) ((@ ((@ ($ this) children) "ul") children)))
                     (setf in-nav t)
                     (setf that this))
                   nil)
                 (hide-subcategory ()
                   (when in-nav
                     ((@ ((@ ($ that) children) "ul") append) ((@ ($ "#subnav") children)))
                     ((@ ($ "#subnav") append) subnav)
                     (setf in-nav nil)
                     (setf that nil))
                   nil)))

          ;; define event handlers
          ((@ ($ "#prinav .cat") hover) display-subcategory (lambda () ()))
          ((@ ($ "#nav") hover) (lambda () ()) hide-subcategory)))))
