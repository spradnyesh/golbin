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
           ;; undo .yui3-g spacing
           ((".yui3-g") (:letter-spacing "normal" :word-spacing "normal"))
           ;; common
           (("h2") (:font-weight "bold" :font-size "140%"))
           (("h3") (:font-weight "bold" :font-size "120%"))
           (("small") (:font-size "80%"))
           (("body") (:color "#000000" :background-color "#CBDDEB"))
           (("a") (:text-decoration "none"))
           ((".yui3-g") (:width "1000px" :margin "0 auto" :background-color "#FFFFFF"))
           ((".block") (:display "block"))
           ((".left") (:float "left"))
           ((".right") (:float "right"))
           ((".hidden") (:display "none"))
           ;; hd
           (("#banner") (:height "100px"))
           (("#banner h1") (:height "80px" :width "80px" :border "1px solid"))
           (("#prinav") (:height "25px"))
           (("#prinav li") (:float "left" :padding "0 5px"))
           (("#prinav .cat ul") (:display "none"))
           (("#subnav") (:height "25px"))
           (("#subnav .subcat") (:float "left" :padding "0 5px"))
           ;; bd
           (("#bd") (:min-height "800px"))
           ;; ft
           (("#ft") (:height "100px"))
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
           ;; article
           ((".carousel h3") (:padding "10px 0"))
           ((".carousel p.prev") (:position "relative" :top "50px"))
           ((".carousel p.next") (:position "relative" :top "-90px"))
           ((".carousel .related") (:height "140px"))
           ((".carousel .related li") (:list-style-type "none" :float "left" :width "120px" :margin "0 10px"))
           ;; pagination
           (("#col-2 .pagination") (:text-align "center" :padding "20px 0 30px"))
           (("#col-2 .pagination li") (:margin-right "10px" :display "inline" :font-size "93%" :border "1px solid" :border-color "#DDD" :border-radius "3px 3px 3px 3px" :margin "0 2px" :padding "2px 4px" :vertical-align "middle"))
           (("#col-2 .pagination li a") (:text-decoration "none" :color "#035583"))
           (("#col-2 .pagination .disabled") (:border "none"))
           ))))
