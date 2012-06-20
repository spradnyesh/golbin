(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CSS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-css ()
  (with-html
    (str (css
           ;; undo .yui3-g spacing
           ((".yui3-g") (:letter-spacing "normal" :word-spacing "normal"))
           ;; common
           (("body") (:width "1000px" :margin "0 auto"))
           ;; hd
           (("#banner") (:height "100px"))
           (("#banner h1") (:height "80px" :width "80px" :border "1px solid" :margin "20px"))
           ;; bd
           (("#bd") (:min-height "1000px"))
           ;; ft
           (("#ft") (:height "100px"))
           ;; nav
           (("#nav") (:height "50px"))
           (("#nav li") (:float "left" :width "250px" :text-align "center" :padding "10px 0"))
           (("#nav li h2") (:font-weight "bold" :font-size "140%"))
           (("#nav li ul") (:display "none"))
           ;; index pages
           (("#articles ul li") (:padding "5px"))
           (("#articles .a-title") (:font-weight "bold" :font-size "120%"))
           (("#articles .a-date") (:font-size "80%" :color "#AAA"))
           ;; article
           (("#a-title") (:font-weight "bold" :font-size "120%" :padding-bottom "10px"))
           (("#a-details") (:font-size "80%" :padding-bottom "10px"))
           ;; pagination
           (("#col-2 .pagination") (:margin "20px 150px"))
           (("#col-2 .pagination li") (:margin "0 10px" :display "inline" :font-weight "bold"))
           (("#col-2 .pagination .pagination-match") (:color "#AAA"))
           ))))
