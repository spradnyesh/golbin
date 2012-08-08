(in-package :hawksbill.golbin.editorial)

(import-macros-from-lisp '$$)

(defun on-load ()
  (ps ($$ (document ready)
        ;; define functions
        (flet (
               ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
               ;;; article page
               ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
               ;; change sub-category when user changes category
               (article-change-category ()
                 (let ((cat-id (parse-int ((@ ($ "#cat") val))))
                       (e nil))
                   (dolist (ct category-tree)
                     (when (= cat-id (@ (elt ct 0) id))
                       ((@ ($ "#subcat") empty))
                       (when (elt ct 1)
                         (dolist (subcat (elt ct 1))
                           (setf e ((@ ((@ ($ "<option></option>")
                                           val)
                                        (+ "" (@ subcat id)))
                                       text)
                                    (@ subcat name)))
                           ((@ ($ "#subcat") append) e)))))))

               ;; create and initialize upload-photo popup
               (upload-photo-init (who page)
                 ((@ event prevent-default))
                 ;; create popup div and display on page
                 ((@ ($ "#bd") append) ($ "<div id='photo-pane'><p><a href=''>Close</a></p><ul></ul></div>"))
                 ;; show loading icon
                 ;; call upload-photo-call
                 (upload-photo-call who page))
               (upload-photo-call (who page)
                 ;; make ajax call
                 ((@ ((@ ((@ $ ajax) (create :url (+ "/ajax/photos/" who "/" page "/")
                                             :cache false
                                             :data-type "json"
                                             :async false))
                         done)
                      (lambda (data) (upload-photo-done data)))
                     fail)
                  (lambda (data) (upload-photo-fail data)))
                 false)
               (upload-photo-done (data)
                 ;; clear loading icon
                 ;; json -> html
                 #|(alert data)|#
                 (dolist (d data)
                   (let* ((id ((@ ($ "<span></span>") html) (elt d 0)))
                          (img-a ((@ ($ "<a href=''></a>") append) ($ (elt d 1)))))
                     ((@ ($ "#photo-pane ul") append) ((@ ((@ ($ "<li></li>") append) id) append) img-a))))
                 ;; insert html into popup div
                 )
               (upload-photo-fail (data)
                 ;; clear loading icon
                 ;; show error message
                 )))

        ;; define event handlers
        ($$ ("#cat" change) (article-change-category))
        ($$ ("#upload-photo" click) (upload-photo-init "all" 0))

        ;; call functions on document.ready
        (article-change-category))))
