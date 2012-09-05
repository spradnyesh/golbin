(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page template
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro ed-page-template (title logged-in js &body body)
  `(with-html
     (:html
      (:head
       (:meta :charset "UTF-8") ; http://www.w3.org/TR/html5-diff/#character-encoding
       (:title (str (format nil "~A - ~A" (get-config "site.name") ,title)))
       (:link :rel "stylesheet" :type "text/css" :href "/static/css/yui3-reset-fonts-grids-min.css")
       (:style :type "text/css"
               (str (ed-get-css))))
      (:body
       (:div :class "yui3-g"
            (:div :id "hd"
                  (str (ed-header ,logged-in)))
            (:div :id "bd"
                  (:div ,@body))
            (:div :id "ft"
                  (str (ed-footer))))
       (:script :type  "text/javascript" :src "http://code.jquery.com/jquery-1.7.2.min.js")
       (:script :type  "text/javascript" :src "http://malsup.github.com/jquery.form.js")
       (:script :type  "text/javascript" :src "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js")
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

(defun ed-navigation (logged-in)
  (with-html
    (:ul :id "nav"
         (:li :id "nav-home"
              (:h2 (:a :href (genurl 'r-home) "Home")))
         (when logged-in
           (htm (:li :id "nav-article"
                     (:h2 (:a :href (genurl 'r-article-new-get) "Add Article")))
                (:li :id "nav-photo"
                     (:h2 (:a :href (genurl 'r-photo-get) "Add Photo")))
                (:li :id "nav-logout"
                     (:h2 (:a :href (genurl 'r-logout) "Logout"))))))))

(defun ed-header (logged-in)
  (with-html
    (:div :id "banner"
          (str (ed-logo))
          (str (ed-site-search)))
    (str (ed-navigation logged-in))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page footer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ed-footer ()
  (with-html "This is the footer"))
