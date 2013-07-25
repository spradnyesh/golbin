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
         (("html") (:color "#919191"
                           :background "#61a1f0"
                           :text-shadow "none"))
         (("body") (:border-top "5px solid #61a1f0"
                                :padding-top "10px"
                                :line-height "24px"))
         (("h1") (:font-weight "bold"
                               :font-size "160%"
                               :display "inline-block"))
         (("h2") (:font-weight "bold"
                               :font-size "140%"))
         (("h3") (:font-weight "bold"
                               :font-size "120%"))
         (("p") (:margin "16px 0"))
         (("a") (:text-decoration "none"
                                  :color "#61a1f0"
                                  :margin-right "7px"))
         (("a:hover") (:color "#8dba53 !important"))
         (("figure") (:margin "0"))
         ((".error") (:color "red"
                             :font-size "90%"
                             :padding "5px 0"))
         ((".dvngr") (:font-family "Mangal, Lohit Devanagari"))
         ((".wrapper") (:position "relative"
                                  :margin "0 auto"
                                  :padding "0"))
         ;; hd
         (("#hd") (:height "120px"))
         (("#logo") (:float "left"))
         (("#logo .langs") (:margin "-7px 0 0 40px"))
         (("#logo .langs a") (:font-size "80%"))
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
         ;; nav
         (("#nav") (:padding-top "40px"
                                 :text-align "right"))
         (("#nav li") (:float "left"
                              :margin "0 25px"
                              :text-align "center"))
         (("#nav li ul") (:display "none"))
         ;; home
         (("#articles") (:margin "0 50px"))
         (("#articles p") (:margin "0"))
         (("#articles ul li") (:min-height "50px"
                                       :border-bottom "1px dotted gray"
                                       :margin-bottom "10px"))
         (("#articles .crud") (:float "left"
                                      :padding-right "30px"
                                      :width "60px"))
         (("#articles .crud .delete") (:background-color "#fff"
                                                         :border "0"
                                                         :cursor "pointer"
                                                         :color "#61a1f0"))
         (("#articles .crud .delete:hover") (:color "#8dba53 !important"))
         (("#articles .index-thumb") (:float "left"
                                             :padding-right "10px"))
         (("#articles .a-title") (:color "#21629C"))
         (("#articles .a-title.deleted") (:text-decoration "line-through"))
         (("#articles .a-cite") (:font-size "80%"
                                            :color "#999999"
                                            :padding "2px 0"
                                            :display "block"))
         (("#articles .a-summary") (:color "#4a4a4a"))
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
                                               :padding "35px 0 0 100px"
                                               :font-size "34px"))
         (("#login") (:margin "30px 0 0 100px"))
         (("#login a") (:margin "0"))
         (("#login fieldset.inputs .label") (:display "block"))
         (("#login fieldset.inputs .input") (:border "3px solid #dedede"
                                                     :border-radius "8px"
                                                     :padding "7px 20px"
                                                     :outline "none"
                                                     :background-color "#fff"
                                                     :width "210px"
                                                     :height "34px"))
         (("#login fieldset.inputs .input:hover") (:border-color "#d5e6c0"))
         (("#login fieldset.inputs .input:focus") (:border-color "#61a1f0"))
         (("#submit") (:border-radius "20px"
                                      :border "3px solid #abcdef"
                                      :padding "7px 20px"
                                      :text-transform "uppercase"
                                      :background-color "#61a1f0"
                                      :color "#fff"
                                      :font-weight "bold"
                                      :font-size "12px"))
         (("#submit:hover") (:border-color "#d5e6c0"
                                           :background-color "#739c3e"))
         ;; article
         ((".wrapper") (:margin "0 25px"))
         ((".wrapper a") (:margin-right "0"))
         ((".wrapper table") (:table-layout "fixed"))
         ((".wrapper td") (:padding "10px 0"))
         ((".wrapper td.label") (:width "90px"))
         ((".wrapper input, .wrapper textarea") (:border "3px solid #dedede"
                                                         :padding "7px 20px"
                                                         :line-height "15px"
                                                         :border-radius "8px"))
         ((".wrapper table td input:hover, .wrapper table td textarea:hover") (:border-color "#d5e6c0"))
         ((".wrapper table td input:focus, .wrapper table td textarea:focus") (:border-color "#61a1f0"))
         ;; category
         (("#sort-catsubcat .cat") (:padding-left "20px"))
         (("#sort-catsubcat .subcat") (:padding-left "40px"))
         ;; upload photo pane
         (("#photo-pane") (:width "500px"
                                  :height "550px"
                                  :position "fixed"
                                  :top "100px"
                                  :left "250px"
                                  :border "3px solid #dedede"
                                  :border-radius "10px"
                                  :background-color "#fff"))
         (("#photo-pane p a.close") (:position "absolute"
                                               :top "0"
                                               :right "0"))
         (("#photo-pane ul") (:margin "20px 0 0 10px"
                                      :height "500px"))
         (("#photo-pane ul li") (:float "left"
                                        :height "125px"
                                        :margin "0 10px"
                                        :width "100px"
                                        :overflow "hidden"))
         (("#photo-pane ul li span") (:display "none"))
         (("#photo-pane ul li a") (:display "block"))
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
         ((".pagination .disabled") (:border "none"))))
