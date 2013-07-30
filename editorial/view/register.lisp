(in-package :hawksbill.golbin.editorial)

(defun random-digits (&optional (n 4))
  (loop
     for i from 1 to n
     collecting (write-to-string (random 10)) into a
     finally (return (apply #'concatenate 'string a))))

(defun put-space-at-center (string)
  (let ((len-by-2 (/ (length string) 2)))
    (concatenate 'string
                 (subseq string 0 len-by-2)
                 " "
                 (subseq string len-by-2))))

(defun create-code-map ()
  (loop for i from 1 to 50 collect (put-space-at-center (random-digits))))

(defun create-code-map-image (code-map author-handle)
  (with-image* (400 235)
    (allocate-color 255 255 255)                 ; background: white
    (with-default-color ((allocate-color 0 0 0)) ; font: black
      (with-default-font (:medium)
        (let ((row 0)
              (col 0)
              (col-pad 75)
              (row-pad 20)
              (i 1))
          (dolist (code code-map)
            ;; index (font: red)
            (draw-string (+ 20 (* col-pad col)) (+ 20 (* row-pad row)) (string-pad (write-to-string i) #\Space 2)
                         :color (allocate-color 255 0 0))
            ;; code
            (draw-string (+ 40 (* col-pad col)) (+ 20 (* row-pad row)) code)
            (incf col)
            (incf i)
            (when (zerop (mod col 5))
              (incf row)
              (setf col 0))))))
    (write-image-to-file (make-pathname :name author-handle
                                        :type "jpg"
                                        :defaults (merge-pathnames "../data/static/photos/" *home*))
                         :if-exists :supersede)))

(defun v-why-register-get ()
  (template
   :title "Why Register"
   :js nil
   :body (<:div :class "wrapper"
                (<:table (<:thead (<:tr :class "t-head"
                                        (<:td)
                                        (<:td (<:strong (translate "google"))
                                              (tooltip "google-ads"))
                                        (<:td (<:strong (translate "golbin")))
                                        (<:td (<:strong (translate "details")))))
                         (<:tbody (<:tr :class "t-odd"
                                        (<:td (translate "courier"))
                                        (<:td :class "no" (translate "yes"))
                                        (<:td :class "yes" (translate "no"))
                                        (<:td (translate "courier-dtls")
                                              (tooltip "courier-tltip")))
                                  (<:tr :class "t-even"
                                        (<:td (translate "ads-wait"))
                                        (<:td :class "no" (translate "yes"))
                                        (<:td :class "yes" (translate "no"))
                                        (<:td (translate "already-complted")
                                              (tooltip "ads-wait-tltip")))
                                  (<:tr :class "t-odd"
                                        (<:td (translate "ads-approval"))
                                        (<:td :class "no" (translate "yes"))
                                        (<:td :class "yes" (translate "no"))
                                        (<:td (translate "already-complted")
                                              (tooltip "ads-approval-tltip")))
                                  (<:tr :class "t-even"
                                        (<:td (translate "seo"))
                                        (<:td :class "no" (translate "no"))
                                        (<:td :class "yes" (translate "yes"))
                                        (<:td (translate "we-do-it-for-you")
                                              (tooltip "we-do-it-for-you-tltip")))
                                  (<:tr :class "t-odd"
                                        (<:td (translate "performance"))
                                        (<:td :class "no" (translate "no"))
                                        (<:td :class "yes" (translate "yes"))
                                        (<:td (translate "we-do-it-for-you")
                                              (tooltip "we-do-it-for-you-tltip")))
                                  (<:tr :class "t-even"
                                        (<:td (translate "income"))
                                        (<:td :class "yes" "100%")
                                        (<:td :class "no" "70%")
                                        (<:td (translate "income-dtls")))
                                  (<:tr :class "t-odd"
                                        (<:td (translate "hosting-cost"))
                                        (<:td :class "no" (translate "yes"))
                                        (<:td :class "yes" (translate "no"))
                                        (<:td (translate "we-do-it-for-you")
                                              (tooltip "we-do-it-for-you-tltip")))
                                  (<:tr :class "t-even"
                                        (<:td (translate "marketing"))
                                        (<:td :class "no" (translate "no"))
                                        (<:td :class "yes" (translate "yes"))
                                        (<:td (translate "we-do-it-for-you")
                                              (tooltip "we-do-it-for-you-tltip")))
                                  (<:tr :class "t-odd"
                                        (<:td (translate "giant-shoulders"))
                                        (<:td :class "no" (translate "no"))
                                        (<:td :class "yes" (translate "yes"))
                                        (<:td (translate "giant-shoulders-dtls")
                                              (tooltip "giant-shoulders-tltip")))
                                  (<:tr :class "t-even"
                                        (<:td (translate "min-pay-amt"))
                                        (<:td :class "no" (translate "yes"))
                                        (<:td :class "yes" (translate "no"))
                                        (<:td (translate "min-pay-amt-dtls")
                                              (tooltip "min-pay-amt-tltip")))
                                  (<:tr :class "t-odd"
                                        (<:td (translate "perf-reports"))
                                        (<:td :class "no" (translate "no"))
                                        (<:td :class "yes" (translate "yes"))
                                        (<:td (translate "perf-reports-dtls")
                                              (tooltip "perf-reports-tltip")))))
                (<:p (<:a :class "submit"
                          :href (h-genurl 'r-register-get)
                          (translate "register-here"))))))

(defun v-register-get ()
  (template
   :title "Register"
   :js nil
   :body (<:div :class "wrapper"
                (<:form :action (h-genurl 'r-register-post)
                        :method "POST"
                        (<:fieldset :class "inputs"
                                    (<:table
                                     (<:tbody
                                      (tr-td-input "username")
                                      (tr-td-input "password" :typeof "password")
                                      (<:tr (<:td (<:label :class "label" :for "password2"
                                                           "Retype password"))
                                            (<:td (<:input :class "input" :type "password2"
                                                           :name "password2"
                                                           :id "password2")))
                                      (<:tr (<:td (<:input :type "submit"
                                                           :name "submit"
                                                           :class "submit"
                                                           :value "Register"))))))))))

(defun v-register-post ()
  (let* ((name (post-parameter "name"))
         (password (post-parameter "password"))
         (slug (slugify name))
         (token (create-code-map)))
    (if (add-author (make-instance 'author
                                   :name name
                                   :alias name
                                   :username slug
                                   :handle slug
                                   :password (hash-password password)
                                   :token token
                                   :salt (generate-salt 32)
                                   :status :a))
        (progn
          (create-code-map-image token slug)
          (redirect (h-genurl 'r-login-get)))
        (redirect (h-genurl 'r-register-get)))))
