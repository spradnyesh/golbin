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
(defun is-valid-dimension-value (dimension value)
  (not (set-difference (list value)
                       (handler-case (symbol-value (intern (string-upcase (format nil
                                                                      "*valid-~as*"
                                                                      dimension))))
                         (unbound-variable () (return-from is-valid-dimension-value nil)))
                       :test #'string-equal)))

(defun is-valid-dimensions-map (dimensions-map)
  (if (and (= 1 (length dimensions-map))
           (equal "master" (first (first dimensions-map))))
      t
      (dolist (dm dimensions-map)
        (unless (is-valid-dimension-value (first dm) (second dm))
          (return-from is-valid-dimensions-map nil))))
  t)

(defun get-dimensions-string (dimensions-map)
  (join-string-list-with-delim ","
                               (let ((rslt nil))
                                 (dolist (dm dimensions-map)
                                   (push (join-string-list-with-delim ":" dm) rslt))
                                 (nreverse rslt))))

(defun get-dimensions-map (dimensions-string)
  (let ((rslt nil))
    (dolist (dl (split-sequence "," dimensions-string :test #'string-equal))
      (let ((d (split-sequence ":" dl :test #'string-equal)))
        (push d rslt)))
    (nreverse rslt)))

(defun reduce-dimensions-map (dimensions-map)
  (nreverse (rest (nreverse dimensions-map))))

(defun reduce-dimensions-string (dimensions-string)
  (get-dimensions-string (reduce-dimensions-map (get-dimensions-map dimensions-string))))

(defun get-config-helper (name dimensions-map storage)
  (let ((config-node (if dimensions-map
                         (find (get-dimensions-string dimensions-map)
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
                (get-config-helper name (reduce-dimensions-map dimensions-map) storage))))
        (get-config-helper name (reduce-dimensions-map dimensions-map) storage))))

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

(defun dimensions-tree (dimensions)
  (let ((rslt nil))
    ;; '(1 1.1 1.2) => '(1:1.1 1:1.2)
    (dolist (dimension dimensions)
      (let ((f (first dimension))
            (tmp nil))
        (dolist (dim (rest dimension))
          (push (concatenate 'string f ":" dim) tmp))
        (push tmp rslt)))
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; get/add/show/init functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun build-dimension-string (&key envt lang)
  (concatenate 'string "envt:" envt ",lang:" lang))

(defun set-default-dimensions (&key envt lang)
  (setf *default-dimensions* (build-dimension-string envt lang)))

(defun get-config (name &optional (dimensions-string (build-dimension-string *request*)) (storage *config-storage*))
  (get-config-helper name (get-dimensions-map dimensions-string) storage))

(defun add-config (name value dimensions-string &optional (storage *config-storage*))
  "does _not_ check for duplicates while adding; due to _push_, get-config will always get the latest value => the older values just increase the size, but that's nominal, and hence ok ;)"
  (when (is-valid-dimensions-map (get-dimensions-map dimensions-string))
    (let ((config (make-instance 'config :name name :value value))
          (config-node (find dimensions-string
                             (configs storage)
                             :key #'dimension
                             :test #'string-equal)))
      (if config-node
          (push config (config-list config-node))
          (push (make-instance 'config-node :dimension dimensions-string :config-list (list config))
                (configs storage))))))

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
      (dolist (config-node (rest c)) ; (rest c) => config-list (list of config nodes)
        (let ((configs (build-config-node config-node)))
          (dolist (config configs)
            (add-config (first config) (second config) dimensions-string storage)))))))

(defun init-config ()
  (setf *config-storage* (make-instance 'config-storage))
  (init-config-tree *config*))
