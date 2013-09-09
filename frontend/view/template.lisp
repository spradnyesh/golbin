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
              (<:title (format nil "~A - ~A" (get-config "site.name") ,title))
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
                                  :href "/static/css/fe-23-min.css")
                          ;; google analytics and adsense
                          (<:script :type "text/javascript" "
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-35078884-1']);
  _gaq.push(['_setDomainName', 'golb.in']);
  _gaq.push(['_trackPageview']);

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
                     (<:div :class "yui3-g"
                            (<:div :id "hd"
                                   (header ,email))
                            (<:div :id "bd"
                                   (<:div :class "yui3-u-17-24"
                                          (<:div :id "col-1" :class "yui3-u-1-4"
                                                 (ads-1))
                                          (<:div :id "col-2" :class "yui3-u-3-4"
                                                 (<:div :id "wrapper" ,body)))
                                   (<:div :id "col-3" :class "yui3-u-7-24"
                                          (ads-2)))
                            (<:div :id "ft" (footer))))
             (<:script :type "text/javascript" :src "http://code.jquery.com/jquery-1.8.2.min.js")
             #- (and)
             (<:script :type "text/javascript" (on-load))
             (if (string-equal (get-dimension-value "envt") "prod")
                 (<:script :type "text/javascript" :src "/static/js/fe-10-min.js")
                 (<:script :type "text/javascript" (on-load)))
             (<:script :type "text/javascript" ,js))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page header
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun logo ()
  (<:h1 (<:a :href (h-genurl 'r-home)
           (<:img :id "logo"
                 :src ""
                 :alt (get-config "site.name")))))

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
                        "subcat selected"
                        "subcat")
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
                 (<:li :id "nav-home" :class (concatenate 'string
                                                          "cat "
                                                          (when (eq route (fe-intern :r-home))
                                                              "selected"))
                       (<:h2 (<:a :href (h-genurl 'r-home) (translate "home"))))
                 (loop for cat in (get-root-categorys)
                    when (plusp (rank cat))
                    collecting (let ((cat-slug (slug cat)))
                                 (<:li :class (nav-selected (string-equal (url-encode cat-slug)
                                                                          (first cat-subcat))
                                                  "cat selected"
                                                  "cat"
                                                (setf subnav-cat-slug cat-slug)
                                                (setf subnav-subcats (get-subcategorys (id cat))))
                                       (<:h2 (<:a :href (h-genurl 'r-cat
                                                                  :cat cat-slug)
                                                  (name cat)))
                                       (<:ul
                                        (join-loop subcat
                                                   (get-subcategorys (id cat))
                                                   (subnav (h-genurl 'r-cat-subcat
                                                                     :cat cat-slug
                                                                     :subcat subcat-slug)))))) into a
                    finally (return (apply #'concatenate 'string a))))
           (<:ul :id "subnav"
                 (join-loop subcat
                            subnav-subcats
                            (subnav (h-genurl 'r-cat-subcat :cat subnav-cat-slug :subcat subcat-slug)))))))

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
  (fmtnil (<:p "Copyright © 2012 Golbin Inc. All rights reserved.")
          (<:p (<:a :href (h-genurl 'r-tos) "Terms of Service"))
          (<:p (<:a :href (h-genurl 'r-privacy) "Privacy"))
          (<:p (<:a :href "mailto:webmaster@golb.in" "Contact us")))) ; XXX: translate

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ads
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ads-1 ()
  (when (string-equal (get-dimension-value "envt") "prod")
    (<:div :class "lazyload_ad" :original "http://pagead2.googlesyndication.com/pagead/show_ads.js"
           (<:code :type "text/javascript"
                   "<!--
                 google_ad_client = 'ca-pub-7627106577670276';
                 google_ad_slot = '1936097987';
                 google_ad_width = 160;
                 google_ad_height = 600;
                 //-->"))))

(defun ads-2 ()
  (when (string-equal (get-dimension-value "envt") "prod")
    (fmtnil
     (<:div :class "lazyload_ad" :original "http://pagead2.googlesyndication.com/pagead/show_ads.js"
            (<:code :type "text/javascript"
                    "<!--
                          google_ad_client = 'ca-pub-7627106577670276';
                          google_ad_slot = '5029165182';
                          google_ad_width = 300;
                          google_ad_height = 250;
                          //-->"))
     (<:div :class "lazyload_ad" :original "http://pagead2.googlesyndication.com/pagead/show_ads.js"
            (<:code :type "text/javascript"
                    "<!--
                          google_ad_client = 'ca-pub-7627106577670276';
                          google_ad_slot = '9459364786';
                          google_ad_width = 300;
                          google_ad_height = 600;
                          //-->")))))
