(in-package :hawksbill.golbin.editorial)

(import-macros-from-lisp '$event)
(import-macros-from-lisp '$apply)
(import-macros-from-lisp '$prevent-default)

(defun on-load ()
  (ps ($event (document ready)
        ;; define variables
        (let ((select-photo-who "all")
              (select-photo-next-page (create "all" 0 "me" 0))
              (select-photo-pagination-direction "next")
              ;; flag to decide whether select-photo-next-page should be incremented or not
              (select-photo-paginate false))
          ;; define functions
          (flet (
                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 ;;; utility functions
                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 (split (val)
                   ($apply val split (regex "/,\\s*/")))

                 (extract-last (term)
                   ($apply ((@ split) term) pop))

                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 ;;; article page
                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 ;; change sub-category when user changes category
                 (article-change-category (form-prefix)
                   (let ((cat-id (parse-int ($apply ($ (+ form-prefix " .cat")) val)))
                         (ele nil))
                     (if (eql cat-id 0)
                         (progn
                           ($apply ($ (+ form-prefix " .subcat")) empty)
                           ($apply ($ (+ form-prefix " .subcat"))
                               append
                             ($ "<option selected='selected' value='0'>Select</option>")))
                         (dolist (ct category-tree)
                           (when (= cat-id (@ (elt ct 0) id))
                             ($apply ($ (+ form-prefix " .subcat"))
                                 empty)
                             (when (elt ct 1)
                               (dolist (subcat (elt ct 1))
                                 (setf ele ($apply ($apply ($ "<option></option>")
                                                       'val
                                                     (+ "" (@ subcat id)))
                                               text
                                             (@ subcat name)))
                                 ($apply ($ (+ form-prefix " .subcat"))
                                     append
                                   ele))))))))

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
                   (setf select-photo-paginate false)
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
                   ($apply ($ "#photo-pane p") prepend ($ "<div class='search'></div>"))
                   ;; TODO: show loading icon
                   (select-photo-add-all-my-tabs)
                   (select-search-markup)
                   (select-photo-call "all" 0)
                   ($event ("#photo-pane .pagination a.prev" click) (select-photo-pagination-prev))
                   ($event ("#photo-pane .pagination a.next" click) (select-photo-pagination-next)))

                 (select-photo-add-all-my-tabs ()
                   ($apply ($ "#photo-pane p") prepend ($ "<span>Photos<a class='all-photos' href=''> All </a><a class='my-photos' href=''> My </a></span>"))
                   ($event ("#photo-pane a.all-photos" click) (select-photo-call "all" 0))
                   ($event ("#photo-pane a.my-photos" click) (select-photo-call "me" 0)))

                 (select-search-markup ()
                   (let ((cat ($ "<select name='cat' class='td-input cat'><option selected='selected' value='0'>Select</option></select>"))
                         (subcat ($ "<select name='subcat' class='td-input subcat'><option selected='selected' value='0'>Select</option></select>"))
                         (tags ($ "<input class='td-input tags' type='text'>"))
                         (search ($ "<a href='' class='search-btn'>Search</a>")))
                     ($apply ($apply ($apply ($apply ($ "#photo-pane .search")
                                                 append cat)
                                         append subcat)
                                 append tags)
                         append search)
                     ;; cat-subcat change
                     (let ((cat nil)
                           (ele nil))
                       (dolist (ct category-tree)
                         (setf cat (elt ct 0))
                         (setf ele ($apply ($apply ($ "<option></option>")
                                                     'val
                                                   (+ "" (@ cat id)))
                                             text
                                           (@ cat name)))
                         ($apply ($ "#photo-pane .search .cat") append ele)))
                     ($event ("#photo-pane .search .cat" change) (article-change-category "#photo-pane .search"))
                     ;; tags
                     (tags-autocomplete ($ "#photo-pane .search .tags"))
                     ;; search
                     ($event ("#photo-pane .search a.search-btn" click)
                       (select-photo-call select-photo-who (elt select-photo-next-page select-photo-who)))))

                 (select-photo-call (who page)
                   (when (< page 0)
                     return)
                   ($prevent-default)
                   (setf select-photo-who who)
                   ($apply ($apply ($apply $
                                       ajax
                                     (create :url (+ "/ajax/photos/"
                                                     who
                                                     "/"
                                                     page
                                                     "/?cat="
                                                     ($apply ($ "#photo-pane .search .cat") val)
                                                     "&subcat="
                                                     ($apply ($ "#photo-pane .search .subcat") val)
                                                     "&tags="
                                                     ($apply ($ "#photo-pane .search .tags") val))
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
                       (progn (when select-photo-paginate
                                (if (= select-photo-pagination-direction "prev")
                                    (setf (elt select-photo-next-page select-photo-who)
                                          (1- (elt select-photo-next-page select-photo-who)))
                                    (setf (elt select-photo-next-page select-photo-who)
                                          (1+ (elt select-photo-next-page select-photo-who))))
                                (setf select-photo-paginate false))
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
                   (setf select-photo-paginate true)
                   (select-photo-call select-photo-who (- (elt select-photo-next-page select-photo-who) 2)))

                 (select-photo-pagination-next ()
                   ($prevent-default)
                   (setf select-photo-pagination-direction "next")
                   (setf select-photo-paginate true)
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
                         ($event ("#photo-pane form" submit) (upload-photo-submit))
                         ($event ("#photo-pane .cat" change) (article-change-category "#photo-pane"))
                         (tags-autocomplete ($ "#photo-pane .tags"))
                         false)
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
                       (photo-fail data)))

                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 ;;; tags autocomplete ; http://jqueryui.com/demos/autocomplete/#multiple-remote
                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 (tags-autocomplete (tags-input)
                   ($apply ($apply tags-input
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
                   false))))

        ;; define event handlers
        ($event (".cat" change) (article-change-category ""))
        ($event ("#select-photo" click) (select-photo-init))
        ($event ("#upload-photo" click) (upload-photo-init))
        (tags-autocomplete ($ ".tags"))



        ;; call functions on document.ready
        false)))
