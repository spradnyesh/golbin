(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page template
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro ed-page-template (title &optional (js nil) &body body)
  `(with-html
     (:html
      (:head
       (:title (str (format nil "~A - ~A" (get-config "site.name") ,title)))
       (:link :rel "stylesheet" :type "text/css" :href "/static/css/yui3-reset-fonts-grids-min.css")
       (:style :type "text/css"
               (str (ed-get-css))))
      (:body
       (:div :class "yui3-g"
            (:div :id "hd"
                  (str (ed-header)))
            (:div :id "bd"
                  (:div ,@body))
            (:div :id "ft"
                  (str (ed-footer))))
       (:script :type  "text/javascript" :src "http://code.jquery.com/jquery-1.7.2.min.js")
       ,js))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page header
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ed-logo ()
  (with-html
    (:h1
     (:a :href (genurl 'r-home)
         (:img :id "logo"
               :source ""
               :alt (get-config "site.name"))))))

(defun ed-site-search ()
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

(defun ed-navigation ()
  (with-html
    (:ul :id "nav"
         (:li :id "nav-home"
              (:h2 (:a :href (genurl 'r-home) "Home"))))))

(defun ed-header ()
  (with-html
    (:div :id "banner"
          (str (ed-logo))
          (str (ed-site-search)))
    (str (ed-navigation))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page footer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ed-footer ()
  (with-html "This is the footer"))
