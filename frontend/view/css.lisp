(in-package :hawksbill.golbin.frontend)

;; gradients: http://www.colorzilla.com/gradient-editor/

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CSS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-css ()
  (css
    (("body") (:background "#cbddeb url('/static/css/images/travel_bg_clouds.jpg') repeat-x"
                           :color "#333"
                           :font-family "'Ubuntu',Arial,sans-serif"
                           :font-size "14px"
                           :line-height "21px"
                           :margin "0 auto"
                           :min-width "1200px"))
    (("strong") (:font-weight "bold"))
    (("em") (:font-style "italic"))
    (("u") (:text-decoration "underline"))
    (("p") (:margin "15px 0"))
    (("h2, h3") (:padding-top "7px"))
    (("h4") (:font-weight "bold"))
    (("a:link, a:active, a:visited, a:hover") (:border "none"
                                                       :color "#21629C"
                                                       :text-decoration "none"))
    (("a:hover") (:color "#000"))
    (("acronym, abbr") (:cursor "help"))
    ((".clearfix:before, .clearfix:after") (:clear "both"
                                                   :content "."
                                                   :display "block"
                                                   :font-size "0"
                                                   :height "0"
                                                   :line-height "0"
                                                   :visibility "hidden"))
    ((".yui3-g") (:letter-spacing "normal"
                                  :width "1200px"
                                  :word-spacing "normal"
                                  :margin "0 auto"))
    ((".dvngr") (:font-family "Lohit Devanagari"))
    (("figure") (:margin "0"))
    ((".small") (:font-size "70%"))
    ((".disabled") (:color "#999"))
    ((".block") (:display "block"))
    ((".left") (:float "left"))
    ((".right") (:float "right"))
    ((".hidden") (:display "none"))
    ((".lazyload_ad") (:text-align "center"
                                   :padding "20px 0"))

    ;; tooltip http://sixrevisions.com/css/css-only-tooltips/
    ((".tooltip") (:color "#61a1f0"
                          :cursor "help"
                          :margin-left "3px"
                          :position "relative"))
    ((".tooltip span") (:margin-left "-999em"
                                     :position "absolute"))
    ((".tooltip:hover span") (:left "5px"
                                    :top "5px"
                                    :z-index "99"
                                    :margin-left "0"
                                    :width "250px"
                                    :background-color "#ffffaa"
                                    :border "1px solid #ddd"
                                    :text-align "center"
                                    :color "#333"
                                    :padding "10px"))
    ((".mandatory") (:color "#f66"
                            :margin-left "3px"))

    ;; pane
    (("#pane") (:width "540px"
                       :min-height "100px"
                       :position "absolute"
                       :top "80px"
                       :left "80px"
                       :border "3px solid #ddd"
                       :border-radius "10px"
                       :background-color "#fff"))
    (("#pane a.close") (:position "absolute"
                                  :top "20px"
                                  :right "20px"))
    (("#pane .message li") (:border "0"
                           :margin "0"))
    (("#pane .message") (:margin "50px 20px 20px"))
    (("#loading") (:width "128px"
                          :height "128px"
                          :position "absolute"
                          :top "210px"
                          :left "400px"
                          :border "0"))
    (("#loading a.close") (:display "none"))

    ;; header
    (("#banner") (:font-family "'Ubuntu',Arial,sans-serif"))
    (("#banner figure") (:padding "30px 10px"))
    (("#banner h1") (:margin-bottom "5px"))
    (("#banner h1 img") (:margin-right "25px"))
    (("#banner li") (:float "left"
                            :padding-right "10px"))
    (("#banner li .selected") (:color "#333"
                                      :padding "1px"
                                      :border-radius "3px"
                                      :background-color "#fff"))
    (("#banner a") (:color "#fff"
                           :font-weight "bold"))

    ;; navigation
    (("#nav, #ft") (:display "block"
                             :color "#fff"))
    (("#nav a, #ft a") (:color "#fff"))
    (("#nav li") (:float "left"
                         :height "34px"
                         :min-width "108px"
                         :text-align "center"))
    (("#nav #prinav #join") (:float "right"))
    ;; prinav (top -> bottom: #3c668a -> #113152)
    (("#prinav") (:background "#3c668a"
                              :background "-moz-linear-gradient(top, #3c668a 0%, #113152 100%)"
                              :background "-webkit-gradient(linear, left top, left bottom, color-stop(0%,#3c668a), color-stop(100%,#113152))"
                              :background "-webkit-linear-gradient(top, #3c668a 0%,#113152 100%)"
                              :background "-o-linear-gradient(top, #3c668a 0%,#113152 100%)"
                              :background "-ms-linear-gradient(top, #3c668a 0%,#113152 100%)"
                              :background "linear-gradient(to bottom, #3c668a 0%,#113152 100%)"
                              :filter "progid:DXImageTransform.Microsoft.gradient(startColorstr='#3c668a', endColorstr='#113152',GradientType=0)"
                              :height "34px"))
    ;; prinav .selected (top -> bottom: #fff -> #ddd)
    (("#prinav .selected") (:background "#fff"
                                     :background "-moz-linear-gradient(top, #fff 0%, #ddd 100%)"
                                     :background "-webkit-gradient(linear, left top, left bottom, color-stop(0%,#fff), color-stop(100%,#ddd))"
                                     :background "-webkit-linear-gradient(top, #fff 0%,#ddd 100%)"
                                     :background "-o-linear-gradient(top, #fff 0%,#ddd 100%)"
                                     :background "-ms-linear-gradient(top, #fff 0%,#ddd 100%)"
                                     :background "linear-gradient(to bottom, #fff 0%,#ddd 100%)"
                                     :filter "progid:DXImageTransform.Microsoft.gradient(startColorstr='#fff', endColorstr='#ddd',GradientType=0)"))
    (("#prinav li.selected a") (:color "#333"))
    (("#prinav li") (:border-right "1px solid #333"))
    (("#prinav .cat ul") (:display "none"))
    ;; subnav (top -> bottom: #ddd -> #fff)
    (("#subnav") (:background "#ddd"
                              :background "-moz-linear-gradient(top, #ddd 0%, #fff 100%)"
                              :background "-webkit-gradient(linear, left top, left bottom, color-stop(0%,#ddd), color-stop(100%,#fff))"
                              :background "-webkit-linear-gradient(top, #ddd 0%,#fff 100%)"
                              :background "-o-linear-gradient(top, #ddd 0%,#fff 100%)"
                              :background "-ms-linear-gradient(top, #ddd 0%,#fff 100%)"
                              :background "linear-gradient(to bottom, #ddd 0%,#fff 100%)"
                              :filter "progid:DXImageTransform.Microsoft.gradient(startColorstr='#ddd', endColorstr='#fff',GradientType=0)"
                              :height "34px"
                              :border-bottom "1px solid #ebebeb"))
    (("#subnav .selected a") (:color "#333"))
    (("#subnav a") (:padding "0 20px"
                             :color "#21629c"))
    (("#prinav a:hover, #subnav a:hover") (:color "#eeb000"))

    ;; body and footer
    (("#wrapper") (:background "#FFF"
                               :clear "both"
                               :min-height "800px"))
    (("#bd") (:background-color "#FFF"
                                :padding-top "50px"))
    (("#ft") (:background "#3c668a"
                              :background "-moz-linear-gradient(top, #3c668a 0%, #113152 100%)"
                              :background "-webkit-gradient(linear, left top, left bottom, color-stop(0%,#3c668a), color-stop(100%,#113152))"
                              :background "-webkit-linear-gradient(top, #3c668a 0%,#113152 100%)"
                              :background "-o-linear-gradient(top, #3c668a 0%,#113152 100%)"
                              :background "-ms-linear-gradient(top, #3c668a 0%,#113152 100%)"
                              :background "linear-gradient(to bottom, #3c668a 0%,#113152 100%)"
                              :filter "progid:DXImageTransform.Microsoft.gradient(startColorstr='#3c668a', endColorstr='#113152',GradientType=0)"
                              :padding "20px 250px"
                              :height "50px"))
    (("#ft p") (:float "left"
                       :padding-right "25px"))

    ;; index
    (("#articles li") (:border-bottom "1px dotted"
                                      :border-color "#CCC"
                                      :margin-bottom "15px"))
    (("#articles .index-thumb") (:float "left"
                                        :padding-right "10px"))
    (("#articles .a-summary") (:color "#4a4a4a"
                                      :margin "0 0 10px 0"))

    ;; article
    (("#article img") (:display "block"
                                :padding-bottom "5px"))
    (("#article div.a-photo") (:padding "10px"
                                        :position "relative"))
    (("#article a.p-attribution") (:position "absolute"
                                             :right "30px"))
    (("#article p.p-title") (:text-align "center"
                                         :margin "15px 0 0 0"))
    (("#a-title") (:font-size "160%"))
    ((".a-cite") (:color "#999999"
                         :padding "2px 0"
                         :display "block"))
    (("#a-body") (:text-align "justify"
                              :padding-top "10px"))
    (("#a-body li") (:margin-bottom "15px"))
    (("#a-body div.a-photo") (:float "right"))
    (("#a-body .block") (:padding-bottom "10px"
                                         :text-align "center"))
    (("#a-body blockquote") (:background-color "#F0F0F0"
                                               :padding "10px"))
    (("#a-body li") (:background "url('/static/css/images/icon_bullet.png') 5px 2px no-repeat"
                                 :padding-left "25px"))
    (("#a-body img") (:padding "10px"))
    (("#related") (:border-top "1px dotted #ccc"
                               :margin-top "25px"
                               :padding-top "10px"))

    ;; comments
    (("#comments") (:margin-top "35px"
                                :padding-top "10px"
                                :border-top "1px dotted #ccc"
                                :position "relative"))
    (("#comments ul") (:margin-top "20px"))
    (("#comments li") (:border-bottom "1px dotted"
                                      :border-color "#CCC"
                                      :margin-bottom "15px"))
    (("#comments td") (:padding "5px 5px 5px 0"))
    (("#comments input, #comments textarea") (:border "3px solid #ddd"
                                                      :padding "7px"
                                                      :line-height "15px"
                                                      :border-radius "8px"
                                                      :width "225px"))

    (("#comments h3") (:padding "5px 0 15px"))
    ((".c-body") (:padding "10px"
                           :background-color "#f0f0f0"
                           :margin-top "-10px"))

    ;; carousel
    ((".carousel") (:font-size "12px"))
    ((".carousel h3") (:padding "10px 0"))
    ((".carousel p.prev") (:position "relative"
                                     :top "50px"
                                     :margin-right "35px"))
    ((".carousel p.next") (:position "relative"
                                     :top "-90px"))
    ((".carousel ul") (:height "140px"))
    ((".carousel ul li") (:list-style-type "none"
                                           :float "left"
                                           :width "120px"
                                           :margin "0 5px"))
    ((".carousel ul li div") (:width "100px"
                                     :height "100px"
                                     :margin "5px 0"))
    ((".carousel ul li div.no-photo") (:background-color "#F0F0F0"))

    ;; pagination
    ((".pagination") (:text-align "center"
                                  :padding "20px 0 0"))
    ((".pagination li") (:border "1px solid"
                                 :border-color "#F0F0F0"
                                 :border-radius "3px 3px 3px 3px"
                                 :display "inline"
                                 :margin "0 2px"
                                 :padding "2px 4px"
                                 :vertical-align "middle"))
    ((".pagination li a") (:color "#035583"
                                  :text-decoration "none"))
    ((".pagination .disabled") (:border "none"))
    ((".pagination-results") (:color "#999"
                                     :margin-bottom "20px"
                                     :text-align "center"))

    ;; devanagari
    ((".dvngr h2, .dvngr h3") (:padding-top "10px"))

    ;; sharethis.com
    ((".stpulldown-gradient")
     (:background "#E1E1E1"
                  :background "-moz-linear-gradient(top, '#E1E1E1' 0%, '#A7A7A7' 100%)"
                  :background "-webkit-gradient(linear, left top, left bottom, color-stop(0%, '#E1E1E1'), color-stop(100%, '#A7A7A7'))"
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
