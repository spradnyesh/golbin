(in-package :hawksbill.utils)

;;;; this file defines the data and the thread-safe process of storing the dimensions into the *request*

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; make provision to store *dimensions* in *request* so that it will be thread safe
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defclass resources ()
  ((db :initarg :db :initform nil :accessor db)))

(defclass dimensions ()
  ((envt :initarg :envt :initform nil :accessor envt)
   (lang :initarg :lang :initform nil :accessor lang)
   (resources :initarg :resources :initform nil :accessor resources)))

(defclass hawksbill-request (restas::restas-request)
  ((dimensions :initarg :dimensions :initform nil :accessor dimensions)))

(defclass hawksbill-acceptor (restas-acceptor)
  ()
  (:default-initargs
   :request-class 'hawksbill-request))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-resource (name dim-str)
  (let ((dim (gethash dim-str *resources*)))
    (when dim
      (gethash name dim))))

;; this is called at system init (eg db-connect) and not for every request
(defun set-resource (name value dim-str)
  (setf (gethash name (gethash dim-str *resources*)) value))

(defun show-resources ()
  (maphash #'(lambda (k v)
               (format t "***** ~a: *****~%" k)
               (print-map v)) *resources*))

(defun get-dimension-value (dim-name)
  (if (boundp '*request*)
      (funcall (intern (string-upcase dim-name) :hawksbill.utils) (dimensions *request*))
      (dolist (dim (split-sequence "," *default-dimensions* :test #'string-equal))
        (let ((name-value (split-sequence ":" dim :test #'string-equal)))
          (when (string-equal dim-name (first name-value))
            (return-from get-dimension-value (second name-value)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; init *dimensions* for every request (as shown in http://restas.lisper.ru/en/manual/decorators.html)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defclass dimensions-route (routes:proxy-route) ())

(defmethod process-route :before ((route dimensions-route) bindings)
  (let ((host (host))
        (index nil)
        (envt nil)
        (lang nil))
    (cond
      ;; localhost/dev
      ((search "localhost" host)
       (progn
         ;; set envt
         (unless (setf envt (get-parameter "envt"))
           (setf envt "dev"))
         ;; set lang
         (unless (setf lang (get-parameter "lang"))
           (setf lang (get-config "site.lang")))))
      ;; TODO: int/qa
      ;; production
      ((setf index (search (get-config "site.url") host))
       (progn
         ;; set envt
         (setf envt "prod")
         ;; set lang
         (setf host (subseq host 0 index)) ; www/hi/mr
         (cond ((equal host "mr") (setf lang "mr-IN"))
               ((equal host "hi") (setf lang "hi-IN"))
               (t (setf lang "en-IN"))))))
    (setf (dimensions *request*)
          (make-instance 'dimensions
                         :envt envt
                         :lang lang
                         :resources (make-instance 'resources
                                                   :db (get-resource "db" (build-dimension-string
                                                                           (concatenate 'string "envt:" envt)
                                                                           (concatenate 'string "lang:" lang))))))))

(defun init-dimensions (route)
  (make-instance 'dimensions-route :target route))
