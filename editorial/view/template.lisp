(in-package :hawksbill.golbin)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page template
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro ed-page-template (title &body content)
  `(with-html
     (:html
      (:head
       (:title (str (format nil "~A - ~A" *site-name* ,title)))
       (:link :rel "stylesheet" :type "text/css" :href "/static/css/yui3-reset-fonts-grids-min.css")
       (:style :type "text/css"
               (str (ed-get-css))))
      (:body
       (:div :class "yui3-g"
            (:div :id "hd"
                  (str (ed-header)))
            (:div :id "bd"
                  (:div ,@content))
            (:div :id "ft"
                  (str (ed-footer))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page header
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ed-logo ()
  (with-html
    (:h1
     (:a :href (genurl 'ed-r-home)
         (:img :id "logo"
               :source ""
               :alt *site-name*)))))

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
              (:h2 (:a :href (genurl 'ed-r-home) "Home"))))))

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
