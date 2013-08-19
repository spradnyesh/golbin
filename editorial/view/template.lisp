(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun in-whitelist? ()
  (let ((vhost (first restas::*vhosts*)))
    (multiple-value-bind (route bindings)
        (match (slot-value vhost 'restas::mapper)
          (request-uri*))
      (declare (ignore bindings))
      (find (route-symbol (proxy-route-target route)) *whitelist*))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page template
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro template (&key title js body (email nil))
  `(let ((lang (get-parameter "lang")))
     (when lang
       (set-cookie "ed-lang"
                   :path "/"
                   :value lang)
       (redirect (script-name *request*)))
     (cond ((and (not (in-whitelist?)) ; not in whitelist and not logged-in => goto login page
                 (not (is-logged-in?))
                 (not ,email))
            (redirect (h-genurl 'r-login-get)))
           ((and (in-whitelist?) ; in whitelist and logged in => goto home page
                 (is-logged-in?)
                 (not ,email))
            (redirect (h-genurl 'r-home)))
           (t (<:html ; (in whitelist and logged out) OR (not in whitelist and logged in) => show page asked
               (<:head
                (<:meta :charset "UTF-8") ; http://www.w3.org/TR/html5-diff/#character-encoding
                (<:meta :name "google" :content "notranslate")
                (<:title (format nil "~A - ~A" (get-config "site.name") ,title))
                (<:link :rel "shortcut icon" :type "image/vnd.microsoft.icon" :href "/static/css/images/spree.ico")
                (<:link :rel "stylesheet" :type "text/css" :href "/static/css/yui3-reset-fonts-grids-min.css")
                ;; http://www.faqoverflow.com/askubuntu/16556.html
                (<:link :rel "stylesheet" :type "text/css" :href "http://fonts.googleapis.com/css?family=Ubuntu:regular")
                (<:link :rel "stylesheet" :type "text/css" :href "http://fonts.googleapis.com/earlyaccess/lohitdevanagari.css")
                (<:style :type "text/css" (ed-get-css)))
               (<:body :class (if (string-equal "en-IN" (get-dimension-value "lang"))
                                               ""
                                               "dvngr")
                       (<:div :class "yui3-g"
                              (<:header :id "hd" (header (is-logged-in?) ,email))
                              (<:noscript (translate "use-javascript-enabled-browser"))
                              (<:div :id "bd"
                                     :class "hidden abc"
                                     ,body)
                              (<:footer :id "ft" (footer))))
               (unless ,email
                 (fmtnil (<:script :type "text/javascript" :src "http://code.jquery.com/jquery-1.8.2.min.js")
                         (<:script :type "text/javascript"
                                   (ps ($apply ($ "#bd") remove-class "hidden")))
                         (<:script :type "text/javascript" :src "http://code.jquery.com/ui/1.9.1/jquery-ui.min.js")
                         (<:script :type "text/javascript" :src "http://malsup.github.com/jquery.form.js")
                         (<:script :type "text/javascript" :src "http://raw.github.com/mjsarfatti/nestedSortable/master/jquery.mjs.nestedSortable.js")
                         (<:script :type "text/javascript" (on-load))
                         ,js)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page header
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun header (logged-in email)
  (<:div :class "wrapper"
         (logo logged-in)
         (unless email
           (navigation logged-in))))

(defmacro lang-a (lang selected lang-name)
  (let* ((class "small")
         (class (concatenate 'string
                             class
                             (when (or (string= lang "hi-IN")
                                       (string= lang "mr-IN"))
                               " dvngr"))))
    `(<:a :class (if ,selected
                     (concatenate 'string ,class " lang-selected")
                     ,class)
          :href (concatenate 'string (request-uri*) "?lang=" ,lang)
          ,lang-name)))

(defun logo (logged-in)
  (<:figure :id "logo" (<:h1
                        (<:a :href (h-genurl 'r-home)
                             (<:img :src "/static/css/images/spree.png"
                                    :alt (get-config "site.name"))
                             #- (and)
                             (get-config "site.name")))
            (unless logged-in
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
                            (t (redirect (h-genurl 'r-login-get :lang "en-IN")))))))))

(defun site-search ()
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
(defun editor-nav ()
  (<:li (<:h3 (<:a :href (h-genurl 'r-approve-articles)
                   (translate "approve-articles")))))

(defun admin-nav ())

(defun logout-nav ()
  (<:li :id "n-logout"
        (<:h3 (<:a :href (h-genurl 'r-logout)
                   (translate "logout")))))

(defun nav-add ()
  (<:ul :class "subnav"
        (<:li (<:h3 (<:a :href (h-genurl 'r-article-new-get)
                         (translate "article"))))))

(defun nav-account ()
  (<:ul :class "subnav"
        (<:li (<:h3 (<:a :href (h-genurl 'r-account-password-get)
                         (translate "change-password"))))
        (<:li (<:h3 (<:a :href (h-genurl 'r-account-email-get)
                         (translate "change-email"))))
        (<:li (<:h3 (<:a :href (h-genurl 'r-account-token-get)
                         (translate "change-token-card"))))))

(defun nav-report ()
  (<:ul :class "subnav"))

(defun nav-misc ()
  (let ((author-type (session-value :author-type)))
    (<:ul :class "subnav"
          (fmtnil (cond ((eq author-type :e) ; editor
                         (fmtnil (editor-nav)))
                        ((eq author-type :d) ; admin
                         (fmtnil (editor-nav)
                                 (admin-nav))))
                  (logout-nav)))))

(defun navigation (logged-in)
  (when logged-in
    (<:ul :id "nav"
          (<:li :class "prinav"
                (<:h2 (translate "add")) ; available to all authors by default
                (nav-add))
          (<:li :class "prinav"
                (<:h2 (translate "reports")) ; also available to all authors by default
                (nav-report))
          (<:li :class "prinav"
                (<:h2 (translate "account")) ; also available to all authors by default
                (nav-account))
          (<:li :class "prinav"
                (<:h2 (translate "misc")) ; based upon author-type (except logout)
                (nav-misc)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page footer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun footer ()
  (<:div :class "wrapper"
         (<:div :id "col-1" :class "yui3-u-1-4"
                (<:img :alt "Spree Demo Theme"
                       :id "footer-logo"
                       :src "/static/css/images/spree_white.png")
                (<:br)
                (<:br)
                (<:div :class "phone"
                       (<:a :href "callto:012341234567"
                            "01-234-1234-567"))
                (<:br)
                (<:div :class "email"
                       (<:a :href
                            "mailto:demo@spreecommerce.com"
                            "demo@spreecommerce.com"))
                (<:br)
                (<:div :class "address"
                       "Spree Demo Store 01"
                       (<:br)
                       "Washigton DC, USA"))
         (<:div :class "yui3-u-3-4"
                (<:div :id "col-2" :class "yui3-u-1-3"
                       (<:h5 "Our Best Offers")
                       (<:ul
                        (<:li (<:a :href "/products" "New Products"))
                        (<:li (<:a :href "/products" "Top Sellers"))
                        (<:li (<:a :href "/products" "Specials"))
                        (<:li (<:a :href "/products" "Manufacturers"))
                        (<:li (<:a :href "/products" "Suppliers"))
                        (<:li (<:a :href "/products" "Service"))))
                (<:div :class "yui3-u-2-3"
                       (<:div :id "col-3" :class "yui3-u-1-2"
                              (<:h5 "Regular Services")
                              (<:ul
                               (<:li (<:a :href "/contact-us" "Contact"))
                               (<:li (<:a :href "/shipping" "Shipping Info"))
                               (<:li (<:a :href "/products" "Returns"))
                               (<:li (<:a :href "/products" "F.A.Q."))
                               (<:li (<:a :href "/products" "Size Chart"))
                               (<:li (<:a :href "/products" "Personal Shopper"))))
                       (<:div :id "col-4" :class "yui3-u-1-2"
                              (<:h5 "Important info")
                              (<:p
                               "This website is " (<:strong "NOT") " a real store,
                           it's a fully working demo application for "
                               (<:a :href "http://spreecommerce.com"
                                    :target "_blank"
                                    "Spree Commerce.")
                               " Please feel free to play around, but don't submit
                           any information you would not consider public!"))))))
