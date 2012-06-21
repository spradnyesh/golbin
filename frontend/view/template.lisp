(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page template
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro page-template (title popular-articles &body content)
  `(with-html
     (:html
      (:head
       (:title (str (format nil "~A - ~A" *site-name* ,title)))
       (:link :rel "stylesheet" :type "text/css" :href "/static/yui3-reset-fonts-grids-min.css")
       (:style :type "text/css"
               (str (get-css))))
      (:body
       (:div :class "yui3-g"
            (:div :id "hd"
                  (str (header)))
            (:div :id "bd"
                  (:div :class "yui3-u-3-4"
                        (:div :id "col-1" :class "yui3-u-1-5"
                              (str ,popular-articles)
                              (str (ads-1)))
                        (:div :id "col-2" :class "yui3-u-4-5"
                              ,@content))
                  (:div :id "col-3" :class "yui3-u-1-4"
                        (str (ads-2))))
            (:div :id "ft"
                  (str (footer))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page header
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun logo ()
  (with-html
    (:h1
     (:a :href (genurl 'route-home)
         (:img :id "logo"
               :source ""
               :alt *site-name*)))))

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

(defun navigation ()
  (with-html
    (:ul :id "nav"
         (:li :id "nav-home"
              (:h2 (:a :href (genurl 'route-home) "Home")))
         (:li :id "nav-cats"
              (:h2 (:p "Categories"))
              (:ul (str (nav-categories-markup))))
         (:li :id "nav-tags"
              (:h2 (:p "Tags"))
              (:ul (str (nav-tags-markup))))
         (:li :id "nav-authors"
              (:h2 (:p "Authors"))
              (:ul (str (nav-authors-markup)))))))

(defun header ()
  (with-html
    (:div :id "banner"
          (str (logo))
          (str (site-search)))
          #|(str (trending))|#
    (str (navigation))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page footer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun footer ()
  (with-html "This is the footer"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ads
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ads-1 ()
  (with-html
    (:div :id "ads-1" "These are ads-1")))

(defun ads-2 ()
  (with-html
    (:div :id "ads-2""These are ads-2")))
