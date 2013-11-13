(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; helper macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro timed-redirect ()
  `(<:script :type "text/javascript"
             (format nil "setTimeout('location.href=\"~a\"', 5000);" route)))

(defmacro click-here (key route)
  `(translate ,key
              (<:a :href ,route
                   (translate "here"))))

(defmacro tooltip (key &key (marker "#") (class "classic"))
  `(<:span :class "tooltip"
           (<:sup ,marker)
           (<:span :class ,class
                   (translate ,key))))

(defmacro tr-td-helper (&body body)
  `(let ((for (regex-replace-all " " name "-")))
     (<:tr :id (if id
                   name
                   "")
           :class class
           (<:td :class "label"
                 (<:label :for for
                          (if mandatory
                              (fmtnil (translate for)
                                      (<:span :class "mandatory" "*"))
                              (fmtnil (translate for))))
                 (when tooltip (tooltip tooltip)))
           (<:td ,@body))))

(defmacro label-input (for typeof &key (mandatory nil) (tooltip nil))
  `(<:div (<:p (<:label :class "label"
                        :for ,for
                        (if ,mandatory
                            (fmtnil (translate ,for)
                                    (<:span :class "mandatory" "*"))
                            (fmtnil (translate ,for))))
               (when ,tooltip (tooltip ,tooltip)))
          (<:input :class "input" :type ,typeof
                   :name ,for
                   :id ,for)))

(defmacro submit-success (ajax route)
  `(if ,ajax
       (encode-json-to-string `((:status . "success")
                                (:data . ,,route)))
       (redirect ,route)))

(defmacro submit-error (ajax err0r route)
  `(if ,ajax
       (encode-json-to-string `((:status . "error")
                                (:message . ,(translate "submit-error"))
                                (:errors . ,(reverse ,err0r))))
       ;; no-ajax => we lose all changes here
       (redirect ,route)))

(defmacro cannot-be-empty (key string err0r &body body)
  `(if (is-null-or-empty ,key)
       (push (translate (format nil "~a-cannot-be-empty" ,string))
           ,err0r)
       ,@body))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tr-td-input (name &key (id nil) (class "") (value "") (typeof "text") (mandatory nil) (tooltip nil) (disabled nil))
  (tr-td-helper (<:input :type typeof
                         :name for
                         :value value
                         (when disabled :disabled))))

(defun tr-td-text (name &key (id nil) (class "") (value "") (cols 40) (rows 7) (mandatory nil) (tooltip nil))
  (tr-td-helper (<:textarea :cols cols
                            :name for
                            :rows rows
                            value)))
(defun tr-td-submit ()
  (<:tr (<:td)
        (<:td (<:input :type "submit"
                       :name "submit"
                       :class "submit"
                       :value (translate "submit")))))

(defun validate-email (email)
  (cl-ppcre:all-matches "^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$" (string-downcase email)))
