(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro ads-markup (client slot width height)
  `(<:div :class "g-ad"
          (<:ins :class "adsbygoogle"
                 :style (concatenate 'string
                                     "display:inline-block;width:"
                                     (write-to-string ,width)
                                     "px;height:"
                                     (write-to-string ,height)
                                     "px")
                 :data-ad-client ,client
                 :data-ad-slot ,slot)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun insert-inline-ads (body markup)
  (let ((mid (floor (/ (length body) 2))))
    (concatenate 'string
                 (subseq body
                         0
                         mid)
                 (regex-replace "</p>"
                                body
                                (concatenate 'string
                                             "</p>"
                                             markup)
                                :start mid))))

(defun remove-inline-ads (body)
  (regex-replace "<div id=\"i-ads\".*<\/div><\/div>"
                 body
                 ""))
