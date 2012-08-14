(in-package :hawksbill.golbin.frontend)

(import-macros-from-lisp '$event)
(import-macros-from-lisp '$apply)

(defun on-load ()
  (ps ($event (document ready)
        ;; define variables
        (let ((that nil)
              (subnav nil)
              (in-nav nil)
              (carousel-move 4))

          ;; define functions
          (flet (
                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 ;;; navigation
                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 (display-subcategory ()
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
                   false)
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
                   false)

                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 ;;; carousel
                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 (carousel-prev ()
                   ($prevent-default)
                   (let* ((parent ($apply ($apply ($ this) parent) parent))
                          (prev ($apply parent children "div.prev"))
                          (current ($apply parent children "div.current"))
                          (next ($apply parent children "div.next"))
                          (prev-children ($apply prev children)))
                     (when (> (length prev-children) 0)
                       ($apply next
                           append ($apply current children))
                       ($apply current
                           append (elt ($apply prev children)
                                       (1- (length prev-children))))))
                   false)
                 (carousel-next ()
                   ($prevent-default)
                   (let* ((parent ($apply ($apply ($ this) parent) parent))
                          (prev ($apply parent children "div.prev"))
                          (current ($apply parent children "div.current"))
                          (next ($apply parent children "div.next"))
                          (next-children ($apply next children)))
                     (when (> (length next-children) 0)
                       ($apply prev append ($apply current children))
                       ($apply current
                           append
                         (elt next-children 0))))
                   false)))

          ;; define event handlers
          ($apply ($ "#prinav .cat") hover display-subcategory (lambda () ()))
          ($apply ($ "#nav") hover (lambda () ()) hide-subcategory)
          ($apply ($ "#related p.prev a") click carousel-prev)
          ($apply ($ "#related p.next a") click carousel-next)))))
