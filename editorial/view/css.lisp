(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CSS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ed-get-css ()
  (css ; http://travel.yahoo.com/ideas/ http://travel.yahoo.com/ideas/five-miles-up-with-----christopher-gorham.html
    ;; necessary
    ((".clearfix:before, .clearfix:after") (:content "."
                                                     :display "block"
                                                     :font-size 0
                                                     :height 0
                                                     :line-height 0
                                                     :visibility "hidden"
                                                     :clear "both"))
    ((".right") (:float "right"))
    ((".left") (:float "left"))
    ;; undo .yui3-g css
    ((".yui3-g") (:letter-spacing "normal"
                                  :word-spacing "normal"
                                  :width "1200px"
                                  :margin "0 auto"))
    (("input") (:font "inherit"))
    ((".label") (:margin-right "20px"))
    (("select") (:font "inherit"))
    (("textarea") (:font "inherit"))
    ;; common
    (("html") (:background "#cbddeb url('/static/css/images/travel_bg_clouds.jpg') repeat-x"
                           :color "#333"
                           :font-family "'Ubuntu',Arial,sans-serif"
                           :font-size "14px"
                           :line-height "21px"
                           :margin "0 auto"
                           :min-width "1200px"))
    (("h1") (:font-weight "bold"
                          :font-size "160%"
                          :display "inline-block"
                          :margin-bottom "10px"))
    (("p") (:margin "16px 0"))
    (("a") (:text-decoration "none"
                             :color "#3c668a"))
    (("a:hover") (:color "#113152"))
    (("figure") (:margin "0"))
    (("strong") (:font-weight "bold"))
    (("input, textarea") (:border "3px solid #ddd"
                                  :padding "7px 20px"
                                  :line-height "15px"
                                  :border-radius "8px"))
    (("input:hover, textarea:hover") (:border-color "#d5e6c0"))
    (("input:focus, textarea:focus") (:border-color "#61a1f0"))
    (("table") (:table-layout "fixed"
                              :border-collapse "inherit"
                              :border-spacing "5px"))
    (("td") (:padding "10px 10px"))
    ((".t-head") (:color "#fff"
                         :background-color "#61a1f0"))
    ((".t-head .tooltip") (:color "#fff"))
    ((".t-odd"))
    ((".t-even") (:background-color "#dfeefd"))
    ((".hidden") (:display "none"))
    ((".error") (:color "#f66"
                        :font-size "90%"
                        :padding "5px 0"))
    ((".small") (:font-size "80%"))
    ((".dvngr") (:font-family "Lohit Devanagari"))
    ((".yes, .no") (:color "#fff"
                           :text-align "center"))
    ((".yes") (:background-color "#8dba53"))
    ((".no") (:color "#fff"
                     :background-color "#f66"))
    ((".wrapper") (:emacs-position "relative"
                                   :margin "0 25px"
                                   :padding "0"))
    ((".mandatory") (:color "#f66"
                            :padding "5px"))
    ;; static pages
    ((".static ul") (:list-style "disc inside none"
                                 :margin-left "25px"))
    ((".static ol") (:list-style "decimal inside none"
                                 :margin-left "25px"))
    ((".static li") (:padding "5px"))
    ((".static p") (:margin "10px 0"))
    ((".static .section") (:margin "10px 0"
                                    :border-bottom "1px dotted gray"))
    ((".static h2, .static h3") (:font-weight "bold"
                                              :padding-bottom "5px"
                                              ))
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
    ((".submit") (:border-radius "20px"
                                 :border "3px solid #abcdef"
                                 :padding "7px 20px"
                                 :text-transform "uppercase"
                                 :background-color "#3c668a"
                                 :color "#fff"
                                 :font-weight "bold"
                                 :font-size "12px"))
    ((".submit:hover") (:border-color "#3c668a"
                                      :background-color "#113152"
                                      :color "#fff"))
    ;; hd
    (("#hd") (:height "200px"))
    ;; banner
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
    ;; nav
    (("#nav") (:margin "0"
                         :padding "0"
                         :list-style "none"))
    (("#nav li") (:display "block"
                             :position "relative"
                             :float "left"))
    (("#nav li ul") (:display "none"))
    (("#nav li a") (:display "block"
                               :text-decoration "none"
                               :color "#fff"
                               :padding "9px 0"
                               :width "199px"
                               :white-space "nowrap"))
    (("#nav a:hover") (:color "#eeb000"))
    (("#nav li:hover ul") (:display "block"
                                      :position "absolute"
                                      :z-index "2"))
    (("#nav li:hover li") (:float "none"
                                    :font-size "11px"))
    ((".prinav") (:background "#3c668a"
                              :background "-moz-linear-gradient(top, #3c668a 0%, #113152 100%)"
                              :background "-webkit-gradient(linear, left top, left bottom, color-stop(0%,#3c668a), color-stop(100%,#113152))"
                              :background "-webkit-linear-gradient(top, #3c668a 0%,#113152 100%)"
                              :background "-o-linear-gradient(top, #3c668a 0%,#113152 100%)"
                              :background "-ms-linear-gradient(top, #3c668a 0%,#113152 100%)"
                              :background "linear-gradient(to bottom, #3c668a 0%,#113152 100%)"
                              :filter "progid:DXImageTransform.Microsoft.gradient(startColorstr='#3c668a', endColorstr='#113152',GradientType=0)"
                              :height "34px"))
    ((".prinav") (:text-align "center"
                              :border-right "1px solid #333"))
    ((".subnav li") (:background "#ddd"
                              :background "-moz-linear-gradient(top, #ddd 0%, #fff 100%)"
                              :background "-webkit-gradient(linear, left top, left bottom, color-stop(0%,#ddd), color-stop(100%,#fff))"
                              :background "-webkit-linear-gradient(top, #ddd 0%,#fff 100%)"
                              :background "-o-linear-gradient(top, #ddd 0%,#fff 100%)"
                              :background "-ms-linear-gradient(top, #ddd 0%,#fff 100%)"
                              :background "linear-gradient(to bottom, #ddd 0%,#fff 100%)"
                              :filter "progid:DXImageTransform.Microsoft.gradient(startColorstr='#ddd', endColorstr='#fff',GradientType=0)"
                              :height "34px"
                              :border-bottom "1px solid #ebebeb"))
    (("#nav .subnav li a") (:color "#333"))
    (("#nav .subnav li a:hover") (:color "#eeb000"))

    ;; bd
    (("#bd") (:min-height "500px"
                          :position "relative"
                          :padding "20px 0"
                          :background-color "#FFFFFF"))
    ;; ft
    (("#ft") (:color "#fff"
                     :background "#3c668a"
                     :background "-moz-linear-gradient(top, #3c668a 0%, #113152 100%)"
                     :background "-webkit-gradient(linear, left top, left bottom, color-stop(0%,#3c668a), color-stop(100%,#113152))"
                     :background "-webkit-linear-gradient(top, #3c668a 0%,#113152 100%)"
                     :background "-o-linear-gradient(top, #3c668a 0%,#113152 100%)"
                     :background "-ms-linear-gradient(top, #3c668a 0%,#113152 100%)"
                     :background "linear-gradient(to bottom, #3c668a 0%,#113152 100%)"
                     :filter "progid:DXImageTransform.Microsoft.gradient(startColorstr='#3c668a', endColorstr='#113152',GradientType=0)"
                     :padding "20px 190px"
                     :height "50px"))
    (("#ft a") (:color "#fff"))
    (("#ft p") (:float "left"
                       :padding-right "35px"))
    ;; home
    (("#articles p") (:margin "0"))
    (("#articles li") (:min-height "50px"
                                   :border-bottom "1px dotted gray"
                                   :padding "10px"))
    (("#articles li.draft") (:background-color "#dfeefd"))
    (("#articles li.submitted") (:background-color "#ddffcc"))
    (("#articles .crud") (:float "left"
                                 :padding "10px 30px 0 0"
                                 :width "60px"))
    (("#articles .crud .delete") (:background-color "#fff"
                                                    :border "0"
                                                    :cursor "pointer"
                                                    :color "#3c668a"
                                                    :padding "5px 0"
                                                    :margin-left "-3px"))
    (("#articles .crud .delete:hover") (:color "#113152"))
    ((".index-thumb") (:float "left"
                              :padding-right "10px"))
    (("#articles .a-title") (:color "#21629C"))
    (("#articles .a-title.deleted") (:text-decoration "line-through"))
    (("#articles .a-summary") (:color "#4a4a4a"))
    ;; article
    (("#article td.label") (:width "90px"))
    ;; login
    ((".lang-selected") (:background-color "#99c165"
                                           :padding "0 5px"
                                           :color "#fff"
                                           :border-radius "8px"))
    (("#login") (:margin-left "100px"))
    (("#login a") (:margin "0"))
    (("#login fieldset.inputs .label") (:display "block"))
    (("#login fieldset.inputs .input") (:border "3px solid #ddd"
                                                :border-radius "8px"
                                                :padding "7px 20px"
                                                :outline "none"
                                                :background-color "#fff"
                                                :width "210px"
                                                :height "34px"))
    (("#login fieldset.inputs .input:hover") (:border-color "#d5e6c0"))
    (("#login fieldset.inputs .input:focus") (:border-color "#61a1f0"))
    ;; category
    (("#sort-catsubcat .cat") (:padding-left "20px"))
    (("#sort-catsubcat .subcat") (:padding-left "40px"))
    ;;  pane
    (("#pane") (:width "540px"
                       :min-height "100px"
                       :position "absolute"
                       :top "200px"
                       :left "250px"
                       :border "3px solid #ddd"
                       :border-radius "10px"
                       :background-color "#fff"))
    (("#pane a.close") (:position "absolute"
                                  :top "20px"
                                  :right "20px"))
    (("#pane .message") (:margin "50px 20px 20px"))
    (("#pane ul.photo") (:margin "20px 0 0 10px"
                                 :height "500px"))
    (("#pane ul.photo li") (:float "left"
                                   :height "130px"
                                   :margin "0 10px"
                                   :width "100px"
                                   :overflow "hidden"))
    (("#pane ul.photo li span") (:display "none"))
    (("#pane ul.photo li a") (:display "block"))
    (("#loading") (:width "128px"
                          :height "128px"
                          :position "absolute"
                          :top "200px"
                          :left "400px"
                          :border "0"))
    (("#loading a.close") (:display "none"))
    ;; pagination
    ((".pagination-results") (:text-align "center"))
    ((".pagination") (:text-align "center"
                                  :padding "20px 0 30px"))
    ((".pagination li") (:margin-right "10px"
                                       :display "inline"
                                       :font-size "93%"
                                       :border "1px solid"
                                       :border-color "#DDD"
                                       :border-radius "3px 3px 3px 3px"
                                       :margin "0 2px"
                                       :padding "2px 4px"
                                       :vertical-align "middle"))
    ((".pagination li a") (:text-decoration "none"
                                            :color "#035583"))
    ((".pagination .disabled") (:border "none"))
    ((".pagination .prev") (:position "absolute"
                                      :left "20px"))
    ((".pagination .next") (:position "absolute"
                                      :right "20px"))
    ;; approve articles
    (("#approve .crud > div") (:float "left"
                                      :width "40%"))
    (("#approve h3") (:display "inline"))
    (("#approve span") (:padding-left "5px"
                                      :color "#aaa"
                                      :position "absolute"))
    (("#approve input") (:float "left"
                                :background-color "#fff"
                                :border "0"
                                :cursor "pointer"
                                :color "#61a1f0"
                                :padding "0 10px 0 0"))
    (("#approve li") (:height "20px"
                              :padding "10px 0"
                              :border-bottom "1px dotted gray"))
    ;; accounts
    (("#accounts") (:margin "0 20px"))
    (("#accounts label") (:margin "5px 0"))))
