(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CSS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-css ()
  (css
   (("body")
    (:background "#75DAFF url('/static/css/images/cloud-background.jpg') repeat-x"
                 :color "#292929"
                 :font-family "'Ubuntu', Arial,sans-serif"
                 :font-size "14px"
                 :line-height "21px"
                 :margin "0 auto"
                 :min-width "1200px"))

   (("strong")
    (:font-weight "bold"))

   (("em")
    (:font-style "italic"))

   (("u")
    (:text-decoration "underline"))

   (("p")
    (:margin "15px 0"))

   (("a:link, a:active, a:visited, a:hover")
    (:border "none"
             :color "#21629C"
             :text-decoration "none"))

   (("a:hover")
    (:color "#000"))

   (("acronym, abbr")
    (:cursor "help"))

   ((".clearfix:before, .clearfix:after")
    (:clear "both"
            :content "."
            :display "block"
            :font-size "0"
            :height "0"
            :line-height "0"
            :visibility "hidden"))

   ((".yui3-g")
    (:letter-spacing "normal"
                     :width "1200px"
                     :word-spacing "normal"
                     :margin "0 auto"))

   ((".dvngr")
    (:font-family "Lohit Devanagari"))

   (("h2")
    (:font-size "140%"
                :padding "4px 0"))

   (("h3")
    (:font-size "120%"))

   (("h4")
    (:font-weight "bold"))

   ((".small")
    (:font-size "80%"))

   ((".disabled")
    (:color "#999"))

   ((".block")
    (:display "block"))

   ((".left")
    (:float "left"))

   ((".right")
    (:float "right"))

   ((".hidden")
    (:display "none"))

   ((".lazyload_ad")
    (:text-align "center"
                 :padding "20px 0"))

   ;; main structure elements
   (("#wrapper")
    (:background "#FFF"
                 :clear "both"
                 :margin "0 auto"
                 :min-height "800px"
                 :padding "20px"))

   (("#banner")
    (:height "175px"))

   ;; navigation
   (("#nav, #ft")
    (:background-color "#F0F0F0"
                       :display "block"))

   (("#nav a")
    (:color "gray"))

   (("#nav li")
    (:float "left"
            :margin "5px 0"))
   (("#nav li h2 a, #nav li h3 a")
    (:padding "0 20px"))
   (("#nav .selected")
    (:background-color "#FFF"))

   (("#prinav")
    (:height "40px"
             :padding "10px 0 0 10px"))

   (("#prinav .cat ul")
    (:display "none"))

   (("#subnav")
    (:height "30px"
             :padding "0 0 10px 10px"))

   (("#bd")
    (:background-color "#FFF"))

   (("#ft")
    (:padding "20px 250px"
              :height "30px"))

   (("#ft p")
    (:float "left"
            :padding-right "25px"))

   ;; index
   (("#articles li")
    (:border-bottom "1px dotted"
                    :border-color "#CCC"
                    :margin-bottom "15px"))

   (("#articles .index-thumb")
    (:float "left"
            :padding-right "10px"))

   (("#articles .a-summary")
    (:color "#4a4a4a"
            :margin "0 0 10px 0"))

   ;; article
   (("#article img")
    (:display "block"
              :padding-bottom "5px"))

   (("#article div.a-photo")
    (:padding "10px"
              :position "relative"))

   (("#article a.p-attribution")
    (:position "absolute"
               :right "30px"))

   (("#article p.p-title")
    (:text-align "center"
                 :margin "15px 0 0 0"))

   (("#a-title")
    (:font-size "160%"))

   ((".a-cite")
    (:color "#999999"
            :padding "2px 0"
            :display "block"))

   (("#a-body")
    (:text-align "justify"
                 :padding-top "10px"))

   (("#a-body li")
    (:margin-bottom "15px"))

   (("#a-body div.a-photo")
    (:float "right"))

   (("#a-body .block")
    (:padding-bottom "10px"
                     :text-align "center"))

   (("#a-body blockquote")
    (:background-color "#F0F0F0"
                       :padding "10px"))

   (("#a-body li")
    (:background "url('/static/css/images/icon_bullet.png') 5px 2px no-repeat"
                 :padding-left "25px"))

   (("#a-body img")
    (:padding "10px"))

   (("#related")
    (:border-top "1px dotted #ccc"
                 :margin-top "25px"
                 :padding-top "10px"))

   ;; comments
   (("#comments")
    (:margin-top "35px"
                 :padding-top "10px"
                 :border-top "1px dotted #ccc"))

   (("#comments ul")
    (:margin-top "20px"))

   (("#comments li")
    (:border-bottom "1px dotted"
                    :border-color "#CCC"
                    :margin-bottom "15px"))

   (("#comments td")
    (:padding "5px 20px 5px 0"))

   (("#comments input, #comments textarea")
    (:border "3px solid #ddd"
             :padding "7px 20px"
             :line-height "15px"
             :border-radius "8px"))


   (("#comments h3")
    (:padding "5px 0"))

   ((".c-body")
    (:padding "10px"
              :background-color "#f0f0f0"
              :margin-top "-10px"))

   ;; carousel
   ((".carousel")
    (:font-size "12px"))

   ((".carousel h3")
    (:padding "10px 0"))

   ((".carousel p.prev")
    (:position "relative"
               :top "50px"
               :margin-right "20px"))

   ((".carousel p.next")
    (:position "relative"
               :top "-90px"))

   ((".carousel ul")
    (:height "140px"))

   ((".carousel ul li")
    (:list-style-type "none"
                      :float "left"
                      :width "120px"
                      :margin "0 5px"))

   ((".carousel ul li div")
    (:width "100px"
            :height "100px"
            :margin "5px 0"))

   ((".carousel ul li div.no-photo")
    (:background-color "#F0F0F0"))

   ;; pagination
   ((".pagination")
    (:text-align "center"
                 :padding "20px 0 0"))

   ((".pagination li")
    (:border "1px solid"
             :border-color "#F0F0F0"
             :border-radius "3px 3px 3px 3px"
             :display "inline"
             :margin "0 2px"
             :padding "2px 4px"
             :vertical-align "middle"))

   ((".pagination li a")
    (:color "#035583"
            :text-decoration "none"))

   ((".pagination .disabled")
    (:border "none"))

   ((".pagination-results")
    (:color "#999"
            :margin-bottom "20px"
            :text-align "center"))

   ;; devanagari
   ((".dvngr" h2)
    (:padding "8px 0 0 0"))

   ((".dvngr" h3)
    (:padding "5px 0 0 0"))

   ;; sharethis.com
   ((".stpulldown-gradient")
    (:background "#E1E1E1"
                 :background "-moz-linear-gradient(top, '#E1E1E1' 0%, '#A7A7A7' 100%)"
                 :background "-webkit-gradient(linear, left top, left bottom, color-stop(0%, '#E1E1E1'), color-stop(100%, '#A7A7A7')) "
                 :filter "progid: DXImageTransform.Microsoft.gradient(startColorstr='#E1E1E1', endColorstr='#A7A7A7',GradientType=0 )"
                 :background "-o-linear-gradient(top, '#E1E1E1' 0%, '#A7A7A7' 100%)"
                 :color "#636363"))

   (("#stpulldown .stpulldown-logo")
    (:height "40px"
             :width "300px"
             :margin-left "20px"
             :margin-top "5px"
             ;; put the :space in the above url purposefully; till Golbin logo comes up
             :background "url('http: //sd.sharethis.com/disc/images/Logo_Area.png') no-repeat"))))
