(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page template
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro template (&key title js tags description body (email nil))
  `(let ((lang (get-dimension-value "lang")))
     (<:html (<:head
              (<:meta :charset "UTF-8") ; http://www.w3.org/TR/html5-diff/#character-encoding
              (<:meta :name "application-name" :content "Golb.in")
              (<:meta :name "author" :content "golbin@rocketmail.com")
              (<:meta :name "copyright" :content "Golb.in 2012")
              (<:meta :name "keywords"
                      :content (join-string-list-with-delim ", "
                                                            (append ,tags
                                                                    (list (get-config "site.name")))))
              (<:meta :name "description" :content ,description)
              (<:meta :name "google" :content "notranslate")
              (<:title (format nil "~A - ~A" (get-config "site.name") (translate ,title)))
              (<:link :rel "shortcut icon" :type "image/vnd.microsoft.icon" :href "/static/css/images/golbin-logo.ico")
              (when (or (string= "mr-IN" lang)
                        (string= "hi-IN" lang))
                (<:link :rel "stylesheet"
                        :type "text/css"
                        :href "http://fonts.googleapis.com/earlyaccess/lohitdevanagari.css"))
              (if (string-equal (get-dimension-value "envt") "prod")
                  (fmtnil #- (and)
                          (fmtnil
                            (<:link :rel "stylesheet" :type "text/css"
                                  :href "/static/css/yui3-reset-fonts-grids-min.css")
                            (<:style (get-css)))
                          (<:link :rel "stylesheet" :type "text/css"
                                  :href "/static/css/fe-43-min.css")
                          (<:script :type "text/javascript" :src "http://code.jquery.com/jquery-1.8.2.min.js")
                          ;; hate that sharethis cannot be lazy-loaded :(
                          (<:script :type "text/javascript" :src "http://w.sharethis.com/button/buttons.js")
                          (<:script :type "text/javascript" :src "http://s.sharethis.com/loader.js")
                          ;; google analytics
                          (<:script :type "text/javascript" "
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-35078884-1']);
  _gaq.push(['_setDomainName', 'golb.in']);
  _gaq.push(['_trackPageview']);
  var switchTo5x=true; // needed for sharethis

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
"))
                  (<:style (get-css))))
             (<:body :class (if (string-equal "en-IN" lang)
                                ""
                                "dvngr")
                     (<:div :id "bkgrnd"
                            (<:div :class "yui3-g"
                                   (<:header :id "hd" (header ,email))
                                   (<:div :id "bd"
                                          (<:div :class "yui3-u-17-24"
                                                 (<:div :id "col-1" :class "yui3-u-1-4"
                                                        (ads-1))
                                                 (<:div :id "col-2" :class "yui3-u-3-4"
                                                        (<:div :id "wrapper" ,body)))
                                          (<:div :id "col-3" :class "yui3-u-7-24"
                                                 (ads-2)))
                                   (<:footer :id "ft" (footer)))))
             #- (and)
             (<:script :type "text/javascript" (on-load))
             (<:script :type "text/javascript" :src "/static/js/fe-16-min.js")
             (<:script :type "text/javascript"
                       (concatenate 'string
                                    ;; hate that sharethis cannot be lazy-loaded :(
                                    "stLight.options({publisher: \"72b76e38-1974-422a-bd23-e5b0b26b0399\", doNotHash: false, doNotCopy: false, hashAddressBar: true});
                                     var options={ \"publisher\": \"72b76e38-1974-422a-bd23-e5b0b26b0399\", \"scrollpx\": 50, \"ad\": { \"visible\": false}, \"chicklets\": { \"items\": [\"facebook\",\"twitter\",\"googleplus\",\"evernote\",\"blogger\",\"orkut\",\"pinterest\",\"sharethis\",\"googleplus\",\"email\"]}};
                                     var st_pulldown_widget = new sharethis.widgets.pulldownbar(options);
                                     " ; this newline is needed for concatenating w/ ,js below
                                    ,js))
             )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page header
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun logo ()
  (<:figure (<:h1 (<:a :href (h-genurl 'r-home)
                       (<:img :src "/static/css/images/golbin.png"
                              :alt (get-config "site.name"))))
            (let ((protocol (get-config "site.protocol.fe")))
              (logo-langs (concatenate 'string protocol "www.golb.in")
                          (concatenate 'string protocol "mr.golb.in")
                          (concatenate 'string protocol "hi.golb.in")))))

(defun site-search ()
  #- (and)
  (<:form :method "GET"
         :action (h-genurl 'r-search)
         :name "search"
         :id "search"
         (<:input :type "input"
                 :name "q"
                 :value "Search")
         (<:input :type "submit"
                 :value "Submit")))

(defun trending ()
  (<:div :id "trending-tags"))

(defmacro subnav (url)
  `(when (and (not (string= "--" (name subcat)))
              (plusp (rank subcat)))
     (let ((subcat-slug (slug subcat)))
       (<:li :class (nav-selected (string-equal (url-encode subcat-slug)
                                                (second cat-subcat))
                        "selected"
                        "")
             (<:h3 (<:a :href ,url
                        (name subcat)))))))

;; XXX: needs cache (key: uri)
(defun navigation ()
  (let* ((route (if (boundp '*request*)
                    (route-symbol *route*)
                    :r-home))
         (cat-subcat (when (nav-cat? route)
                       (get-nav-cat-subcat-slugs (if (boundp '*request*)
                                                     (request-uri*)
                                                     "/"))))
         (subnav-cat-slug nil)
         (subnav-subcats nil))
    (<:div :id "nav"
           (<:ul :id "prinav"
                 (<:li :class (concatenate 'string
                                           "cat "
                                           (when (eq route (fe-intern :r-home))
                                             "selected"))
                       (<:h2 (<:a :href (h-genurl 'r-home) (translate "home")))
                       (<:ul :class "subnav"))
                 (loop for cat in (get-root-categorys)
                    when (plusp (rank cat))
                    collecting (let ((cat-slug (slug cat)))
                                 (<:li :class (nav-selected (string-equal (url-encode cat-slug)
                                                                          (first cat-subcat))
                                                  "selected"
                                                  ""
                                                (setf subnav-cat-slug cat-slug)
                                                (setf subnav-subcats (get-subcategorys (id cat))))
                                       (<:h2 (<:a :href (h-genurl 'r-cat
                                                                  :cat cat-slug)
                                                  (name cat)))
                                       (<:ul :class "subnav"
                                             (join-loop subcat
                                                                (get-subcategorys (id cat))
                                                                (subnav (h-genurl 'r-cat-subcat
                                                                                  :cat cat-slug
                                                                                  :subcat subcat-slug))))))
                    into a
                    finally (return (apply #'concatenate 'string a)))
                 (<:li :id "join"
                       (<:h2 (<:a :href "http://ed.golb.in" (translate "join"))))))))

(defun header (email)
  (fmtnil (<:div :id "banner"
                 (fmtnil (logo)
                         #- (and)
                         (site-search)))
          (unless email
            (navigation))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page footer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun footer ()
  (fmtnil (<:p "Copyright © 2012 Golbin Inc, LLP and respective copyright owners. All rights reserved.")
          (<:div (<:p (<:a :href (h-genurl 'r-tos) (translate "terms-of-service")))
                 (<:p (<:a :href (h-genurl 'r-privacy) (translate "privacy")))
                 (<:p (<:a :href "mailto:webmaster@golb.in" (translate "contact-us")))
                 (<:p :class "last"
                      (<:a :href "http://www.copyscape.com/"
                           (<:img :src "/static/css/images/cs-wh-3d-234x16.gif"))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ads
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ads-1 ()
  (ads-markup "ca-pub-7627106577670276" "1936097987" 160 300))

(defun ads-2 ()
  (fmtnil (ads-markup "ca-pub-7627106577670276" "5029165182" 300 250)
          (ads-markup "ca-pub-7627106577670276" "9459364786" 300 600)))
