(in-package :hawksbill.golbin.frontend)

(import-macros-from-lisp '$event)
(import-macros-from-lisp '$apply)
(import-macros-from-lisp '$prevent-default)
(import-macros-from-lisp '$log)

(defun on-load ()
  (ps ($event (document ready)
        ;; define variables
        (let ((subnav nil)
              (carousel-move 4))

          ;; define functions
          (flet (
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; navigation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 (update-subcategory (event)
                   ;; subnav <- #subnav, #subnav <- empty, #subnav <- @target
                   ($prevent-default)
                   (let ((node (@ event target parent-node parent-node)))
                     (when (= (@ node node-name) "LI")
                       (setf subnav ($apply ($ "#subnav") children))
                       ($apply ($ "#subnav") empty)
                       ($apply ($ "#subnav")
                           append
                         ($apply ($apply ($ (@ event target parent-node parent-node))
                                     children
                                   "ul")
                             children)))))
                 (restore-subcategory (event)
                   ;; @target <- #subnav, #subnav <- empty, #subnav <- subnav
                   ($prevent-default)
                   (let ((node (@ event target parent-node parent-node)))
                     (when (= (@ node node-name) "LI")
                       ($apply ($apply ($ node) children "ul")
                           append ($apply ($ "#subnav") children))
                       ($apply ($ "#subnav") empty)
                       ($apply ($ "#subnav") append subnav))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; carousel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 (carousel-prev (event)
                   ($prevent-default)
                   (let* ((parent ($ (@ event target parent-node parent-node)))
                          (prev ($apply parent children "div.prev"))
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
                   (let* ((parent ($ (@ event target parent-node parent-node)))
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
                                             (create :url ($apply (elt page-typeof 1)
                                                              replace
                                                            (regex "/0\\\/$/")
                                                            (+ (elt page-typeof 0) "/"))
                                                     :cache false
                                                     :async false
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
                             (lambda (data)
                               (carousel-fail data))))))))
                 (carousel-fail (data))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; comment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 ;; submit comments using ajax
                 (ajax-comments ()
                   ($apply ($ "#comments")
                       attr
                     "action"
                     (+ "/ajax" ($apply ($ "#comments") attr "action"))))

                 (comment-reply (event)
                   ($prevent-default)
                   ($apply ($ "#comments .parent") val ($apply ($ this) attr "id"))
                   #|($apply ($apply ($ this) parent) append ($apply ($ "#c-table") remove))|#
                   ($apply ($ "#c-table") show))))

          ;; some init functions
          (ajax-comments)

          ;; define event handlers
          ((@ ($ "#prinav .cat h2 a" ) hover)
           (lambda (event) (update-subcategory event))
           (lambda (event) (restore-subcategory event)))
          ($event (".carousel p.prev a" click) (carousel-prev event))
          ($event (".carousel p.next a" click) (carousel-next event))
          ($event ("#comments .c-reply a" click) (comment-reply event))))))
