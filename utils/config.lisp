(in-package :hawksbill.utils)

;;;; this file defines the actual config data that needs to be looked up based on dimensions stored in *request*

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; config classes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defclass config ()
  ((name :initarg :name :initform nil :accessor name)
   (value :initarg :value :initform nil :accessor value)))
(defclass config-node ()
  ((dimension :initarg :dimension :initform nil :accessor dimension)
   (config-list :initarg :config-list :initform nil :accessor config-list)))
(defclass config-storage ()
  ((configs :initform nil :accessor configs)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun find-config-node-and-value (name node-name storage)
  (let ((config-node (find node-name
                           (configs storage)
                           :key #'dimension
                           :test #'string-equal)))
    (when config-node
      (let ((config (find name
                          (config-list config-node)
                          :key #'name
                          :test #'string-equal)))
        (when config
          (return-from find-config-node-and-value (value config)))))))

(defun get-config-helper (name dim-str storage)
  (dolist (dim-list (reverse (group-list #'length
                                  (permutations-i (split-sequence ","
                                                                  dim-str
                                                                  :test #'string-equal)))))
    (dolist (dim dim-list)
      (let ((rslt (find-config-node-and-value name
                                              (join-string-list-with-delim "," dim)
                                              storage)))
        (when rslt (return-from get-config-helper rslt)))))

  ;; we have not found the config-value yet, so look at master
  (find-config-node-and-value name "master" storage))


(defun build-config-node (node &optional (namespace nil))
  (let ((rslt nil)
        (name (first node))
        (value (rest node)))
    (if (stringp name)
        ;; normal case
        (if (consp (first value))
            (dolist (v value)
              (setf rslt (append
                          rslt
                          (build-config-node v (cons name namespace)))))
            (push (list (join-string-list-with-delim "." (reverse (push name namespace)))
                        (first value))
                  rslt))
        ;; abnormal (see 'categorys' in *config* in golbin.src.config)
        (push (list (join-string-list-with-delim "." (reverse namespace))
                    node)
              rslt))
    rslt))

(defun build-dimensions-combos ()
  (let ((list-of-lists nil))
    (dolist (d *dimensions*)
      (let ((list nil))
        (dolist (v (symbol-value (intern (string-upcase (format nil
                                                                "*valid-~as*"
                                                                d)))))
          (push (concatenate 'string d ":" v) list))
        (push list list-of-lists)))
    (mapcar #'(lambda (a) (sort a #'string<))
            (cross-product-i list-of-lists))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; get/add/show/init functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun build-dimension-string (&rest dims)
  (join-string-list-with-delim "," (sort dims #'string<)))

(defun set-default-dimensions (&rest dims)
  (let ((given-dims nil)
        (not-given-dims nil))
    (if (atom dims)
        (push (split-sequence ":" dims :test #'string-equal) given-dims)
        (dolist (d dims)
          (push (first (split-sequence ":" d :test #'string-equal)) given-dims)))
    (dolist (nd (set-difference *dimensions* given-dims :test #'string-equal))
      (push (concatenate 'string
                         nd
                         ":"
                         (get-config (concatenate 'string "site." nd) "master")) not-given-dims))
    (setf *default-dimensions* (apply #'build-dimension-string (if (first dims) ; dims can be null
                                                                   (append dims not-given-dims)
                                                                   not-given-dims)))))

(defun get-config (name &optional (dim-str *default-dimensions*) (storage *config-storage*))
  (get-config-helper name dim-str storage))

(defun add-config (name value dim-str &optional (storage *config-storage*))
  "does _not_ check for duplicates while adding; due to _push_, get-config will always get the latest value => the older values just increase the size, but that's nominal, and hence ok ;)"
  (let ((config (make-instance 'config :name name :value value))
        (config-node (find dim-str
                           (configs storage)
                           :key #'dimension
                           :test #'string-equal)))
    (if config-node
        (push config (config-list config-node))
        (push (make-instance 'config-node :dimension dim-str :config-list (list config))
              (configs storage)))))

(defun show-config-tree (&optional (storage *config-storage*))
  (dolist (cn (configs storage))
    (format t "***** ~a *****~%" (dimension cn))
    (dolist (v (config-list cn))
      (format t "~a: ~a~%" (name v) (value v)))))

(defun init-config-tree (&optional (config *config*) (storage *config-storage*))
  "(('master' ('author' ('article-logo' ('width' 120)
                                        ('height' 30)))
              ('categorys' '(('Business' 'Companies' 'Markets')
                             ('Entenrtainment' 'Arts' 'TV'))))
    ('envt:prod' ('n3' 'v3') ('n4' 'v4')))"
  (dolist (c config)
    (let ((dim-str (first c)))
      (when (or (string-equal dim-str "master")
                (find (sort (split-sequence "," dim-str :test #'string-equal) #'string<)
                      *dimensions-combos*
                      :test #'equal))
        (dolist (config-node (rest c)) ; (rest c) => config-list (list of config nodes)
          (let ((configs (build-config-node config-node)))
            (dolist (config configs)
              (add-config (first config) (second config) dim-str storage))))))))

(defun init-config ()
  (setf *config-storage* (make-instance 'config-storage))
  (setf *dimensions-combos* (build-dimensions-combos))
  (init-config-tree *config*))
