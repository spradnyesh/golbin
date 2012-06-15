(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page template
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro page-template (title popular-articles &body content)
  `(with-html
     (:html
      (:head
       (:title (str (format nil "~A - ~A" *site-name* ,title)))
       (:script :type "text/javascript"
                (str (format nil "var nav-categories = ~A;" (nav-categories-json)))))
      (:body
       (str (header))
       (:div :id "bd"
             (:div :id "col-1"
                   (str ,popular-articles)
                   (str (ads-1)))
             (:div :id "col-2"
                   ,@content)
             (:div :id "col-3"
                   (str (ads-2))))
       (str (footer))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page header
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun logo ()
  (with-html
    (:img :id "logo"
          :source ""
          :alt "logo")))

(defun site-search ()
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

(defun trending ()
  (with-html
    (:div :id "trending-tags")))

(defun navigation ()
  (with-html
    (:ul :id "nav"
         (:li :id "nav-home"
              (:a :href (genurl 'route-home) "Home"))
         (:li :id "cat"
              (:p "Categories"))
         (:li  :id "tags"
               (:p "Tags")
              (str (nav-tags)))
         (:li :id "authors"
              (:p "Authors")
              (str (nav-authors))))))

(defun header ()
  (with-html
    (:div :id "hd"
          (:div :id "banner"
                (str (logo))
                (str (site-search)))
          (str (trending))
          (str (navigation)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; page footer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun footer ()
  (with-html
    (:div :id "ft")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ads
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ads-1 ()
  (with-html
    (:div :id "ads-1")))

(defun ads-2 ()
  (with-html
    (:div :id "ads-2")))
