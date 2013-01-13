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
           (("h2") (:font-weight "bold" :font-size "140%"))
           (("h3") (:font-weight "bold" :font-size "120%"))
           (("a") (:text-decoration "none"))
           ((".yui3-g") (:width "1000px" :margin "0 auto" :background-color "#FFFFFF"))
           ((".error") (:color "red" :font-size "90%" :padding "5px 0"))
           ;; hd
           (("#banner") (:height "100px"))
           (("#banner h1") (:height "80px" :width "80px" :border "1px solid"))
           ;; bd
           (("#bd") (:min-height "800px"))
           ;; ft
           (("#ft") (:height "100px"))
           ;; nav
           (("#nav") (:height "50px"))
           (("#nav li") (:float "left" :margin "0 25px" :text-align "center" :padding "10px 0"))
           (("#nav li ul") (:display "none"))
           ;; home
           (("#articles ul li") (:height "70px"))
           (("#articles .crud") (:float "left" :padding-right "10px" :width "60px"))
           (("#articles .index-thumb") (:float "left" :padding-right "10px"))
           (("#articles .a-title") (:color "#21629C"))
           (("#articles .a-title.deleted") (:text-decoration "line-through"))
           (("#articles .a-cite") (:font-size "80%" :color "#999999" :padding "2px 0" :display "block"))
           (("#articles .a-summary") (:color "#4a4a4a"))
           ;; article
           (("#a-title") (:font-weight "bold" :font-size "120%" :padding-bottom "10px"))
           (("#a-details") (:font-size "80%" :padding-bottom "10px"))
           ;; category
           (("#sort-catsubcat .cat") (:padding-left "20px"))
           (("#sort-catsubcat .subcat") (:padding-left "40px"))
           ;; upload photo pane
           (("#photo-pane") (:width "500px" :height "550px" :position "fixed" :top "100px" :left "250px" :border "1px solid red" :background-color "#CCCCCC"))
           (("#photo-pane p a.close") (:position "absolute" :top "0" :right "0"))
           (("#photo-pane ul") (:margin "20px 0 0 10px" :height "500px"))
           (("#photo-pane ul li") (:float "left" :height "125px" :margin "0 10px" :width "100px" :overflow "hidden"))
           (("#photo-pane ul li span") (:display "none"))
           (("#photo-pane ul li a") (:display "block"))
           ;; pagination
           ((".pagination") (:text-align "center" :padding "20px 0 30px"))
           ((".pagination li") (:margin-right "10px" :display "inline" :font-size "93%" :border "1px solid" :border-color "#DDD" :border-radius "3px 3px 3px 3px" :margin "0 2px" :padding "2px 4px" :vertical-align "middle"))
           ((".pagination li a") (:text-decoration "none" :color "#035583"))
           ((".pagination .disabled") (:border "none"))
           ))))
