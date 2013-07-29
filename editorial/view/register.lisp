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
                (<:table
                 (<:thead (<:tr (<:td)
                                (<:td (<:strong (translate "google"))
                                      (<:span :class "tooltip"
                                              (<:sup "#")
                                              (<:span :class "classic"
                                                      (translate "google-ads"))))
                                (<:td (<:strong (translate "golbin")))
                                (<:td (translate "details"))))
                 (<:tbody (<:tr (<:td (translate "courier"))
                                (<:td :class "no" (translate "yes"))
                                (<:td :class "yes" (translate "no"))
                                (<:td (translate "courier-dtls")))
                          (<:tr (<:td (translate "ads-wait"))
                                (<:td :class "no" (translate "yes"))
                                (<:td :class "yes" (translate "no"))
                                (<:td (translate "already-complted")))
                          (<:tr (<:td (translate "ads-approval"))
                                (<:td :class "no" (translate "yes"))
                                (<:td :class "yes" (translate "no"))
                                (<:td (translate "already-complted")))
                          (<:tr (<:td (translate "seo"))
                                (<:td :class "no" (translate "no"))
                                (<:td :class "yes" (translate "yes"))
                                (<:td (translate "we-do-it-for-you")))
                          (<:tr (<:td (translate "performance"))
                                (<:td :class "no" (translate "no"))
                                (<:td :class "yes" (translate "yes"))
                                (<:td (translate "we-do-it-for-you")))
                          (<:tr (<:td (translate "income"))
                                (<:td :class "yes" "100%")
                                (<:td :class "no" "70%")
                                (<:td (translate "income-dtls")))
                          (<:tr (<:td (translate "hosting-cost"))
                                (<:td :class "no" (translate "yes"))
                                (<:td :class "yes" (translate "no"))
                                (<:td (translate "we-do-it-for-you")))
                          (<:tr (<:td (translate "marketing"))
                                (<:td :class "no" (translate "no"))
                                (<:td :class "yes" (translate "yes"))
                                (<:td (translate "we-do-it-for-you")))
                          (<:tr (<:td (translate "giant-shoulders"))
                                (<:td :class "no" (translate "no"))
                                (<:td :class "yes" (translate "yes"))
                                (<:td (translate "giant-shoulders-dtls")))
                          (<:tr (<:td (translate "min-pay-amt"))
                                (<:td :class "no" (translate "yes"))
                                (<:td :class "yes" (translate "no"))
                                (<:td (translate "min-pay-amt-dtls")))
                          (<:tr (<:td (translate "perf-reports"))
                                (<:td :class "no" (translate "no"))
                                (<:td :class "yes" (translate "yes"))
                                (<:td (translate "perf-reports-dtls"))))))))

(defun v-register-get ()
  (template
   :title "Register"
   :js nil
   :body (<:form :action (h-genurl 'r-register-post)
                 :method "POST"
                 (label-input "username" "text")
                 (label-input "password" "password")
                 (<:input :type "submit"
                          :name "submit"
                          :id "submit"
                          :value "Register"))))

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
