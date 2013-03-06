(in-package :hawksbill.golbin.frontend)

(import-macros-from-lisp '$event)
(import-macros-from-lisp '$apply)
(import-macros-from-lisp '$prevent-default)

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
                          (next-children ($apply next children))
                          (len-next (length next-children)))
                     (when (> len-next 0)
                       ;; show the current (next) batch
                       ($apply prev append ($apply current children))
                       ($apply current append (elt next-children 0))
                       ;; pre-fetch next (next) batch of related articles
                       (when (= len-next 1)
                         (let ((id ($apply ($apply ($apply parent parent)
                                               children "span")
                                       html))
                               (page-typeof ($apply ($apply ($apply parent children "span")
                                                        html)
                                                split ", ")))
                           ($apply ($apply ($apply $
                                               ajax
                                             (create :url ((@ (elt page-typeof 1) replace)
                                                           (regex "/0/")
                                                           (elt page-typeof 0))
                                                     :data-type "json"))
                                       done
                                     (lambda (data)
                                       (if (= data.status "success")
                                           (progn
                                             ;; update page-number
                                             ($apply ($apply parent children "span")
                                                 html (+ (+ 1 (parse-int
                                                               (elt page-typeof 0)))
                                                         ", "
                                                         (elt page-typeof 1)))
                                             ($apply next append data.data))
                                           (carousel-fail data)) ))
                               fail
                             (carousel-fail data))))))
                   false)
                 (carousel-fail (data)
                   false)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; comment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 (comment-reply ()
                   ($prevent-default)
                   ($apply ($ "#a-comments .parent") val ($apply ($ this) attr "id"))
                   ($apply ($apply ($ this) parent) append ($apply ($ "#c-table") remove))
                   ($apply ($ "#c-table") show)
                   false)))

          ;; define event handlers
          ($apply ($ "#prinav .cat") hover display-subcategory (lambda () ()))
          ($apply ($ "#nav") hover (lambda () ()) hide-subcategory)
          ($apply ($ ".carousel p.prev a") click carousel-prev)
          ($apply ($ ".carousel p.next a") click carousel-next)
          ($apply ($ "#a-comments .c-reply a") click comment-reply)
          false))))
