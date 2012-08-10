(in-package :hawksbill.golbin.editorial)

(import-macros-from-lisp '$event)
(import-macros-from-lisp '$apply)

(defun on-load ()
  (ps ($event (document ready)
        ;; define functions
        (flet (
               ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
               ;;; article page
               ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
               ;; change sub-category when user changes category
               (article-change-category ()
                 (let ((cat-id (parse-int ($apply ($ "#cat") val)))
                       (e nil))
                   (dolist (ct category-tree)
                     (when (= cat-id (@ (elt ct 0) id))
                       ($apply ($ "#subcat")
                           empty)
                       (when (elt ct 1)
                         (dolist (subcat (elt ct 1))
                           (setf e ($apply ($apply ($ "<option></option>")
                                               'val
                                             (+ "" (@ subcat id)))
                                     text
                                     (@ subcat name)))
                           ($apply ($ "#subcat")
                               append
                             e)))))))

               ;; create and initialize select-photo popup
               (select-photo-init (who page)
                 ($apply event prevent-default)
                 ;; create popup div and display on page
                 ($apply ($ "#bd")
                     append
                   ($ "<div id='photo-pane'><p class='close'><a href=''>Close</a></p><ul></ul></div>"))
                 ($event ("#photo-pane" click) (close-photo-pane))
                 ;; TODO: show loading icon
                 (select-photo-call who page)
                 false)

               (select-photo-call (who page)
                 ;; make ajax call
                 ($apply ($apply ($apply $
                                     ajax
                                   (create :url (+ "/ajax/photos/" who "/" page "/")
                                           :cache false
                                           :data-type "json"
                                           :async false))
                             done
                           (lambda (data) (select-photo-done data)))
                     fail
                   (lambda (data) (select-photo-fail data))))

               (select-photo-done (data)
                 ;; TODO: clear loading icon
                 (if (= data.status "success")
                     (progn
                       (dolist (d data.data)
                         (let* ((id ((@ ($ "<span></span>") html) (elt d 0)))
                                (img ($ (elt d 1)))
                                (title ((@ ($ "<p></p>") append) ((@ ($ img) attr) "alt")))
                                (a ($apply ($ "<a href=''></a>") append img)))
                           ($event (a click) (select-photo))
                           ($apply ($ "#photo-pane ul")
                               append
                             ($apply ($apply ($apply ($ "<li></li>")
                                                 append id)
                                         append a)
                                 append title)))))
                     (select-photo-fail data)))

               (select-photo ()
                 ($apply event prevent-default)
                 ($apply ($ "#lead-photo")
                     val
                   ($apply ($apply ($apply ($ (@ event target))
                                       parent)
                               siblings "span")
                       html))
                 (close-photo-pane))

               (select-photo-fail (data)
                 ;; TODO: clear loading icon
                 ;; TODO: show error message
                 )

               (close-photo-pane ()
                 ($apply event prevent-default)
                 ((@ ($ "#photo-pane") remove))
                 false)))

        ;; define event handlers
        ($event ("#cat" change) (article-change-category))
        ($event ("#select-photo" click) (select-photo-init "all" 0))

        ;; call functions on document.ready
        (article-change-category))))
