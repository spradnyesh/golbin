(in-package :hawksbill.golbin.editorial)

(import-macros-from-lisp '$event)
(import-macros-from-lisp '$apply)
(import-macros-from-lisp '$prevent-default)

(defun on-load ()
  (ps ($event (document ready)
        ;; define variables
        (let ((select-photo-who "all")
              (select-photo-next-page (create "all" 0 "me" 0))
              (select-photo-pagination-direction "next"))
          ;; define functions
          (flet (
                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 ;;; utility functions
                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 (split (val)
                   ($apply val split (regex "/,\s*/")))

                 (extract-last (term)
                   ($apply ((@ split) term) pop))

                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 ;;; article page
                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                 ;; change sub-category when user changes category
                 (article-change-category ()
                   (let ((cat-id (parse-int ($apply ($ "#cat") val)))
                         (ele nil))
                     (dolist (ct category-tree)
                       (when (= cat-id (@ (elt ct 0) id))
                         ($apply ($ "#subcat")
                             empty)
                         (when (elt ct 1)
                           (dolist (subcat (elt ct 1))
                             (setf ele ($apply ($apply ($ "<option></option>")
                                                 'val
                                               (+ "" (@ subcat id)))
                                         text
                                       (@ subcat name)))
                             ($apply ($ "#subcat")
                                 append
                               ele)))))))

                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 ;;; common for select/upload photo pane
                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 (create-photo-pane ()
                   ($apply ($ "#bd")
                       append
                     ($ "<div id='photo-pane'><p><a class='close' href=''>Close</a></p><ul></ul></div>"))
                   ($event ("#photo-pane a.close" click) (close-photo-pane)))

                 (photo-fail (data)
                   ;; TODO: clear loading icon
                   ;; TODO: show error message
                   false)

                 (close-photo-pane ()
                   ($prevent-default)
                   ((@ ($ "#photo-pane") remove))
                   false)

                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 ;;; select photo pane
                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 (select-photo-init ()
                   (create-photo-pane)
                   ($apply ($ "#photo-pane") append ($ "<div class='pagination'><a href='' class='prev'>Previous</a><a href='' class='next'>Next</a></div>"))
                   ;; TODO: show loading icon
                   (select-photo-add-all-my-tabs)
                   (select-photo-call "all" 0)
                   ($event ("#photo-pane .pagination a.prev" click) (select-photo-pagination-prev))
                   ($event ("#photo-pane .pagination a.next" click) (select-photo-pagination-next)))

                 (select-photo-add-all-my-tabs ()
                   ($apply ($ "#photo-pane p") prepend ($ "<span>Photos<a class='all-photos' href=''> All </a><a class='my-photos' href=''> My </a></span>"))
                   ($event ("#photo-pane a.all-photos" click) (select-photo-call "all" 0))
                   ($event ("#photo-pane a.my-photos" click) (select-photo-call "me" 0)))

                 (select-photo-call (who page)
                   (when (< page 0)
                     return)
                   (setf select-photo-who who)
                   ($prevent-default)
                   ($apply ($apply ($apply $
                                       ajax
                                     (create :url (+ "/ajax/photos/" who "/" page "/")
                                             :cache false
                                             :data-type "json"
                                             :async false))
                               done
                             (lambda (data) (select-photo-done data)))
                       fail
                     (lambda (data) (photo-fail data)))
                   false)

                 (select-photo-done (data)
                   ;; TODO: clear loading icon
                   (if (= data.status "success")
                       (progn (if (= select-photo-pagination-direction "prev")
                                  (setf (elt select-photo-next-page select-photo-who)
                                        (1- (elt select-photo-next-page select-photo-who)))
                                  (setf (elt select-photo-next-page select-photo-who)
                                        (1+ (elt select-photo-next-page select-photo-who))))

                              ($apply ($ "#photo-pane ul") empty)
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
                   (let ((target-img ($ (@ event target)))))
                   ($apply ($ "#lead-photo")
                       val
                     ($apply ($apply ($apply target-img
                                         parent)
                                 siblings "span")
                         html))
                   ($apply ($apply ($ "#lead-photo") siblings "span") html target-img)
                   (close-photo-pane))

                 (select-photo-pagination-prev ()
                   ($prevent-default)
                   (setf select-photo-pagination-direction "prev")
                   (select-photo-call select-photo-who (- (elt select-photo-next-page select-photo-who) 2)))

                 (select-photo-pagination-next ()
                   ($prevent-default)
                   (setf select-photo-pagination-direction "next")
                   (select-photo-call select-photo-who (elt select-photo-next-page select-photo-who)))

                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 ;;; upload photo pane
                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 (upload-photo-init ()
                   ($prevent-default)
                   (create-photo-pane)
                   ($apply ($ "#photo-pane ul") remove)
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
                           (elt data.data 0))
                         ($apply ($apply ($ "#lead-photo") siblings "span") html (elt data.data 1))
                         (close-photo-pane))
                       (photo-fail data))))))

        ;; define event handlers
        ($event ("#cat" change) (article-change-category))
        ($event ("#select-photo" click) (select-photo-init))
        ($event ("#upload-photo" click) (upload-photo-init))

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;;; tags autocomplete ; http://jqueryui.com/demos/autocomplete/#multiple-remote
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ($apply ($apply ($ "#tags")
                bind "keydown"
                (lambda (event)
                  (when (and (eql (@ event key-code)
                                  (@ (@ (@ $ ui) key-code) "TAB"))
                             (@ (@ ($apply ($ this) data "autocomplete") menu) active))
                    ($prevent-default))))
            autocomplete
          (create :min-length 2
                 :source (lambda (request response)
                           ($apply $ ajax
                             (create :url "/ajax/tags/"
                                     :data (create :term ((@ extract-last) (@ request term)))
                                     :data-type "json"
                                     :success response))
                           false)
                 :search (lambda () (let ((term ((@ extract-last) (@ this value))))
                                      (if (< (@ term length) 2)
                                          false
                                          true)))
                 :focus (lambda () false)
                 :select (lambda (event ui)
                           (let ((terms ((@ split) (@ this value))))
                             ($apply terms pop)
                             ($apply terms push (@ (@ ui item) value))
                             ($apply terms push "")
                             (setf (@ this value) ($apply terms join ", ")))
                           false)))

        ;; call functions on document.ready
        (article-change-category)
        false)))
