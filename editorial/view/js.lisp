(in-package :hawksbill.golbin.editorial)

(import-macros-from-lisp '$event)
(import-macros-from-lisp '$apply)
(import-macros-from-lisp '$prevent-default)

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

               ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
               ;;; common for select/upload photo pane
               ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
               (create-photo-pane ()
                 ($apply ($ "#bd")
                     append
                   ($ "<div id='photo-pane'><p class='close'><a href=''>Close</a></p></div>"))
                 ($event ("#photo-pane p a" click) (close-photo-pane)))

               (photo-fail (data)
                 ;; TODO: clear loading icon
                 ;; TODO: show error message
                 )

               (close-photo-pane ()
                 ($prevent-default)
                 ((@ ($ "#photo-pane") remove))
                 false)

               ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
               ;;; select photo pane
               ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
               (select-photo-init (who page)
                 ($prevent-default)
                 (create-photo-pane)
                 ;; TODO: show loading icon
                 (select-photo-call who page)
                 false)

               (select-photo-call (who page)
                 ($apply ($apply ($apply $
                                     ajax
                                   (create :url (+ "/ajax/photos/" who "/" page "/")
                                           :cache false
                                           :data-type "json"
                                           :async false))
                             done
                           (lambda (data) (select-photo-done data)))
                     fail
                   (lambda (data) (photo-fail data))))

               (select-photo-done (data)
                 ;; TODO: clear loading icon
                 (if (= data.status "success")
                     (progn
                       ($apply ($ "#photo-pane") append ($ "<ul></ul>"))
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
                     (photo-fail data)))

               (select-photo ()
                 ($prevent-default)
                 ($apply ($ "#lead-photo")
                     val
                   ($apply ($apply ($apply ($ (@ event target))
                                       parent)
                               siblings "span")
                       html))
                 (close-photo-pane))

               ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
               ;;; upload photo pane
               ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
               (upload-photo-init ()
                 ($prevent-default)
                 (create-photo-pane)
                 ;; TODO: show loading icon
                 (upload-photo-call)
                 false)

               (upload-photo-call ()
                 ($apply ($apply ($apply $
                                     ajax
                                   (create :url (+ "/ajax/photo/")
                                           :data-type "json"
                                           :async false))
                             done
                           (lambda (data) (upload-photo-get-done data)))
                     fail
                   (lambda (data) (photo-fail data))))

               (upload-photo-get-done (data)
                 (if (= data.status "success")
                     (progn
                       ($apply ($ "#photo-pane")
                           append
                         data.data)
                       ($event ("#photo-pane form" submit) (upload-photo-submit)))
                     (photo-fail data)))

               (upload-photo-submit ()
                 ($prevent-default)
                 ($apply ($ "#photo-pane form") ajax-submit
                   (create :data-type "json"
                           :async false
                           :success (lambda (data) (upload-photo-submit-done data))
                           :error (lambda (data) (photo-fail data))))
                 false)

               (upload-photo-submit-done (data)
                 (if (= data.status "success")
                     (progn
                       ($apply ($ "#lead-photo")
                           val
                         data.data)
                       (close-photo-pane))
                     (photo-fail data)))))

        ;; define event handlers
        ($event ("#cat" change) (article-change-category))
        ($event ("#select-photo" click) (select-photo-init "all" 0))
        ($event ("#upload-photo" click) (upload-photo-init))

        ;; call functions on document.ready
        (article-change-category))))
