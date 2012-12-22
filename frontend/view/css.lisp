(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CSS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun fe-get-css ()
  (with-html
    (str (css ; http://travel.yahoo.com/ideas/ http://travel.yahoo.com/ideas/five-miles-up-with-----christopher-gorham.html
           ;; necessary
           ((".clearfix:before, .clearfix:after")
            (:content "." :display "block" :font-size 0 :height 0 :line-height 0 :visibility "hidden" :clear "both"))
           ;; undo .yui3-g spacing and colors
           ((".yui3-g") (:letter-spacing "normal" :word-spacing "normal" :color "#000000" :background-color "#CBDDEB" :width "1000px" :margin "0 auto"))
           ;; common
           (("body") (:background-color "#CBDDEB"))
           (("h2") (:font-weight "bold" :font-size "140%"))
           (("h3") (:font-weight "bold" :font-size "120%"))
           (("small") (:font-size "80%"))
           (("a") (:text-decoration "none" :color "blue"))
           ((".block") (:display "block"))
           ((".left") (:float "left"))
           ((".right") (:float "right"))
           ((".hidden") (:display "none"))
           ;; hd
           (("#banner") (:height "100px"))
           (("#banner h1") (:height "80px" :width "80px" :border "1px solid"))
           (("#nav") (:margin "20px 30px 20px 20px" :background-color "#CBDDEB"))
           (("#nav li") (:border "1px solid white" :border-right "0" :float "left" :padding "5px 20px" :background-color "#DDD"))
           (("#nav a") (:color "white"))
           (("#nav .selected") (:background-color "#FFF"))
           (("#nav .selected a") (:color "#DDD"))
           (("#prinav") (:height "32px"))
           (("#prinav li:last-child") (:border-right "1px solid white"))
           (("#prinav .cat ul") (:display "none"))
           (("#subnav") (:height "29px" :margin-left "50px"))
           (("#subnav li") (:border-top "0"))
           (("#subnav li:last-child") (:border-right "1px solid white"))
           ;; bd
           (("#bd") (:background-color "#FFF"))
           (("#container") (:padding "20px" :min-height "800px" :border "1px solid red"))
           ;; ft
           (("#ft") (:margin "50px 0 0 250px" :color "#999"))
           (("#ft p") (:float "left" :padding-right "10px"))
           ;; index pages
           #|(("#articles") (:padding-top "20px" :border-top "3px solid #B5B5B5"))|#
           (("#articles ul li") (:padding "10px 0" :border-bottom "1px dotted" :border-color "#CCC"))
           (("#articles .index-thumb") (:float "left" :padding-right "10px"))
           (("#articles .a-title") (:color "#21629C"))
           (("#articles .a-cite") (:font-size "80%" :color "#999999" :padding "2px 0" :display "block"))
           (("#articles .a-summary") (:color "#4a4a4a"))
           ;; article
           (("#article") (:margin-bottom "50px"))
           (("#a-title") (:padding-bottom "10px"))
           (("#a-details") (:padding-bottom "10px"))
           (("#a-body .block") (:padding-bottom "10px"))
           (("#a-body .left") (:padding-bottom "10px" :padding-right "10px"))
           (("#a-body .right") (:padding-bottom "10px" :padding-left "10px"))
           (("#a-body blockquote") (:background-color "#DDD" :padding "10px"))
           (("#a-comments") (:margin-top "25px"))
           (("#a-comments .comment") (:padding-left "10px"))
           (("#c-table") (:display "none"))
           ;; carousel
           ((".carousel h3") (:padding "10px 0"))
           ((".carousel p.prev") (:position "relative" :top "50px"))
           ((".carousel p.next") (:position "relative" :top "-90px"))
           ((".carousel .related") (:height "140px"))
           ((".carousel .related li") (:list-style-type "none" :float "left" :width "120px" :margin "0 10px"))
           ;; pagination
           ((".pagination") (:text-align "center" :padding "20px 0 10px"))
           ((".pagination li") (:margin-right "10px" :display "inline" :font-size "93%" :border "1px solid" :border-color "#DDD" :border-radius "3px 3px 3px 3px" :margin "0 2px" :padding "2px 4px" :vertical-align "middle"))
           ((".pagination li a") (:text-decoration "none" :color "#035583"))
           ((".pagination .disabled") (:border "none"))
           ((".pagination-results") (:text-align "center" :margin-bottom "20px"))

           ;; sharethis.com
           ((".stpulldown-gradient") (:background "#E1E1E1"
                                                  :background "-moz-linear-gradient(top, '#E1E1E1' 0%, '#A7A7A7' 100%)" ; /* firefox */
                                                  :background "-webkit-gradient(linear, left top, left bottom, color-stop(0%, '#E1E1E1'), color-stop(100%, '#A7A7A7'))" ; /* webkit */
                                                  :filter "progid:DXImageTransform.Microsoft.gradient( startColorstr='#E1E1E1', endColorstr='#A7A7A7',GradientType=0 )" ; /* ie */
                                                  :background "-o-linear-gradient(top, '#E1E1E1' 0%, '#A7A7A7' 100%)" ; /* opera */
                                                  :color "#636363"))
           (("#stpulldown .stpulldown-logo") (:height "40px"
                                                      :width "300px"
                                                      :margin-left "20px"
                                                      :margin-top "5px"
                                                      :background "url('http://sd.sharethis.com/disc/images/Logo_Area.png') no-repeat"))))))
