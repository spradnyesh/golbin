(in-package :hawksbill.golbin.frontend)

(import-macros-from-lisp '$event)
(import-macros-from-lisp '$apply)

(defun on-load ()
  (ps ($event (document ready)
        ;; define variables
        (let ((that nil)
              (subnav nil)
              (in-nav nil))

          ;; define functions
          (flet ((display-subcategory ()
                   (unless in-nav
                     (setf subnav ($apply ($ "#subnav")
                                      children))
                     ($apply ($ "#subnav")
                         empty)
                     ($apply ($ "#subnav")
                         append
                       ($apply ($apply ($ this)
                                   children
                                 "ul")
                           children))
                     (setf in-nav t)
                     (setf that this))
                   nil)
                 (hide-subcategory ()
                   (when in-nav
                     ($apply ($apply ($ that)
                                 children
                               "ul")
                         append
                       ($apply ($ "#subnav")
                           children))
                     ($apply ($ "#subnav") append subnav)
                     (setf in-nav nil)
                     (setf that nil))
                   nil)))

          ;; define event handlers
          ((@ ($ "#prinav .cat") hover) display-subcategory (lambda () ()))
          ((@ ($ "#nav") hover) (lambda () ()) hide-subcategory)))))
