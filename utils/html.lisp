(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; hunchentoot params
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defparameter hunchentoot:*default-content-type* "text/html; charset=utf-8")
(setf *prologue* "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; helper macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro with-html (&body body)
  `(with-html-output-to-string (*standard-output* nil)
     (htm
      ,@body)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tr-td-input (name &key (value "") (typeof "text"))
  (let ((for (regex-replace-all "-" name " ")))
    (with-html
      (htm
       (:tr
        (:td (format t "~A" (string-capitalize for)))
        (:td (:input :class (format nil "td-input ~A" name)
                     :type typeof
                     :name (format nil "~A" name)
                     :value value)))))))

(defun tr-td-text (name &key (class "") (value "") (cols 40) (rows 7))
  (with-html
    (htm (:tr (:td (format t "~A" (string-capitalize name)))
              (:td (:textarea :cols cols
                              :rows rows
                              :name (format nil "~A" name)
                              :id (format nil "~A" name)
                              :class class
                              (str value)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; standard functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun hu-init ()
  (setf hunchentoot:*catch-errors-p* (get-config "hunchentoot.debug.errors.catch"))
  (setf hunchentoot:*show-lisp-errors-p* (get-config "hunchentoot.debug.errors.show"))
  (setf hunchentoot:*show-lisp-backtraces-p* (get-config "hunchentoot.debug.backtraces")))

(defun logout ()
  (remove-session *session*)
  (redirect "/"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; helpers for css and js
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#|(
 (defun link-css (path)
   (when (and (equal *environment* "prod")
              (not (search "yui" path)))
     (setf path (regex-replace ".css$" path "-min.css")))
   (with-html
     (:link :rel "stylesheet"
            :type "text/css"
            :href path)))
 (defun link-js (path)
   (when (and (equal *environment* "prod")
              (not (search "yui" path)))
     (setf path (regex-replace ".js$" path "-min.js")))
   (with-html
     (:script :type "text/javascript"
              :src path)))
 (defun get-css (title)
   (declare (ignore title))
   (link-css "/static/yui/yui.css")
   (link-css "/static/css/common.css")
   #|(if (search "admin" title :test #'char-equal)
   (link-css "/static/css/admin.css")
   (link-css "/static/css/home.css"))|#)
 (defun get-js (title)
   (declare (ignore title))
   (link-js "/static/yui/yui.js")
   #|(if (search "admin" title :test #'char-equal)
   (link-js "/static/js/admin.js")
   (link-js "/static/js/home.js"))|#))|#
