(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page template
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro fe-page-template (title &optional (js nil) &body content)
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
                              (str (fe-ads-1)))
                        (:div :id "col-2" :class "yui3-u-4-5"
                              ,@content))
                  (:div :id "col-3" :class "yui3-u-1-4"
                        (str (fe-ads-2))))
            (:div :id "ft"
                  (str (fe-footer))))
       (:script :type  "text/javascript" :src "http://code.jquery.com/jquery-1.7.2.min.js")
       (:script :type "text/javascript"
                  (str (on-load)))
       ,js))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page header
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun fe-logo ()
  (with-html
    (:h1
     (:a :href (genurl 'r-home)
         (:img :id "logo"
               :source ""
               :alt *site-name*)))))

(defun fe-site-search ()
  #|(with-html
    (:form :method "GET"
           :action (genurl 'r-search)
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
              (:h2 (:a :href (genurl 'r-home) "Home")))
         (str (fe-nav-categories-markup)))
    (:ul :id "subnav")))

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
