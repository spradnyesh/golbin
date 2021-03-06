(in-package :hawksbill.golbin.editorial)

(import-macros-from-lisp '$event)
(import-macros-from-lisp '$apply)
(import-macros-from-lisp '$prevent-default)
(import-macros-from-lisp '$log)
(import-macros-from-lisp '$ajax-form)
(import-macros-from-lisp '$pane)

(defun on-load ()
  (ps ($event (document ready)
        ;; define variables
        (let ((select-photo-who "all")
              (select-photo-next-page (create "all" 0 "me" 0))
              (select-photo-pagination-direction "next")
              ;; flag to decide whether select-photo-next-page should be incremented or not
              (select-photo-paginate false)
              ;; flag to decide whether we're dealing w/ lead/non-lead/background photo
              (photo-type nil))
          ($pane
            ($ajax-form
              ;; define functions
              (flet (
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; utility functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                     (split (val)
                       ($apply val split (regex "/,\\s*/")))

                     (extract-last (term)
                       ($apply ((@ split) term) pop))

                     ;; http://stackoverflow.com/a/8764051
                     (get-url-parameter (name)
                       (or (decode-u-r-i-component ((@ (elt (or ((@ (new (-reg-exp (+ "[?|&]" name "=" "([^&;]+?)(&|;|$)"))) exec) (@ location search)) (array null "")) 1) replace) (regex "/\\+/g") "%20")) null))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; calendar tool to publish article in future
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                     (show-calendar (event element)
                       (new (-js-date-pick (create "useMode" 2
                                                   :target element
                                                   "dateFormat" "%d-%m-%Y"
                                                   "imgPath" "/static/css/img/"))))

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
;;; photo pane/page
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                     ;; common for select/upload photo pane
                     (photo-fail (data)
                       ;; TODO: clear loading icon
                       ;; TODO: show error message
                       (setf select-photo-paginate false)
                       false)

                     (nonlead-photo-url (event)
                       ($prevent-default)
                       (alert (+ "Please copy this URL and use it for inline images in the article body below: "
                                 ((@ ((@ ($ ($ (@ event target))) attr) "src")
                                     replace)
                                  (+ "_" (elt image-sizes 0) ".")
                                  (+ "_" (elt image-sizes 1) ".")))))

                     ;; select photo pane
                     (unselect-photo (event target parent)
                       ($prevent-default)
                       ;; change the photo-id in hidden-field
                       ($apply target val "")
                       (let ((spans ($apply target siblings "span")))
                         ;; remove img tag
                         ($apply ($apply ($ (elt spans 0)) children) remove)
                         ;; unhide "select/upload photo"
                         ($apply ($ (elt spans 1)) remove-class "hidden"))
                       ;; remove 'unselect' link
                       ($apply parent remove))
                     (unselect-lead-photo (event)
                       (unselect-photo event ($ "#lead-photo") ($ "#unselect-lead-photo")))
                     (unselect-background (event)
                       (unselect-photo event ($ "#background") ($ "#unselect-background")))
                     (select-lead-photo-init (event)
                       (setf photo-type "lead-photo")
                       (select-photo-init event))
                     (select-nonlead-photo-init (event)
                       (setf photo-type "non-lead")
                       (select-photo-init event))
                     (select-background-init (event)
                       (setf photo-type "background")
                       (select-photo-init event))
                     (select-photo-init (event)
                       ($prevent-default)
                       (create-pane "pane")
                       ($apply ($ "#pane")
                           append
                         ($ "
<div class='pagination'>
  <a href='' class='prev'>Previous</a>
  <a href='' class='next'>Next</a>
</div>"))
                       ;; TODO: show loading icon
                       (select-photo-add-all-my-tabs)
                       (select-search-markup)
                       (select-photo-call event "all" 0)
                       ($event ("#pane .pagination a.prev" click) (select-photo-pagination-prev event))
                       ($event ("#pane .pagination a.next" click) (select-photo-pagination-next event)))

                     (select-photo-add-all-my-tabs ()
                       ($apply ($ "#pane .message")
                           prepend
                         ($ "
<span>Photos
  <a class='all-photos' href=''> All </a>
  <a class='my-photos' href=''> My </a>
</span>"))
                       ($event ("#pane a.all-photos" click) (select-photo-call event "all" 0))
                       ($event ("#pane a.my-photos" click) (select-photo-call event "me" 0)))

                     (select-search-markup ()
                       (let ((cat ($ "
<select name='cat' class='td-input cat'>
  <option selected='selected' value='0'>Select</option>
</select>"))
                             (subcat ($ "
<select name='subcat' class='td-input subcat'>
  <option selected='selected' value='0'>Select</option>
</select>"))
                             (tags ($ "<span>tags</span><input class='td-input tags' type='text'>"))
                             (search ($ "<a href='' class='search-btn'>Search</a>")))
                         ($apply ($ "#pane .message") prepend ($ "<div class='search'></div>"))
                         ($apply ($apply ($apply ($apply ($ "#pane .search")
                                                     append cat)
                                             append subcat)
                                     append tags)
                             append search)
                         ($apply ($ "#pane .message") append ($ "<ul class='photo'></ul>"))
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
                             ($apply ($ "#pane .search .cat") append ele)))
                         ($event ("#pane .search .cat" change) (change-category nil "#pane .search"))
                         ;; tags
                         #|(tags-autocomplete ($ "#pane .search .tags"))|#
                         ;; search
                         ($event ("#pane .search a.search-btn" click)
                           (select-photo-call event
                                              select-photo-who
                                              (elt select-photo-next-page select-photo-who)))))

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
                                                         ($apply ($ "#pane .search .cat") val)
                                                         "&subcat="
                                                         ($apply ($ "#pane .search .subcat") val)
                                                         "&tags="
                                                         ($apply ($ "#pane .search .tags") val)
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
                                  ($apply ($ "#pane ul") empty)
                                  (dolist (d data.data)
                                    (let* ((id ((@ ($ "<span></span>") html) (elt d 0)))
                                           (img ($ (elt d 1)))
                                           (title ((@ ($ "<p></p>") append) ((@ ($ img) attr) "alt")))
                                           (a ($apply ($ "<a href=''></a>") append img)))
                                      ($event (a click) (select-photo event))
                                      ($apply ($ "#pane ul")
                                          append
                                        ($apply ($apply ($apply ($ "<li></li>")
                                                            append id)
                                                    append a)
                                            append title)))))
                           (photo-fail data)))
                     (add-unselect-photo (target-img)
                       (let* ((element ($ (+ "#" photo-type)))
                              (spans ($apply element siblings "span"))
                              (span-1 ($ (elt spans 0)))
                              (span-2 ($ (elt spans 1))))
                         ;; add photo thumb in 'span'
                         ($apply span-1 html target-img)
                         ;; add 'unselect' link in 'span'
                         ($apply span-1
                             append
                           ($ (+ "<a id='unselect-" photo-type "' href=''>Unselect photo. </a>")))
                         ($apply span-2 add-class "hidden")
                         (cond ((= photo-type "lead-photo")
                                ($event ("#unselect-lead-photo" click) (unselect-lead-photo event)))
                               ((= photo-type "background")
                                ($event ("#unselect-background" click) (unselect-background event))))))
                     (select-photo (event)
                       ($prevent-default)
                       (let ((target-img ($ (@ event target))))
                         (cond ((or (= photo-type "lead-photo")
                                    (= photo-type "background"))
                                (progn
                                  ;; change the photo-id in hidden-field
                                  ($apply ($ (+ "#" photo-type))
                                      val
                                    ($apply ($apply ($apply target-img
                                                        parent)
                                                siblings "span")
                                        html))
                                  (add-unselect-photo target-img)))
                               ((= photo-type "non-lead")
                                (let ((a-target ((@ ($ "<a href=''></a>") append) target-img)))
                                  ;; append photo to list of nonlead photos
                                  ($apply ($apply ($ "#nonlead-photo") siblings "span") append a-target)
                                  ;; add-event so that when image is clicked, we show a popoup w/ url for copying
                                  ($event (a-target click) (nonlead-photo-url event))))))
                       (close-pane nil "pane"))

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

                     (upload-author-photo-init (event avatar-p)
                       ($prevent-default)
                       (create-pane "pane")
                       ($apply ($ "#pane .message")
                           append
                         (+ "<form action='/ajax/photo/author/"
                            (unless avatar-p
                              "background/")
                            "' method='POST' enctype='multipart/form-data'>
<table>
  <tr>
    <td class='label'><label for='photo'>Photo</label></td>
    <td><input type='file' name='photo' value=''/></td>
  </tr>
  <tr>
    <td></td>
    <td><input class='submit' name='submit' type='submit' value='Upload'/></td>
  </tr>
</table></form>"))
                       ($event ("#pane form" submit) (form-submit event "#pane form")))
                     (gravatar-author-photo-init (event)
                       ($prevent-default)
                       (create-pane "pane")
                       ($apply ($ "#pane .message")
                           append
                         "<form action='/ajax/photo/author/reset/' method='POST'></form>")
                       ($event ("#pane form" submit) (form-submit event "#pane form"))
                       ($apply ($ "#pane .message form") submit))

                     ;; upload photo pane
                     (upload-lead-photo-init (event)
                       (setf photo-type "lead-photo")
                       (upload-photo-init event))
                     (upload-nonlead-photo-init (event)
                       (setf photo-type "non-lead")
                       (upload-photo-init event))
                     (upload-background-init (event)
                       (setf photo-type "background")
                       (upload-photo-init event))
                     (upload-photo-init (event)
                       ($prevent-default)
                       (create-pane "pane")
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
                             ($apply ($ "#pane")
                                 append
                               data.data)
                             ($event ("#pane form" submit) (upload-photo-submit event))
                             ($event ("#pane .cat" change) (change-category event "#pane"))
                             #- (and)
                             (tags-autocomplete ($ "#pane .tags")))
                           (photo-fail data)))

                     (upload-photo-submit (event)
                       ($prevent-default)
                       ;; TODO: client side error handling
                       ($apply ($ "#pane form") ajax-submit
                         (create :data-type "json"
                                 :async false
                                 :success (lambda (data text-status jq-x-h-r)
                                            (upload-photo-submit-done data text-status jq-x-h-r))
                                 :error (lambda (jq-x-h-r text-status error-thrown)
                                          (ajax-fail jq-x-h-r text-status error-thrown)))))

                     (upload-photo-submit-done (data text-status jq-x-h-r)
                       (if (= data.status "success")
                           (cond ((or (= photo-type "lead-photo")
                                      (= photo-type "background"))
                                  (progn
                                    ;; change the photo-id in hidden-field
                                    ($apply ($ (+ "#" photo-type))
                                        val
                                      (elt data.data 0))
                                    (add-unselect-photo (elt data.data 1))))
                                 ((= photo-type "non-lead")
                                  (progn
                                    (let ((a-target ((@ ($ "<a href=''></a>") append) ($ (elt data.data 1)))))
                                      ;; append photo to list of nonlead photos
                                      ($apply ($apply ($ "#nonlead-photo") siblings "span") append a-target)
                                      ;; add-event so that when image is clicked, we show a popoup w/ url for copying
                                      ($event (a-target click) (nonlead-photo-url event))))))
                           (photo-fail data))
                       (close-pane nil "pane"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; category page
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                     #- (and)
                     (sort-categories (ele)
                       ($apply ele nested-sortable (create :handle "div"
                                                           :items "li"
                                                           :toleranceElement "> div"
                                                           :maxLevels 1
                                                           :protectRoot t))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; event handling
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;; some init functions
        (submit-form-ajax ".crud form")
        (submit-form-ajax "#article form")
        (submit-form-ajax "#accounts form")
        (submit-form-ajax "#register form")
        (submit-form-ajax "#login form")
        (when (and (not (undefined article))
                   (= article "true"))
          (show-calendar event "a-date"))

        ;; define event handlers
        ($event (".cat" change) (change-category event ""))
        ($event ("#select-lead-photo" click) (select-lead-photo-init event))
        ($event ("#unselect-lead-photo" click) (unselect-lead-photo event))
        ($event ("#upload-lead-photo" click) (upload-lead-photo-init event))
        ($event ("#select-background" click) (select-background-init event))
        ($event ("#unselect-background" click) (unselect-background event))
        ($event ("#upload-background" click) (upload-background-init event))
        ($event ("#select-nonlead-photo" click) (select-nonlead-photo-init event))
        ($event ("#upload-nonlead-photo" click) (upload-nonlead-photo-init event))
        ($event ("#upload-author-photo" click) (upload-author-photo-init event t))
        ($event ("#upload-author-background" click) (upload-author-photo-init event nil))
        ($event ("#gravatar-author-photo" click) (gravatar-author-photo-init event))
        ($event ("#article form" submit)
          ;; http://stackoverflow.com/a/1903820
          ($apply (@ -c-k-e-d-i-t-o-r instances body) update-element)
          (form-submit event "#article form"))
        ($event ("#article a.submit" click)
          ($prevent-default)
          ($apply ($ (@ event target next-sibling)) val "save")
          ($apply ($ "#article form") submit))
        ($event (".reject" click)
          ($prevent-default)
          (let* ((textarea ($apply ($ (@ event target)) next "textarea"))
                 (input ($apply textarea next "input")))
            ($apply ($ "#bd")
                append
              ($ (+ "
<div id='r-pane'>
  <p><textarea cols='60' rows='5'>Please enter reason for rejection here</textarea></p>
  <p><a href='#' class='submit'>Done</a></p>
</div>"))))
          ($event ("#r-pane a.submit" click)
            ($prevent-default)
            ($apply ($ textarea) text ($apply ($ "#r-pane textarea") val))
            ($apply ($ input) val "reject")
            ((@ ($ "#r-pane") remove))
            ($apply ($ ($apply textarea parent)) submit)))
        ($event (".crud form" submit) (form-submit event ".crud form"))
        ($event ("#login form" submit) (form-submit event "#login form"))
        ($event ("#register form" submit) (form-submit event "#register form"))
        ($event ("#accounts form" submit) (form-submit event "#accounts form"))

        #|(tags-autocomplete ($ ".tags"))|#
        #|(sort-categories ($ "#sort-catsubcat"))|#)))
