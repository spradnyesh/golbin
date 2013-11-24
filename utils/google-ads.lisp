(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro ads-markup (client slot width height)
  `(<:div :class "lazyload_ad" :original "http://pagead2.googlesyndication.com/pagead/show_ads.js"
           (<:code :type "text/javascript"
                   (format nil
                           "<!-- google_ad_client = '~a'; google_ad_slot = '~a'; google_ad_width = ~a; google_ad_height = ~a; //-->"
                           ,client
                           ,slot
                           ,width
                           ,height))))

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

(defun remove-inline-ads (body markup)
  (regex-replace (concatenate 'string
                              "</p>"
                              markup)
                 body
                 "</p>"))
