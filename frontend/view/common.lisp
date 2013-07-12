(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro article-carousel-container (title a-href list url)
  `(when ,list
     (<:div :class "carousel"
           (<:h3 ,title
                " "
                ,a-href)
           ;; page number, and typeof for the next ajax call
           (<:span :class "hidden" (format t "2, ~a" ,url))
           (<:p :class "prev left" (<:a :href "" "prev"))
           (<:div :class "prev hidden")
           (<:div :class "current"
                 (article-carousel-markup
                        (splice ,list :to (1- (min (length ,list)
                                                   related-length)))))
           (<:div :class "next hidden"
                 (article-carousel-markup
                        (splice ,list
                                :from related-length
                                :to (1- (* 2 related-length)))))
           (<:p :class "next right" (<:a :href "" "next")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun article-carousel-markup (article-list)
  (when article-list
    (<:ul :class "related"
         (dolist (article article-list)
           (<:li
            (if (photo article)
                (<:div :class "related-thumb"
                      (article-lead-photo-url (photo article) "related-thumb"))
                (<:div :class "related-thumb no-photo"))
            (<:a :class "a-title"
                :href (h-genurl 'r-article
                                :slug-and-id (format nil "~A-~A"
                                                     (slug article)
                                                     (id article)))
                (title article)))))))
