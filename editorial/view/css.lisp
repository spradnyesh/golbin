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
    ;; undo .yui3-g css
    ((".yui3-g") (:letter-spacing "normal"
                                  :word-spacing "normal"
                                  :width "1000px"
                                  :margin "0 auto"
                                  :background-color "#FFFFFF"))
    (("input") (:font "inherit"))
    (("select") (:font "inherit"))
    (("textarea") (:font "inherit"))
    ;; common
    #|(("html") (:color "#919191"
    :background "#61a1f0"
    :text-shadow "none"))|#
         (("body") (:border-top "5px solid #61a1f0"
                                :padding-top "10px"))
         (("h1") (:font-weight "bold"
                               :font-size "160%"
                               :display "inline-block"))
         (("h2") (:font-weight "bold"
                               :font-size "140%"))
         (("h3") (:font-weight "bold"
                               :font-size "120%"))
         (("p") (:margin "16px 0"))
         (("a") (:text-decoration "none"
                                  :color "#61a1f0"))
         (("a:hover") (:color "#8dba53"))
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
                                      :background-color "#61a1f0"
                                      :color "#fff"
                                      :font-weight "bold"
                                      :font-size "12px"))
         ((".submit:hover") (:border-color "#afdc75"
                                           :background-color "#8dba53"
                                           :color "#fff"))
         ;; hd
         (("#hd") (:height "120px"
                           :margin-top "40px"))
         (("#logo") (:float "left"
                            :margin-top "-40px"
                            :width "200px"))
         (("#logo .langs") (:margin "-7px 0 0 40px"))
         (("#logo .langs a") (:margin-right "7px"))
         ;; nav
         ((".prinav") (:float "left"
                              :width "100px"))
         ((".prinav.wide") (:width "175px"))
         ((".prinav h2") (:color "#61a1f0"
                                 :cursor "pointer"))
         ((".prinav h2:hover") (:color "#8dba53"))
         ((".subnav") (:display "none"
                                :z-index "99"))
         ((".subnav li") (:padding "5px 0"))
         ;; bd
         (("#bd") (:min-height "500px"))
         ;; ft
         (("#ft") (:font-size "12px"
                              :line-height "22px"
                              :color "#fff"
                              :background-color "#61a1f0"
                              :margin-top "30px"
                              :padding "20px"
                              :border-top "5px solid #dfeefd"))
         (("#ft a") (:color "#fff"))
         (("#ft h5") (:font-size "15px"
                                 :line-height "52px"
                                 :margin-bottom "23px"
                                 :text-transform "uppercase"))
         ;; home
         (("#articles p") (:margin "0"))
         (("#articles li") (:min-height "50px"
                                        :border-bottom "1px dotted gray"
                                        :padding "10px"))
         (("#articles li.draft") (:background-color "#dfeefd"))
         (("#articles li.submitted") (:background-color "#ddffcc"))
         (("#articles .crud") (:float "left"
                                      :padding-right "30px"
                                      :width "60px"))
         (("#articles .crud .delete") (:background-color "#fff"
                                                         :border "0"
                                                         :cursor "pointer"
                                                         :color "#61a1f0"
                                                         :padding "5px 0"
                                                         :margin-left "-3px"))
         (("#articles .crud .delete:hover") (:color "#8dba53"))
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
         (("#login-sub-hd") (:background-color "#99c165"
                                               :color "white"
                                               :border-top "5px solid #edf4e5"
                                               :border-bottom "5px solid #edf4e5"
                                               :box-shadow "inset 0 0 15px 0 #739c3e"
                                               :height "55px"
                                               :padding "20px 0 0 100px"
                                               :font-size "34px"))
         (("#login") (:margin "30px 0 0 100px"))
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
         ;; upload photo pane
         (("#pane") (:width "540px"
                            :min-height "100px"
                            :position "fixed"
                            :top "100px"
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
         (("#accounts label") (:display "block"
                                        :margin "5px 0"))

         #- (and)
         ;; loading (http://cssload.net/)
         (((".bubblingG") (:text-align "center"
                                        :width "80px"
                                        :height "50px"))
          ((".bubblingG span") (:display "inline-block"
                                         :vertical-align "middle"
                                         :width "10px"
                                         :height "10px"
                                         :margin "25px auto"
                                         :background "#000000"
                                         :-moz-border-radius "50px"
                                         :-moz-animation "bubblingG 1.3s infinite alternate"
                                         :-webkit-border-radius "50px"
                                         :-webkit-animation "bubblingG 1.3s infinite alternate"
                                         :-ms-border-radius "50px"
                                         :-ms-animation "bubblingG 1.3s infinite alternate"
                                         :-o-border-radius "50px"
                                         :-o-animation "bubblingG 1.3s infinite alternate"
                                         :border-radius "50px"
                                         :animation "bubblingG 1.3s infinite alternate"))
          (("#bubblingG_1") (:-moz-animation-delay "0s"
                                                   :-webkit-animation-delay "0s"
                                                   :-ms-animation-delay "0s"
                                                   :-o-animation-delay "0s"
                                                   :animation-delay "0s"))
          (("#bubblingG_2") (:-moz-animation-delay "0.39s"
                                                   :-webkit-animation-delay "0.39s"
                                                   :-ms-animation-delay "0.39s"
                                                   :-o-animation-delay "0.39s"
                                                   :animation-delay "0.39s"))
          (("#bubblingG_3") (:-moz-animation-delay "0.78s"
                                                   :-webkit-animation-delay "0.78s"
                                                   :-ms-animation-delay "0.78s"
                                                   :-o-animation-delay "0.78s"
                                                   :animation-delay "0.78s"))
          (("@-moz-keyframes bubblingG") ((("0%")
                                           (:width "10px"
                                                   :height "10px"
                                                   :background-color "#000000"
                                                   :-moz-transform "translateY(0)"))
                                          (("100%")
                                           (:width "24px"
                                                   :height "24px"
                                                   :background-color "#FFFFFF"
                                                   :-moz-transform "translateY(-21px)"))))
          (("@-webkit-keyframes bubblingG") ((("0%")
                                              (:width "10px"
                                                      :height "10px"
                                                      :background-color "#000000"
                                                      :-webkit-transform "translateY(0)"))
                                             (("100%")
                                              (:width "24px"
                                                      :height "24px"
                                                      :background-color "#FFFFFF"
                                                      :-webkit-transform "translateY(-21px)"))))
          (("@-ms-keyframes bubblingG") ((("0%")
                                          (:width "10px"
                                                  :height "10px"
                                                  :background-color "#000000"
                                                  :-ms-transform "translateY(0)"))
                                         (("100%")
                                          (:width "24px"
                                                  :height "24px"
                                                  :background-color "#FFFFFF"
                                                  :-ms-transform "translateY(-21px)"))))
          (("@-o-keyframes bubblingG") ((("0%")
                                         (:width "10px"
                                                 :height "10px"
                                                 :background-color "#000000"
                                                 :-o-transform "translateY(0)"))
                                        (("100%")
                                         (:width "24px"
                                                 :height "24px"
                                                 :background-color "#FFFFFF"
                                                 :-o-transform "translateY(-21px)"))))
          (("@keyframes bubblingG") ((("0%")
                                      (:width "10px"
                                              :height "10px"
                                              :background-color "#000000"
                                              :transform "translateY(0)"))
                                     (("100%")
                                      (:width "24px"
                                              :height "24px"
                                              :background-color "#FFFFFF"
                                              :transform "translateY(-21px)")))))))
