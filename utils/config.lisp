(in-package :hawksbill.utils)

;;;; this file defines the actual data that needs to be looked up based on *dimensions* stored in *request*

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
(defun dimensions-map-to-string (map)
  (join-string-list-with-delim ","
                               (let ((rslt nil))
                                 (dolist (dm map)
                                   (push (join-string-list-with-delim ":" dm) rslt))
                                 (nreverse rslt))))

(defun dimensions-string-to-map (string)
  (let ((rslt nil))
    (dolist (dl (split-sequence "," string :test #'string-equal))
      (let ((d (split-sequence ":" dl :test #'string-equal)))
        (push d rslt)))
    (nreverse rslt)))

(defun reduce-dimensions-map (map)
  (nreverse (rest (nreverse map))))

(defun reduce-dimensions-string (string)
  (dimensions-map-to-string (reduce-dimensions-map (dimensions-string-to-map string))))

(defun get-config-helper (name map storage)
  (let ((config-node (if map
                         (find (dimensions-map-to-string map)
                               (configs storage)
                               :key #'dimension
                               :test #'string-equal)
                         (find "master"
                               (configs storage)
                               :key #'dimension
                               :test #'string-equal))))
    (if config-node
        (let ((value (find name
                           (config-list config-node)
                           :key #'name
                           :test #'string-equal)))
          (if value
              (value value)
              (unless (string-equal "master" (dimension config-node))
                ;; reduce dimension to "master" only if it's not already "master", else it goes into an infinite loop
                (get-config-helper name (reduce-dimensions-map map) storage))))
        (get-config-helper name (reduce-dimensions-map map) storage))))

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
    (mapcar #'(lambda (l)
                (join-string-list-with-delim "," l))
            (cross-product-i list-of-lists))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; get/add/show/init functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun build-dimension-string (&key envt lang)
  (concatenate 'string "envt:" envt ",lang:" lang))

(defun set-default-dimensions (&key envt lang)
  (setf *default-dimensions* (build-dimension-string :envt envt :lang lang)))

(defun get-config (name &optional (dimensions-string *default-dimensions*) (storage *config-storage*))
  (get-config-helper name (dimensions-string-to-map dimensions-string) storage))

(defun add-config (name value dimensions-string &optional (storage *config-storage*))
  "does _not_ check for duplicates while adding; due to _push_, get-config will always get the latest value => the older values just increase the size, but that's nominal, and hence ok ;)"
  (let ((config (make-instance 'config :name name :value value))
        (config-node (find dimensions-string
                           (configs storage)
                           :key #'dimension
                           :test #'string-equal)))
    (if config-node
        (push config (config-list config-node))
        (push (make-instance 'config-node :dimension dimensions-string :config-list (list config))
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
    (let ((dimensions-string (first c)))
      (when (or (string-equal dimensions-string "master")
                (find dimensions-string *dimensions-combos* :test #'equal))
        (dolist (config-node (rest c)) ; (rest c) => config-list (list of config nodes)
          (let ((configs (build-config-node config-node)))
            (dolist (config configs)
              (add-config (first config) (second config) dimensions-string storage))))))))

(defun init-config ()
  (setf *config-storage* (make-instance 'config-storage))
  (setf *dimensions-combos* (build-dimensions-combos))
  (init-config-tree *config*))
