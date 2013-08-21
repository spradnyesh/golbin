(in-package :hawksbill.utils)

(defun obfuscate-js ()
  (setf *ps-print-pretty* (not (get-config "parenscript.obfuscation"))))

;; http://msnyder.info/posts/2011/07/lisp-for-the-web-part-ii/#sec-6
(defmacro $event ((selector event-binding) &body body)
  `((@ ($ ,selector) ,event-binding) (lambda (event) ,@body)))

(defmacro $apply (selector function &body params)
  `((@ ,selector ,function) ,@params))

(defmacro $prevent-default ()
  `(when event ($apply event prevent-default)))

(defmacro $log (message)
  `((@ console log) ,message))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; create and close pane
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro $pane (&body body)
  `(flet ((create-pane (id)
            ($apply ($ "#bd")
                append
              ($ (+ "<div id='" id "'><a class='close' href=''>Close</a><div class='message'></div></div>")))
            ($event ((+ "#" id " a.close") click) (close-pane event)))

          (close-pane (event)
            ($prevent-default)
            ((@ ($ "#pane") remove))))
     ,@body))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; ajax and form processing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro $ajax-form (&body body)
  `(flet ((ajax-fail (jq-x-h-r text-status error-thrown)
            ;; ajax call itself failed
            (if (= text-status "parseerror")
                (alert "Received an invalid response from server. Please try again after some time.")
                (alert "Network error"))
            false)
          ;; submit form using ajax
          (submit-form-ajax (form)
            ($apply ($ form) attr "action" (+ "/ajax" ($apply ($ form) attr "action"))))
          ;; form submit
          (form-submit (event form)
            ($prevent-default)
            ;; TODO: client side error handling
            ($apply ($ form) ajax-submit
              ;; http://api.jquery.com/jQuery.ajax/
              (create :data-type "json"
                      :cache false
                      :async false
                      :success (lambda (data text-status jq-x-h-r)
                                 (form-submit-done data text-status jq-x-h-r))
                      :error (lambda (jq-x-h-r text-status error-thrown)
                               (ajax-fail jq-x-h-r text-status error-thrown)))))
          ;; we have got a reply from the server
          (form-submit-done (data text-status jq-x-h-r)
            (if (= data.status "success")
                ;; this is the redirect after POST
                (setf window.location data.data)
                (form-fail data)))
          ;; the reply was an err0r :(
          (form-fail (data)
            (create-pane "pane")
            ($apply ($ "#pane ul") remove)
            ($apply ($ "#pane .message") append ($ (+ "<p>" data.message "</p>")))
            (let ((errors "<ul>"))
              (dolist (err data.errors)
                (setf errors (+ errors "<li>" err "</li>")))
              (setf errors (+ errors "</ul>")))
            ($apply ($ "#pane .message") append ($ errors))))
     ,@body))

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
                   (string-equal tag
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
