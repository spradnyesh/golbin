(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; make provision to store *dimensions* in *request* so that it will be thread safe
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defclass dimensions ()
  ((envt :initarg :envt :initform nil :accessor envt)
   (lang :initarg :lang :initform nil :accessor lang)))

(defclass hawksbill-request (restas::restas-request)
  ((dimensions :initarg :dimensions :initform nil :accessor dimensions)))

(defclass hawksbill-acceptor (restas-acceptor)
  ()
  (:default-initargs
   :request-class 'hawksbill-request))

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
         (if (setf envt (get-parameter "envt"))
             (setf *envt* envt)
             (setf *envt* "dev"))
         ;; set lang
         (if (setf lang (get-parameter "lang"))
             (setf *lang* lang)
             (setf *lang* (get-config "site.lang")))))
      ;; TODO: int/qa
      ;; production
      ((setf index (search (get-config "site.url") host))
       (progn
         ;; set envt
         (setf *envt* "prod")
         ;; set lang
         (setf host (subseq host 0 index)) ; www/hi/mr
         (cond ((equal host "mr") (setf *lang* "mr-IN"))
               ((equal host "hi") (setf *lang* "hi-IN"))
               (t (setf *lang* "en-IN"))))))))

(defun init-dimensions (route)
  (make-instance 'dimensions-route :target route))
