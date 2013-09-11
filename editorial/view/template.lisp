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
     (if lang
         (progn (set-cookie "lang"
                            :path "/"
                            :value lang)
                (redirect (script-name *request*)))
         (setf lang (get-dimension-value "lang")))
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
                (when (or (not (is-logged-in?))
                          (not (string= "en-IN" lang)))
                  (<:link :rel "stylesheet"
                          :type "text/css"
                          :href "http://fonts.googleapis.com/earlyaccess/lohitdevanagari.css"))
                (<:style :type "text/css" (ed-get-css)))
               (<:body :class (if (string= "en-IN" lang) "" "dvngr")
                       (<:div :class "yui3-g"
                              (<:header :id "hd" (header (is-logged-in?) ,email))
                              (<:div :id "bd"
                                     ,body)
                              (<:footer :id "ft" (footer))))
               (unless ,email
                 (fmtnil (<:script :type "text/javascript" :src "http://code.jquery.com/jquery-1.8.2.min.js")
                         (<:script :type "text/javascript" :src "http://code.jquery.com/ui/1.9.1/jquery-ui.min.js")
                         (<:script :type "text/javascript" :src "http://malsup.github.io/jquery.form.js")
                         ;(<:script :type "text/javascript" :src "http://raw.github.io/mjsarfatti/nestedSortable/master/jquery.mjs.nestedSortable.js")
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
                             (get-config "site.name")))
            (unless logged-in
              (<:ul :class "langs"
                    (let ((lang (get-dimension-value "lang")))
                      (cond ((string-equal lang "en-IN")
                             (<:li
                              (lang-a "en-IN" t "English")
                              #- (and)
                              (lang-a "hi-IN" nil "हिन्दी")
                              (lang-a "mr-IN" nil "मराठी")))
                            #- (and)
                            ((string-equal lang "hi-IN")
                             (<:li
                              (lang-a "en-IN" nil "English")
                              (lang-a "hi-IN" t "हिन्दी")
                              (lang-a "mr-IN" nil "मराठी")))
                            ((string-equal lang "mr-IN")
                             (<:li
                              (lang-a "en-IN" nil "English")
                              #- (and)
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

(defun nav-add ()
  (<:ul :class "subnav"
        (<:li (<:h3 (<:a :href (h-genurl 'r-article-new-get)
                         (translate "article"))))))

(defun nav-account ()
  (<:ul :class "subnav"
        (<:li (<:h3 (<:a :href (h-genurl 'r-account-password-get)
                         (translate "change-password"))))
        (<:li (<:h3 (<:a :href (h-genurl 'r-account-email-get)
                         (translate "change-email"))))))

(defun nav-misc ()
  (let ((author-type (session-value :author-type)))
    (<:ul :class "subnav"
          (cond ((eq author-type :e)    ; editor
                 (fmtnil (editor-nav)))
                ((eq author-type :d)    ; admin
                 (fmtnil (editor-nav)
                         (admin-nav)))))))

(defun navigation (logged-in)
  (when logged-in
    (<:ul :id "nav"
          (when (eq (status (who-am-i)) :a)
            (fmtnil (<:li :class "prinav wide"
                          (<:h2 (<:a :href (h-genurl 'r-article-new-get)
                                     (translate "add-article"))))
                    (<:li :class "prinav"
                          (<:h2 (translate "reports")))
                    (<:li :class "prinav wide"
                          (<:h2 (translate "account"))
                          (nav-account))
                    (<:li :class "prinav wide"
                          (<:h2 (translate "misc"))
                          (nav-misc))))
          (<:li :class "prinav"
                (<:h2 (<:a :href (h-genurl 'r-logout)
                           (translate "logout")))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page footer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun footer ()
  (<:div :class "wrapper"
         (<:p "Copyright © 2012 Golbin Inc. All rights reserved.")
         (<:p (<:a :href (h-genurl 'r-tos) "Terms of Service"))
         (<:p (<:a :href (h-genurl 'r-privacy) "Privacy"))
         (<:p (<:a :href "mailto:webmaster@golb.in" "Contact us"))))
