(in-package :hawksbill.golbin.utils)

(defun get-feedback-types ()
  (with-html
    (let ((feedback-types ""))
      (dolist (ft (sort *feedback-types* #'string-equal) feedback-types)
        (setf feedback-types
              (concatenate 'string
                           feedback-types
                           (htm (:option :value ft (str ft)))))))))
(defun get-feedback-form ()
  (with-html
    (htm
     (:form :action "/feedback"
            :method "POST"
            (:div :class "input"
                  (:label :for "type"
                          "type of feedback: ")
                  (:select :name "feedback-type"
                           :id "feedback-type"
                           (str (get-feedback-types))))
            (:div :class "input"
                  (:label :for "summary"
                          "summary: ")
                  (:input :type "summary"
                          :name "summary"
                          :id "summary"))
            (:div :class "input"
                  (:label :for "description"
                          "description: ")
                  (:textarea :cols 40
                             :rows 7
                             :name "description"
                             :id "description"
                             :value ""))
            (:input :id "submit"
                    :name "submit"
                    :type "submit"
                    :value "Submit")))))
(defun get-navigation ()
  )
(defun home-page ()
  (with-html-title-hd-bd-ft
      :title "Freepress"
      :bd ((get-feedback-form))))
