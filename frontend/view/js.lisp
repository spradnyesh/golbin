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
                 (display-subcategory (event)
                   ($prevent-default)
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
                     (setf that this)))
                 (hide-subcategory (event)
                   ($prevent-default)
                   (when in-nav
                     ($apply ($apply ($ that)
                                 children
                               "ul")
                         append
                       ($apply ($ "#subnav")
                           children))
                     ($apply ($ "#subnav") append subnav)
                     (setf in-nav nil)
                     (setf that nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; carousel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 (carousel-prev (event)
                   ($prevent-default)
                   (let* ((parent (@ event target parent-node parent-node parent-node))
                          (prev (@ parent children "div.prev"))
                          (current ($apply parent children "div.current"))
                          (next ($apply parent children "div.next"))
                          (prev-children ($apply prev children)))
                     (when (> (length prev-children) 0)
                       ($apply next
                           append ($apply current children))
                       ($apply current
                           append (elt ($apply prev children)
                                       (1- (length prev-children)))))))
                 (carousel-next (event)
                   ($prevent-default)
                   (let* ((parent (@ event target parent-node parent-node parent-node))
                          (prev ($apply parent children "div.prev"))
                          (current ($apply parent children "div.current"))
                          (next ($apply parent children "div.next"))
                          (next-children ($apply next children))
                          (len-next (length next-children)))
                     (alert (@ parent tag-name))
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
                                             (create :url ($apply (elt page-typeof 1)
                                                              replace
                                                            (regex "/0\\\/$/")
                                                            (+ (elt page-typeof 0) "/"))
                                                     :data-type "json"))
                                       done
                                     (lambda (data)
                                       (if (= data.status "success")
                                           (progn
                                             ;; update page-number
                                             ($apply ($apply parent children "span")
                                                 html
                                               (+ (+ 1 (parse-int
                                                        (elt page-typeof 0)))
                                                  ", "
                                                  (elt page-typeof 1)))
                                             ($apply next append data.data))
                                           (carousel-fail data)) ))
                               fail
                             (carousel-fail data)))))))
                 (carousel-fail (data))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; comment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 (comment-reply (event)
                   ($prevent-default)
                   ($apply ($ "#a-comments .parent") val ($apply ($ this) attr "id"))
                   ($apply ($apply ($ this) parent) append ($apply ($ "#c-table") remove))
                   ($apply ($ "#c-table") show))))

          ;; define event handlers
          ($event ("#prinav .cat" hover) (display-subcategory event))
          ($event ("#nav" hover) (hide-subcategory event))
          ($event (".carousel p.prev a" click) (carousel-prev event))
          ($event (".carousel p.next a" click) (carousel-next event))
          ($event ("#a-comments .c-reply a" click) (comment-reply event))))))
