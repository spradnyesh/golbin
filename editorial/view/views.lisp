(in-package :hawksbill.golbin)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; login
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ed-v-login-get ()
  (ed-page-template "Login"
    (:form :action (genurl 'ed-r-login)
           :method "POST"
           (str (label-input "name" "text"))
           (str (label-input "password" "text"))
           (:input :type "submit"
                   :name "submit"
                   :id "submit"
                   :value "Login"))))
#|(
 (defun photo-add-single-form ()
   (with-html-title-hd-bd-ft :site "Golbin"
                             :title "Golbin: Add a new Photo"
                             :bd ((:form :action "/admin/photo/handleAdd.html"
                                         :method "POST"
                                         :enctype "multipart/form-data"
                                         (:div :class "input"
                                               (:label :for "photo"
                                                       "photo: ")
                                               (:input :type "file"
                                                       :name "photo"
                                                       :id "photo"))
                                         (:input :id "submit"
                                                 :name "submit"
                                                 :type "submit"
                                                 :value "Add Photo"))))))|#
