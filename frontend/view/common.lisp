(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro article-carousel-container (title a-href list url)
  `(when ,list
     (with-html
       (:div :class "carousel"
             (:h3 (str ,title)
                  " "
                  ,a-href)
             ;; page number, and typeof for the next ajax call
             (:span :class "hidden" (format t "2, ~a" ,url))
             (:p :class "prev left" (:a :href "" "prev"))
             (:div :class "prev hidden")
             (:div :class "current"
                   (str (article-carousel-markup
                         (splice ,list :to (min (length ,list)
                                                (1- related-length))))))
             (:div :class "next hidden"
                   (str (article-carousel-markup
                         (splice ,list
                                 :from related-length
                                 :to (1- (* 2 related-length))))))
             (:p :class "next right" (:a :href "" "next"))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun article-carousel-markup (article-list)
  (with-html
    (:ul :class "related"
          (dolist (article article-list)
            (htm (:li
                  (when (photo article)
                    (htm (:div :class "related-thumb"
                               (str (article-lead-photo-url (photo article) "related-thumb")))))
                  (:a :class "a-title"
                      :href (genurl 'r-article
                                    :slug-and-id (format nil "~A-~A"
                                                         (slug article)
                                                         (id article)))
                      (str (title article)))))))))