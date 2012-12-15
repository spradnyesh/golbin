(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page template
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro fe-page-template (title js tags description &body content)
  `(with-html
     (:html
      (:head
       (:meta :charset "UTF-8") ; http://www.w3.org/TR/html5-diff/#character-encoding
       (:meta :name "application-name" :content "Golb.in")
       (:meta :name "author" :content "golbin@rocketmail.com")
       (:meta :name "copyright" :content "Golb.in 2012")

       (:meta :name "keywords" :content (join-string-list-with-delim ", " (append ,tags (list (get-config "site.name")))))
       (:meta :name "description" :content ,description)
       (:meta :name "google" :content "notranslate")

       (:title (str (format nil "~A - ~A" (get-config "site.name") ,title)))
       (:link :rel "stylesheet" :type "text/css" :href "/static/css/yui3-reset-fonts-grids-min.css")
       (:style :type "text/css"
               (str (fe-get-css)))

       ;; google-analytics
       (:script :type "text/javascript"
                (str "
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-35078884-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
"))

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
              (:div :id "ft" :class "small"
                    (str (fe-footer))))
        (:script :type  "text/javascript" :src "http://code.jquery.com/jquery-1.7.2.min.js")
        (:script :type  "text/javascript" :src "http://w.sharethis.com/button/buttons.js")
        (:script :type  "text/javascript" :src "http://s.sharethis.com/loader.js"))
       (:script :type "text/javascript"
                (str (on-load))
                (str "
var switchTo5x=true;
stLight.options({publisher: '72b76e38-1974-422a-bd23-e5b0b26b0399'});
var options={ 'publisher': '72b76e38-1974-422a-bd23-e5b0b26b0399', 'scrollpx': 50, 'ad': { 'visible': false}, 'chicklets': { 'items': ['facebook', 'twitter', 'googleplus', 'blogger', 'orkut', 'pinterest', 'sharethis', 'email']}};
var st_pulldown_widget = new sharethis.widgets.pulldownbar(options);
"))
       ,js))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page header
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun fe-logo ()
  (with-html
    (:h1
     (:a :href (h-genurl 'r-home)
         (:img :id "logo"
               :source ""
               :alt (get-config "site.name"))))))

(defun fe-site-search ()
  #|(with-html
    (:form :method "GET"
           :action (h-genurl 'r-search)
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

(defmacro fe-subnav (url)
  `(with-html
     (when (and (not (string= "--" (name subcat)))
                (plusp (rank subcat)))
       (let ((subcat-slug (slug subcat)))
         (htm (:li :class (nav-selected (string-equal subcat-slug (second cat-subcat))
                              "subcat selected"
                              "subcat")
                   (:h3 (:a :href ,url
                            (str (name subcat))))))))))

;; XXX: needs cache (key: uri)
(defun fe-navigation ()
  (let* ((route (if (boundp '*request*)
                    (route-symbol *route*)
                    :r-home))
         (uri (if (boundp '*request*)
                    (hunchentoot:request-uri *request*)
                    "/"))
         (cat-subcat (when (nav-cat? route)
                       (get-nav-cat-subcat-slugs uri)))
         (subnav-cat-slug nil)
         (subnav-subcats nil))
    (with-html
      (:div :id "nav"
            (:ul :id "prinav"
                 (:li :id "nav-home" :class (nav-selected t "cat" "cat selected")
                      (:h2 (:a :href (h-genurl 'r-home) "Home")))
                 (dolist (cat (get-root-categorys))
                   (when (plusp (rank cat))
                     (let ((cat-slug (slug cat)))
                       (htm (:li :class (nav-selected (string-equal cat-slug (first cat-subcat))
                                            "cat selected"
                                            "cat"
                                          (setf subnav-cat-slug cat-slug)
                                          (setf subnav-subcats (get-subcategorys (id cat))))
                                 (:h2 (:a :href (h-genurl 'r-cat
                                                        :cat cat-slug)
                                          (str (name cat))))
                                 (:ul
                                  (dolist (subcat (get-subcategorys (id cat)))
                                    (str (fe-subnav (h-genurl 'r-cat-subcat :cat cat-slug :subcat subcat-slug)))))))))))
            (:ul :id "subnav"
                 (dolist (subcat subnav-subcats)
                   (str (fe-subnav (h-genurl 'r-cat-subcat :cat subnav-cat-slug :subcat subcat-slug)))))))))

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
  (with-html
    (:p "Copyright © 2012 Golbin Inc. All rights reserved.")
    (:p (:a :href "mailto:webmaster@golb.in" "Contact us")))) ; XXX: translate

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ads
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun fe-ads-1 ()
  (with-html
    (:div :id "ads-1" "")))

(defun fe-ads-2 ()
  (with-html
    (:div :id "ads-2" "")))
