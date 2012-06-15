(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro nav- (list class route-name route-param field)
  `(with-html
    (:ul
     (dolist (l ,list)
       (htm
        (:li :class ,class
             (:a :href (genurl ',route-name
                               ,route-param (,field l))
                 (str (name l)))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page template
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro page-template (title popular-articles &body content)
  `(with-html
     (:html
      (:head
       (:title (str (format nil "~A - ~A" *site-name* ,title)))
       (:script :type "text/javascript"
                (str (format nil "var nav-categories = ~A;" (nav-categories-json)))))
      (:body
       (str (header))
       (:div :id "bd"
             (:div :id "col-1"
                   (str ,popular-articles)
                   (str (ads-1)))
             (:div :id "col-2"
                   ,@content)
             (:div :id "col-3"
                   (str (ads-2))))
       (str (footer))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun latest-articles-markup (&key (offset 0) (category (most-popular-categories)))
  (declare (ignore offset))
  (latest-articles category))

(defun most-popular-articles-markup (&key (offset 0) (category (most-popular-categories)))
  (declare (ignore offset))
  (most-popular-articles category))

(defun pagination-low (page-number)
  "page number can be 0 at minimum"
  (let ((p (- page-number (/ *article-pagination-limit* 2)))
        (min 0))
    (if (< p min)
        min
        p)))
(defun pagination-high (page-number max-results)
  "page number can be (/ max-results *article-pagination-limit*) at maximum"
  (let ((p (+ page-number (/ *article-pagination-limit* 2)))
        (max (/ max-results *article-pagination-limit*)))
    (if (> p max)
        max
        p)))
(defun pagination-markup (route page-number max-results)
  "build URLs b/n route?p=low and route?p=high"
  ;; don't show pagination-markup when page-number = 13, *article-pagination-limit* = 10 and max-results = 100 ;)
  (if (< (* page-number *article-pagination-limit*) max-results)
      (with-html
        (:ul
         (loop for i
            from (pagination-low page-number) to (pagination-high page-number max-results) do
            (if (eql page-number i)
                (htm (:li :id "pagination-match" (str i)))
                (htm (:li (:a :href (genurl route :page i) (str i))))))))
      ""))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page header
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun logo ()
  (with-html
    (:img :id "logo"
          :source ""
          :alt "logo")))

(defun site-search ()
  #|(with-html
    (:form :method "GET"
           :action (genurl 'route-search)
           :name "search"
           :id "search"
           (:input :type "input"
                   :name "q"
                   :value "Search")
           (:input :type "submit"
                   :value "Submit")))|#)

(defun trending ()
  (with-html
    (:div :id "trending-tags")))

(defun nav-categories-json ()
  (let ((rslt nil))
    (dolist (cat-node (get-category-tree *category-storage*))
      (let* ((cat (first cat-node))
             (subcat-node (second cat-node))
             (c-node nil))
        (push (make-instance 'navigation-node
                             :name (name cat)
                             :url (slug cat)#|(genurl 'route-cat
                                          :cat (slug cat))|#)
              c-node)
        (dolist (subcat subcat-node)
          (when (status subcat)     ; show only enabled sub-categories
            (let ((s-node (make-instance 'navigation-node
                                         :name (name subcat)
                                         :url (slug subcat)#|(genurl 'route-cat-subcat
                                                      :cat (slug cat)
                                                      :subcat (slug subcat))|#)))
              (push s-node c-node))))
        (push (nreverse c-node) rslt)))
    (encode-json-to-string (nreverse rslt))))

(defun nav-tags ()
  (nav- (get-all-tags *tag-storage*) "tag" route-tag :tag slug))

(defun nav-authors ()
  (nav- (get-all-authors *author-storage*) "author" route-author :author handle))

(defun navigation ()
  (with-html
    (:ul :id "nav"
         (:li :id "nav-home"
              (:a :href (genurl 'route-home) "Home"))
         (:li :id "cat"
              (:p "Categories"))
         (:li  :id "tags"
               (:p "Tags")
              (str (nav-tags)))
         (:li :id "authors"
              (:p "Authors")
              (str (nav-authors))))))

(defun header ()
  (with-html
    (:div :id "hd"
          (:div :id "banner"
                (str (logo))
                (str (site-search)))
          (str (trending))
          (str (navigation)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page footer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun footer ()
  (with-html
    (:div :id "ft")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ads
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ads-1 ()
  (with-html
    (:div :id "ads-1")))

(defun ads-2 ()
  (with-html
    (:div :id "ads-2")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; views
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun view-article (slug-and-id)
  (let* ((id (first (split-sequence:split-sequence "-" slug-and-id :from-end t :test #'string-equal :count 1)))
         (article (get-article-by-id (parse-integer id) *article-storage*)))
    (page-template
        (title article)
        (most-popular-articles-markup :category (cat article))
      (:div (:p :id "a-title" (str (title article)))
            (:p :id "a-date" (str (date article)))
            (:p :id "a-body" (str (body article)))))))

(defun view-home (&optional (page "0"))
  (let* ((page (parse-integer page))
         (offset (* page *article-pagination-limit*)))
    (page-template
        "Home"
        (most-popular-articles-markup)
      (htm
       (:div :id "articles"
             (:ul
              (dolist (article (paginate (get-all-articles *article-storage*)
                                         :offset offset
                                         :limit *article-pagination-limit*))
                (htm
                 (:li
                  (:a :class "a-title"
                      :href (genurl 'route-article
                                    :slug-and-id (format nil "~A-~A"
                                                         (slug article)
                                                         (id article)))
                      (str (title article)))
                  (:p :class "a-date" (str (date article)))
                  (:p :class "a-summary" (str (summary article))))))))
       (str (pagination-markup 'route-home-page
                               page
                               (count-articles *article-storage*)))))))

(defun view-cat (cat &optional (page "0"))
  (declare (ignore cat page)))

(defun view-cat-subcat (cat subcat &optional (page "0"))
  (declare (ignore cat subcat page)))

(defun view-author (author &optional (page "0"))
  (declare (ignore author page)))

(defun view-tag (tag &optional (page "0"))
  (declare (ignore tag page)))

(defun view-search ())
