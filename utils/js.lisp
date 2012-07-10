(in-package :hawksbill.utils)

(defmacro js-script (&rest body)
  "Utility macro for including ParenScript into the HTML notation.
Copy-pasted from the parenscript-tutorial.pdf (http://common-lisp.net/project/parenscript/manual/parenscript-tutorial.pdf)"
  `(with-html
    (:script :type "text/javascript"
             (format nil "~%//<![CDATA[~%")
             (str (ps ,@body))
             (format nil "~%//]]>~%"))))

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
