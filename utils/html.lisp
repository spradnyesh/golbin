(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; hunchentoot params
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defparameter hunchentoot:*default-content-type* "text/html; charset=utf-8")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tr-td-input (name &key (value "") (typeof "text"))
  (let ((for (regex-replace-all "-" name " "))
        (trimmed-name (trim-name name)))
    (<:tr (<:td :class "label"
                (format nil "~A" (string-capitalize for)))
          (<:td (<:input :class (format nil "td-input ~A" trimmed-name)
                         :type typeof
                         :name trimmed-name
                         :value value)))))

(defun tr-td-text (name &key (class "") (value "") (cols 40) (rows 7))
  (<:tr (<:td :class "label"
              (format nil "~A" (string-capitalize name)))
        (<:td (let ((trimmed-name (trim-name name)))
                (<:textarea :cols cols
                            :rows rows
                            :name trimmed-name
                            :id trimmed-name
                            :class class
                            value)))))

(defmacro tooltip (key &key (marker "#") (class "classic"))
  `(<:span :class "tooltip"
           (<:sup ,marker)
           (<:span :class ,class
                   (translate ,key))))

(defun remove-all-style (body)
  (regex-replace-all "style=\\\"(.*?)\\\"" body ""))

;; remove empty :p and :div tags
;; remove ""
(defun cleanup-ckeditor-text (body)
  (regex-replace-all "<p>
	&nbsp;</p>" (regex-replace-all "<div>
	&nbsp;</div>" (regex-replace-all "" body "") "") ""))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; standard functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hunchentoot params
(defun hu-init ()
  (setf *catch-errors-p* (get-config "hunchentoot.debug.errors.catch"))
  (setf *show-lisp-errors-p* (get-config "hunchentoot.debug.errors.show"))
  (setf *show-lisp-backtraces-p* (get-config "hunchentoot.debug.backtraces")))

(defun logout ()
  (remove-session *session*)
  (redirect "/"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; helpers for css and js
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#- (and)
((defun link-css (path)
   (when (and (equal *environment* "prod")
              (not (search "yui" path)))
     (setf path (regex-replace ".css$" path "-min.css")))
   (<:link :rel "stylesheet"
          :type "text/css"
          :href path))

 (defun link-js (path)
   (when (and (equal *environment* "prod")
              (not (search "yui" path)))
     (setf path (regex-replace ".js$" path "-min.js")))
   (<:script :type "text/javascript"
            :src path))

 (defun get-css (title)
   (declare (ignore title))
   (link-css "/static/yui/yui.css")
   (link-css "/static/css/common.css")
   (if (search "admin" title :test #'char-equal)
       (link-css "/static/css/admin.css")
       (link-css "/static/css/home.css")))

 (defun get-js (title)
   (declare (ignore title))
   (link-js "/static/yui/yui.js")
   (if (search "admin" title :test #'char-equal)
       (link-js "/static/js/admin.js")
       (link-js "/static/js/home.js"))))
