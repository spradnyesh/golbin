(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page template
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro template (&key title logged-in js body)
  `(<:html
    (<:head
     (<:meta :charset "UTF-8") ; http://www.w3.org/TR/html5-diff/#character-encoding
     (<:meta :name "google" :content "notranslate")
     (<:title (format nil "~A - ~A" (get-config "site.name") ,title))
     (<:link :rel "stylesheet" :type "text/css" :href "/static/css/yui3-reset-fonts-grids-min.css")
     ;; http://www.faqoverflow.com/askubuntu/16556.html
     (<:link :rel "stylesheet" :type "text/css" :href "http://fonts.googleapis.com/css?family=Ubuntu:regular")
     (<:link :rel "stylesheet" :type "text/css" :href "http://fonts.googleapis.com/earlyaccess/lohitdevanagari.css")
     (<:style :type "text/css" (ed-get-css)))
    (<:body :class (if (string-equal "en-IN" (get-dimension-value "lang"))
                       ""
                       "dvngr")
            (<:div :class "yui3-g"
                   (<:div :id "hd" (ed-header ,logged-in))
                   (<:div :id "bd" ,body)
                   (<:div :id "ft" (ed-footer))))
    (<:script :type  "text/javascript" :src "http://code.jquery.com/jquery-1.8.2.min.js")
    (<:script :type  "text/javascript" :src "http://code.jquery.com/ui/1.9.1/jquery-ui.min.js")
    (<:script :type  "text/javascript" :src "http://malsup.github.com/jquery.form.js")
    (<:script :type  "text/javascript" :src "http://raw.github.com/mjsarfatti/nestedSortable/master/jquery.mjs.nestedSortable.js")
    (<:script :type "text/javascript" (on-load))
    ,js))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page header
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ed-header (logged-in)
  (fmtnil (ed-logo)
          (ed-navigation logged-in)))

(defun ed-logo ()
  (<:div :id "logo" (<:h1
                     (<:a :href (h-genurl 'r-home)
                          (get-config "site.name")
                          #- (and)
                          (<:img :src ""
                                 :alt (get-config "site.name"))))
         (<:ul :class "langs"
          (let ((ed-lang (cookie-in "ed-lang")))
            (cond ((string-equal ed-lang "en-IN")
                   (<:li
                    (lang-a "en-IN" t "English")
                    (lang-a "hi-IN" nil "हिन्दी")
                    (lang-a "mr-IN" nil "मराठी")))
                  ((string-equal ed-lang "hi-IN")
                   (<:li
                    (lang-a "en-IN" nil "English")
                    (lang-a "hi-IN" t "हिन्दी")
                    (lang-a "mr-IN" nil "मराठी")))
                  ((string-equal ed-lang "mr-IN")
                   (<:li
                    (lang-a "en-IN" nil "English")
                    (lang-a "hi-IN" nil "हिन्दी")
                    (lang-a "mr-IN" t "मराठी")))
                  (t (redirect (h-genurl 'r-login-get :lang "en-IN"))))))))

(defun ed-site-search ()
  #- (and)
  (<:form :method "GET"
         :action (h-genurl 'route-search)
         :name "search"
         :id "search"
         (<:input :type "input"
                 :name "q"
                 :value "Search")
         (<:input :type "submit"
                 :value "Submit")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; navigations for different author types
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun author-nav ()
  (fmtnil
   (<:li :id "nav-article"
         (<:h2 (<:a :href (h-genurl 'r-article-new-get) "Add Article")))
   (<:li :id "nav-photo"
         (<:h2 (<:a :href (h-genurl 'r-photo-get) "Add Photo")))))
(defun editor-nav ()
  (<:li :id "nav-approve"
        (<:h2 (<:a :href (h-genurl 'r-approve-articles) "Approve Articles"))))
(defun admin-nav ())
(defun logout-nav ()
  (<:li :id "nav-logout"
        (<:h2 (<:a :href (h-genurl 'r-logout) "Logout"))))

(defun ed-navigation (logged-in)
  (<:ul :id "nav"
        (<:li :id "nav-home"
              (<:h2 (<:a :href (h-genurl 'r-home) (translate "home"))))
        (when logged-in
          (fmtnil
           (let ((author-type (session-value :author-type)))
             (cond ((eq author-type :u) ; author
                    (author-nav))
                   ((eq author-type :e) ; editor
                    (fmtnil (author-nav)
                            (editor-nav)))
                   ((eq author-type :d) ; admin
                    (fmtnil (author-nav)
                            (editor-nav)
                            (admin-nav)))))
           (logout-nav)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page footer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ed-footer ()
  "This is the footer")
