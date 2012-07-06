(in-package :hawksbill.golbin)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page template
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro fe-page-template (title popular-articles &body content)
  `(with-html
     (:html
      (:head
       (:title (str (format nil "~A - ~A" *site-name* ,title)))
       (:link :rel "stylesheet" :type "text/css" :href "/static/css/yui3-reset-fonts-grids-min.css")
       (:style :type "text/css"
               (str (fe-get-css))))
      (:body
       (:div :class "yui3-g"
            (:div :id "hd"
                  (str (fe-header)))
            (:div :id "bd"
                  (:div :class "yui3-u-3-4"
                        (:div :id "col-1" :class "yui3-u-1-5"
                              (str ,popular-articles)
                              (str (fe-ads-1)))
                        (:div :id "col-2" :class "yui3-u-4-5"
                              ,@content))
                  (:div :id "col-3" :class "yui3-u-1-4"
                        (str (fe-ads-2))))
            (:div :id "ft"
                  (str (fe-footer))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page header
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun fe-logo ()
  (with-html
    (:h1
     (:a :href (genurl 'fe-r-home)
         (:img :id "logo"
               :source ""
               :alt *site-name*)))))

(defun fe-site-search ()
  #|(with-html
    (:form :method "GET"
           :action (genurl 'fe-r-search)
           :name "search"
           :id "search"
           (:input :type "input"
                   :name "q"
                   :value "Search")
           (:input :type "submit"
                   :value "Submit")))|#)

(defun fe-trending ()
  (with-html
    (:div :id "trending-tags")))

(defun fe-navigation ()
  (with-html
    (:ul :id "nav"
         (:li :id "nav-home"
              (:h2 (:a :href (genurl 'fe-r-home) "Home")))
         (:li :id "nav-cats"
              (:h2 (:p "Categories"))
              (:ul (str (fe-nav-categories-markup))))
         (:li :id "nav-tags"
              (:h2 (:p "Tags"))
              (:ul (str (fe-nav-tags-markup))))
         (:li :id "nav-authors"
              (:h2 (:p "Authors"))
              (:ul (str (fe-nav-authors-markup)))))))

(defun fe-header ()
  (with-html
    (:div :id "banner"
          (str (fe-logo))
          (str (fe-site-search)))
          #|(str (trending))|#
    (str (fe-navigation))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page footer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun fe-footer ()
  (with-html "This is the footer"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ads
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun fe-ads-1 ()
  (with-html
    (:div :id "ads-1" "These are ads-1")))

(defun fe-ads-2 ()
  (with-html
    (:div :id "ads-2""These are ads-2")))
