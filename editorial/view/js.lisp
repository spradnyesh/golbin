(in-package :hawksbill.golbin.editorial)

(import-macros-from-lisp '$event)
(import-macros-from-lisp '$apply)
(import-macros-from-lisp '$prevent-default)
(import-macros-from-lisp '$log)

(defun on-load ()
  (ps ($event (document ready)
        ;; define variables
        (let ((select-photo-who "all")
              (select-photo-next-page (create "all" 0 "me" 0))
              (select-photo-pagination-direction "next")
              ;; flag to decide whether select-photo-next-page should be incremented or not
              (select-photo-paginate false)
              ;; flag to decide whether we're dealing w/ (non-)lead photo
              (lead false))
          ;; define functions
          (flet (
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; utility functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 (split (val)
                   ($apply val split (regex "/,\\s*/")))

                 (extract-last (term)
                   ($apply ((@ split) term) pop))

                 (ajax-fail (jq-x-h-r text-status error-thrown)
                   ;; ajax call itself failed
                   (if (= text-status "parseerror")
                       (alert "Received an invalid response from server. Please try again after some time.") ; TODO: translate
                       (alert "Network error"))
                   false)

                 ;; http://stackoverflow.com/a/8764051
                 (get-url-parameter (name)
                   (or (decode-u-r-i-component ((@ (elt (or ((@ (new (-reg-exp (+ "[?|&]" name "=" "([^&;]+?)(&|#|;|$)"))) exec) (@ location search)) (array null "")) 1) replace) (regex "/\\+/g") "%20")) null))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; forms
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 ;; submit form using ajax
                 (submit-form-ajax (form)
                   ($apply ($ form) attr "action" (+ "/ajax" ($apply ($ form) attr "action"))))

                 ;; email submit
                 (form-submit (event form)
                   ($prevent-default)
                   ;; TODO: client side error handling
                   ($apply ($ form) ajax-submit
                     ;; http://api.jquery.com/jQuery.ajax/
                     (create :data-type "json"
                             :cache false
                             :async false
                             :success (lambda (data text-status jq-x-h-r)
                                        (form-submit-done data text-status jq-x-h-r))
                             :error (lambda (jq-x-h-r text-status error-thrown)
                                      (ajax-fail jq-x-h-r text-status error-thrown)))))

                 (form-submit-done (data text-status jq-x-h-r)
                   (if (= data.status "success")
                       ;; this is the redirect after POST
                       (setf window.location data.data)
                       (form-fail data)))

                 (form-fail (data)
                   ;; TODO: translate
                   (alert "There are errors in the submitted email. Please correct them and submit again."))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; navigation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 (update-subcategory (event)
                   ($prevent-default)
                   ($apply ($ (aref ($apply ($ (@ event target parent-node))
                                        children
                                      "ul")
                                    0))
                       css
                     "display" "block"))
                 (restore-subcategory (event)
                   ($prevent-default)
                   (let* ((target (@ event target))
                          (node-name (@ target node-name))
                          (node (cond ((= node-name "LI")
                                       ($ (@ target parent-node)))
                                      ((= node-name "H2")
                                       (aref ($apply ($ (@ target parent-node))
                                                 children
                                               "ul")
                                             0))
                                      ((= node-name "H3")
                                       ($ (@ target parent-node parent-node)))
                                      ((= node-name "A")
                                       ($ (@ target parent-node parent-node parent-node))))))
                     ($apply ($ node)
                         css
                       "display" "none")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; registration page
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 ;; submit form using ajax
                 (submit-register-ajax ()
                   ($apply ($ "#register form")
                       attr
                     "action"
                     (+ "/ajax" ($apply ($ "#register form") attr "action"))))

                 ;; register submit
                 (register-submit (event)
                   ($prevent-default)
                   ;; TODO: client side error handling
                   ($apply ($ "#register form") ajax-submit
                     ;; http://api.jquery.com/jQuery.ajax/
                     (create :data-type "json"
                             :cache false
                             :async false
                             :success (lambda (data text-status jq-x-h-r)
                                        (register-submit-done data text-status jq-x-h-r))
                             :error (lambda (jq-x-h-r text-status error-thrown)
                                      (ajax-fail jq-x-h-r text-status error-thrown)))))

                 (register-submit-done (data text-status jq-x-h-r)
                   (if (= data.status "success")
                       ;; this is the redirect after POST
                       (setf window.location data.data)
                       (register-fail data)))

                 (register-fail (data)
                   (when (/= nil (@ data errors non-golbin-images))
                     ($apply ($apply ($ "#body") parent)
                         append
                       ($ "<p class='error'>Body contains images not hosted on Golbin. Please upload your images to Golbin first, and then use them inside the body</p>")))
                   ;; TODO: translate
                   (alert "There are errors in the submitted register. Please correct them and submit again."))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; common to article/photo pages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 ;; tags autocomplete
                 ;; http://jqueryui.com/demos/autocomplete/#multiple-remote
                 (tags-autocomplete (tags-input)
                   ($apply ($apply tags-input
                               bind "keydown"
                               (lambda (event)
                                 (when (and (eql (@ event key-code)
                                                 (@ (@ (@ $ ui) key-code) "TAB"))
                                            (@ (@ ($apply ($ this) data "autocomplete") menu) active)))))
                       autocomplete
                     (create :min-length 2
                             :source (lambda (request response)
                                       ($apply $ ajax
                                         (create :url (+ "/ajax/tags/?d1m=" (get-url-parameter "d1m"))
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
                                         (setf (@ this value) ($apply terms join ", ")))))))

                 ;; change sub-category when user changes category
                 (change-category (event form-prefix)
                   ($prevent-default)
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
;;; article page
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 ;; submit form using ajax
                 (submit-article-ajax ()
                   ($apply ($ "#article form")
                       attr
                     "action"
                     (+ "/ajax" ($apply ($ "#article form") attr "action"))))

                 ;; article submit
                 (article-submit (event)
                   ($prevent-default)
                   ;; http://stackoverflow.com/a/1903820
                   ($apply (@ -c-k-e-d-i-t-o-r instances editor1) update-element)
                   ;; TODO: client side error handling
                   ($apply ($ "#article form") ajax-submit
                     ;; http://api.jquery.com/jQuery.ajax/
                     (create :data-type "json"
                             :cache false
                             :async false
                             :success (lambda (data text-status jq-x-h-r)
                                        (article-submit-done data text-status jq-x-h-r))
                             :error (lambda (jq-x-h-r text-status error-thrown)
                                      (ajax-fail jq-x-h-r text-status error-thrown)))))

                 (article-submit-done (data text-status jq-x-h-r)
                   (if (= data.status "success")
                       ;; this is the redirect after POST
                       (setf window.location data.data)
                       (article-fail data)))

                 (article-fail (data)
                   (when (/= nil (@ data errors non-golbin-images))
                     ($apply ($apply ($ "#body") parent)
                         append
                       ($ "<p class='error'>Body contains images not hosted on Golbin. Please upload your images to Golbin first, and then use them inside the body</p>")))
                   ;; TODO: translate
                   (alert "There are errors in the submitted article. Please correct them and submit again."))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; photo pane/page
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 ;; common for select/upload photo pane
                 (create-photo-pane ()
                   ($apply ($ "#bd")
                       append
                     ($ "<div id='photo-pane'><p><a class='close' href=''>Close</a></p><ul></ul></div>"))
                   ($event ("#photo-pane a.close" click) (close-photo-pane event)))

                 (photo-fail (data)
                   ;; TODO: clear loading icon
                   ;; TODO: show error message
                   (setf select-photo-paginate false)
                   false)

                 (close-photo-pane (event)
                   ($prevent-default)
                   ((@ ($ "#photo-pane") remove)))

                 (nonlead-photo-url (event)
                   ($prevent-default)
                   (alert (+ "Please copy this URL and use it for inline images in the article body below: "
                             ((@ ((@ ($ ($ (@ event target))) attr) "src")
                                 replace)
                              (+ "_" (elt image-sizes 0) ".")
                              (+ "_" (elt image-sizes 1) ".")))))

                 ;; select photo pane
                 (unselect-lead-photo (event)
                   ($prevent-default)
                   ;; change the photo-id in hidden-field
                   ($apply ($ "#lead-photo") val "")
                   ;; remove img tag
                   ($apply ($apply ($apply ($ "#lead-photo") siblings "span") children "img") remove)
                   ;; remove 'unselect' link
                   ($apply ($ "#unselect-lead-photo") remove))
                 (select-lead-photo-init (event)
                   (setf lead true)
                   (select-photo-init event))
                 (select-nonlead-photo-init (event)
                   (setf lead false)
                   (select-photo-init event))
                 (select-photo-init (event)
                   ($prevent-default)
                   (create-photo-pane)
                   ($apply ($ "#photo-pane") append ($ "<div class='pagination'><a href='' class='prev'>Previous</a><a href='' class='next'>Next</a></div>"))
                   ($apply ($ "#photo-pane p") prepend ($ "<div class='search'></div>"))
                   ;; TODO: show loading icon
                   (select-photo-add-all-my-tabs)
                   (select-search-markup)
                   (select-photo-call event "all" 0)
                   ($event ("#photo-pane .pagination a.prev" click) (select-photo-pagination-prev event))
                   ($event ("#photo-pane .pagination a.next" click) (select-photo-pagination-next event)))

                 (select-photo-add-all-my-tabs ()
                   ($apply ($ "#photo-pane p") prepend ($ "<span>Photos<a class='all-photos' href=''> All </a><a class='my-photos' href=''> My </a></span>"))
                   ($event ("#photo-pane a.all-photos" click) (select-photo-call event "all" 0))
                   ($event ("#photo-pane a.my-photos" click) (select-photo-call event "me" 0)))

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
                     ($event ("#photo-pane .search .cat" change) (change-category "#photo-pane .search"))
                     ;; tags
                     #|(tags-autocomplete ($ "#photo-pane .search .tags"))|#
                     ;; search
                     ($event ("#photo-pane .search a.search-btn" click)
                       (select-photo-call event select-photo-who (elt select-photo-next-page select-photo-who)))))

                 (select-photo-call (event who page)
                   ($prevent-default)
                   (when (< page 0)
                     (return-from select-photo-call false))
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
                                                     ($apply ($ "#photo-pane .search .tags") val)
                                                     "&d1m=" (get-url-parameter "d1m"))
                                             :cache false
                                             :async false
                                             :data-type "json"))
                               done
                             (lambda (data) (select-photo-done data)))
                       fail
                     (lambda (data) (photo-fail data))))

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
                                  ($event (a click) (select-photo event))
                                  ($apply ($ "#photo-pane ul")
                                      append
                                    ($apply ($apply ($apply ($ "<li></li>")
                                                        append id)
                                                append a)
                                        append title)))))
                       (photo-fail data)))

                 (select-photo (event)
                   ($prevent-default)
                   (let ((target-img ($ (@ event target))))
                     (if lead
                         (progn
                           ;; change the photo-id in hidden-field
                           ($apply ($ "#lead-photo")
                               val
                             ($apply ($apply ($apply target-img
                                                 parent)
                                         siblings "span")
                                 html))
                           (let ((span ($apply ($ "#lead-photo") siblings "span")))
                             ;; add photo thumb in 'span'
                             ($apply span html target-img)
                             ;; add 'unselect' link in 'span'
                             ($apply span append ($ "<a id='unselect-lead-photo' href=''>Unselect photo. </a>"))
                             ($event ("#unselect-lead-photo" click) (unselect-lead-photo event))))
                         (progn
                           (let ((a-target ((@ ($ "<a href=''></a>") append) target-img)))
                             ;; append photo to list of nonlead photos
                             ($apply ($apply ($ "#nonlead-photo") siblings "span") append a-target)
                             ;; add-event so that when image is clicked, we show a popoup w/ url for copying
                             ($event (a-target click) (nonlead-photo-url event))))))
                   (close-photo-pane nil))

                 (select-photo-pagination-prev (event)
                   ($prevent-default)
                   (setf select-photo-pagination-direction "prev")
                   (setf select-photo-paginate true)
                   (select-photo-call select-photo-who (- (elt select-photo-next-page select-photo-who) 2)))

                 (select-photo-pagination-next (event)
                   ($prevent-default)
                   (setf select-photo-pagination-direction "next")
                   (setf select-photo-paginate true)
                   (select-photo-call select-photo-who (elt select-photo-next-page select-photo-who)))

                 ;; upload photo pane
                 (upload-lead-photo-init (event)
                   (setf lead true)
                   (upload-photo-init event))
                 (upload-nonlead-photo-init (event)
                   (setf lead false)
                   (upload-photo-init event))
                 (upload-photo-init (event)
                   ($prevent-default)
                   (create-photo-pane)
                   ($apply ($ "#photo-pane ul") remove)
                   ;; TODO: show loading icon
                   (upload-photo-call))

                 (upload-photo-call ()
                   ($apply ($apply ($apply $
                                       ajax
                                     (create :url (+ "/ajax/photo/?d1m=" (get-url-parameter "d1m"))
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
                         ($event ("#photo-pane form" submit) (upload-photo-submit event))
                         ($event ("#photo-pane .cat" change) (change-category event "#photo-pane"))
                         #- (and)
                         (tags-autocomplete ($ "#photo-pane .tags")))
                       (photo-fail data)))

                 (upload-photo-submit (event)
                   ($prevent-default)
                   ;; TODO: client side error handling
                   ($apply ($ "#photo-pane form") ajax-submit
                     (create :data-type "json"
                             :async false
                             :success (lambda (data text-status jq-x-h-r)
                                        (upload-photo-submit-done data text-status jq-x-h-r))
                             :error (lambda (jq-x-h-r text-status error-thrown)
                                      (ajax-fail jq-x-h-r text-status error-thrown)))))

                 (upload-photo-submit-done (data text-status jq-x-h-r)
                   (if (= data.status "success")
                       (if lead
                           (progn
                             ;; change the photo-id in hidden-field
                             ($apply ($ "#lead-photo")
                                 val
                               (elt data.data 0))
                             ;; change the photo url
                             ($apply ($apply ($ "#lead-photo") siblings "span") html (elt data.data 1)))
                           (progn
                             (let ((a-target ((@ ($ "<a href=''></a>") append) ($ (elt data.data 1)))))
                               ;; append photo to list of nonlead photos
                               ($apply ($apply ($ "#nonlead-photo") siblings "span") append a-target)
                               ;; add-event so that when image is clicked, we show a popoup w/ url for copying
                               ($event (a-target click) (nonlead-photo-url event)))))
                       (photo-fail data))
                   (close-photo-pane nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; category page
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 #- (and)
                 (sort-categories (ele)
                   ($apply ele nested-sortable (create :handle "div"
                                                       :items "li"
                                                       :toleranceElement "> div"
                                                       :maxLevels 1
                                                       :protectRoot t))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; event handling
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;; define event handlers
        ((@ ($ ".prinav" ) hover)
           (lambda (event) (update-subcategory event))
           (lambda (event) (restore-subcategory event)))
        ($event (".cat" change) (change-category event ""))
        ($event ("#register form" submit) (register-submit event))
        ($event ("#article form" submit) (article-submit event))
        ($event ("#accounts form" submit) (form-submit event "#accounts form"))
        ($event ("#select-lead-photo" click) (select-lead-photo-init event))
        ($event ("#unselect-lead-photo" click) (unselect-lead-photo event))
        ($event ("#upload-lead-photo" click) (upload-lead-photo-init event))
        ($event ("#select-nonlead-photo" click) (select-nonlead-photo-init event))
        ($event ("#upload-nonlead-photo" click) (upload-nonlead-photo-init event))

        ;; some init functions
        (submit-article-ajax)
        (submit-register-ajax)

        #|(tags-autocomplete ($ ".tags"))|#
        #|(sort-categories ($ "#sort-catsubcat"))|#)))
