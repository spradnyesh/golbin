(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CSS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ed-get-css ()
  (with-html
    (str (css ; http://travel.yahoo.com/ideas/ http://travel.yahoo.com/ideas/five-miles-up-with-----christopher-gorham.html
           ;; necessary
           ((".clearfix:before, .clearfix:after")
            (:content "." :display "block" :font-size 0 :height 0 :line-height 0 :visibility "hidden" :clear "both"))
           ;; undo .yui3-g spacing
           ((".yui3-g") (:letter-spacing "normal" :word-spacing "normal"))
           ;; common
           (("body") (:color "#000000" :background-color "#CBDDEB"))
           (("a") (:text-decoration "none"))
           ((".yui3-g") (:width "1000px" :margin "0 auto" :background-color "#FFFFFF"))
           ;; hd
           (("#banner") (:height "100px"))
           (("#banner h1") (:height "80px" :width "80px" :border "1px solid"))
           ;; bd
           (("#bd") (:min-height "800px"))
           ;; ft
           (("#ft") (:height "100px"))
           ;; nav
           (("#nav") (:height "50px"))
           (("#nav li") (:float "left" :width "250px" :text-align "center" :padding "10px 0"))
           (("#nav li h2") (:font-weight "bold" :font-size "140%"))
           (("#nav li ul") (:display "none"))
           ;; index pages
           #|(("#articles") (:padding-top "20px" :border-top "3px solid #B5B5B5"))|#
           (("#articles ul li") (:padding "10px 0" :border-bottom "1px dotted" :border-color "#CCC"))
           (("#articles .a-title") (:font-weight "bold" :font-size "120%" :color "#21629C"))
           (("#articles .a-cite") (:font-size "80%" :color "#999999" :padding "2px 0" :display "block"))
           (("#articles .a-summary") (:color "#4a4a4a"))
           ;; article
           (("#a-title") (:font-weight "bold" :font-size "120%" :padding-bottom "10px"))
           (("#a-details") (:font-size "80%" :padding-bottom "10px"))
           ;; upload photo pane
           (("#photo-pane") (:width "500px" :height "500px" :position "fixed" :top "100px" :left "250px" :border "1px solid red" :background-color "#CCCCCC"))
           (("#photo-pane p") (:float "right"))
           (("#photo-pane ul") (:margin "20px 0 0 10px"))
           (("#photo-pane ul li") (:float "left" :height "120px" :padding "0 10px"))
           (("#photo-pane ul li span") (:display "none"))
           ;; pagination
           (("#col-2 .pagination") (:text-align "center" :padding "20px 0 30px"))
           (("#col-2 .pagination li") (:margin-right "10px" :display "inline" :font-size "93%" :border "1px solid" :border-color "#DDD" :border-radius "3px 3px 3px 3px" :margin "0 2px" :padding "2px 4px" :vertical-align "middle"))
           (("#col-2 .pagination li a") (:text-decoration "none" :color "#035583"))
           (("#col-2 .pagination .disabled") (:border "none"))
           ))))
