(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; hunchentoot params
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defparameter hunchentoot:*default-content-type* "text/html; charset=utf-8")

;;; prologue
(setf *prologue* "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">")

#|(setf *dispatch-table*
      (nconc
       (mapcar (lambda (args)
                 (apply 'create-folder-dispatcher-and-handler args))
               `(("/static/" ,*static-path*)
                 ("/uploads/" ,*uploads-path*)))))|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; macros for html
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro with-html (&body body)
  `(with-html-output-to-string (*standard-output* nil)
     (htm
      ,@body)))

(defmacro with-html-title-hd-bd-ft (&key site
                                    title
                                    hd
                                    bd
                                    ft)
  (declare (ignore hd ft))
  `(with-html-output-to-string (*standard-output* nil
                                                  :prologue t
                                                  :indent t)
     (:html
      (:head
       (:title ,title)
       (get-css ,title))
      (:body
       (:div :id "doc4" :class "yui-t5"
             (:div :id "hd"
                   (:div :id "containertop")
                   (:h1 (:a :href "/" ,site)))
             (:div :id "bd" :class "yui-skin-sam"
                   (:div :id "yui-main" ,@bd)))
       (get-js ,title)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; helpers for css and js
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro js-script (&rest body)
  "Utility macro for including ParenScript into the HTML notation.
Copy-pasted from the parenscript-tutorial.pdf (http://common-lisp.net/project/parenscript/manual/parenscript-tutorial.pdf)"
  `(with-html
    (:script :type "text/javascript"
             (format nil "~%//<![CDATA[~%")
             (str (ps ,@body))
             (format nil "~%//]]>~%"))))

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
   (link-js "/static/js/home.js"))|#)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; standard functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun logout ()
  (remove-session *session*)
  (redirect "/"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; JavaScript like functions to get elements of an HTML DOM by tag/class/id
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun make-tag-body-valid-plist (tag-body)
  (append (list (first tag-body))
          '(1)
          (rest tag-body)))
(defun get-elements-by-tag (root tag)
  (let ((rslt nil))
    (defun traverse (root)
      (dolist (node root)
        (when (and (consp node)
                   (string-equal
                    tag
                    (handler-case
                        (string (first node))
                      (simple-type-error () nil))))
          (setf rslt
                (append rslt
                        (list root)))
          (traverse node))))
    (traverse root)
    rslt))
(defun get-element-by-id (root id)
  (let ((rslt nil))
    (defun traverse (root)
      (dolist (node root)
        (when (consp node)
          (if (string-equal
               (handler-case
                   (getf (make-tag-body-valid-plist
                          node)
                         :ID)
                 (simple-type-error () nil))
               id)
              (setf rslt root)
              (traverse node)))))
    (traverse root)
    rslt))
(defun get-elements-by-class (root class)
  (let ((rslt nil))
    (defun traverse (root)
      (dolist (node root)
        (when (consp node)
          (if (string-equal
               (handler-case
                   (getf (make-tag-body-valid-plist
                          node)
                         :CLASS)
                 (simple-type-error () nil))
               class)
              (setf rslt
                    (append rslt
                            (list root)))
              (traverse node)))))
    (traverse root)
    rslt))
