(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page template
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro template (&key title logged-in js body)
  `(with-html
     (:html
      (:head
       (:meta :charset "UTF-8") ; http://www.w3.org/TR/html5-diff/#character-encoding
       (:title (str (format nil "~A - ~A" (get-config "site.name") ,title)))
       (:link :rel "stylesheet" :type "text/css" :href "/static/css/yui3-reset-fonts-grids-min.css")
       ;; http://www.faqoverflow.com/askubuntu/16556.html
       (:link :rel "stylesheet" :type "text/css" :href "http://fonts.googleapis.com/css?family=Ubuntu:regular")
       (:link :rel "stylesheet" :type "text/css" :href "http://fonts.googleapis.com/earlyaccess/lohitdevanagari.css")
       (:style :type "text/css"
               (str (ed-get-css))))
      (:body :class (format nil "~a" (if (string-equal "en-IN" (get-dimension-value "lang"))
                                         ""
                                         "dvngr"))
             (:div :class "yui3-g"
                   (:div :id "hd"
                         (str (ed-header ,logged-in)))
                   (:div :id "bd"
                         ,body)
                   (:div :id "ft"
                         (str (ed-footer)))))
      (:script :type  "text/javascript" :src "http://code.jquery.com/jquery-1.8.2.min.js")
      (:script :type  "text/javascript" :src "http://code.jquery.com/ui/1.9.1/jquery-ui.min.js")
      (:script :type  "text/javascript" :src "http://malsup.github.com/jquery.form.js")
      (:script :type  "text/javascript" :src "http://raw.github.com/mjsarfatti/nestedSortable/master/jquery.mjs.nestedSortable.js")
      (:script :type "text/javascript" (str (on-load)))
      ,js)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page header
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ed-header (logged-in)
  (with-html
    (:div :id "banner"
          (str (ed-logo))
          (str (ed-site-search)))
    (str (ed-navigation logged-in))))

(defun ed-logo ()
  (with-html
    (:h1
     (:a :href (h-genurl 'r-home)
         (:img :id "logo"
               :source ""
               :alt (get-config "site.name"))))))

(defun ed-site-search ()
  #- (and)
  (with-html
    (:form :method "GET"
           :action (h-genurl 'route-search)
           :name "search"
           :id "search"
           (:input :type "input"
                   :name "q"
                   :value "Search")
           (:input :type "submit"
                   :value "Submit"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; navigations for different author types
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun author-nav ()
  (with-html (:li :id "nav-article"
                  (:h2 (:a :href (h-genurl 'r-article-new-get) "Add Article")))
             (:li :id "nav-photo"
                  (:h2 (:a :href (h-genurl 'r-photo-get) "Add Photo")))))
(defun editor-nav ()
  (with-html (:li :id "nav-approve"
                  (:h2 (:a :href (h-genurl 'r-approve-articles) "Approve Articles")))))
(defun admin-nav ())
(defun logout-nav ()
  (with-html (:li :id "nav-logout"
                  (:h2 (:a :href (h-genurl 'r-logout) "Logout")))))

(defun ed-navigation (logged-in)
  (with-html
    (:ul :id "nav"
         (:li :id "nav-home"
              (:h2 (:a :href (h-genurl 'r-home) (translate "home"))))
         (when logged-in
           (let ((author-type (session-value :author-type)))
             (cond ((eq author-type :u) ; author
                    (str (author-nav)))
                   ((eq author-type :e) ; editor
                    (str (author-nav))
                    (str (editor-nav)))
                   ((eq author-type :d) ; admin
                    (str (author-nav))
                    (str (editor-nav))
                    (str (admin-nav)))))
           (str (logout-nav))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page footer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ed-footer ()
  (with-html "This is the footer"))
