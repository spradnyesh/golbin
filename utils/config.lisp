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
(defun get-config-helper (name dim-map storage)
  ;; 1st check only same level
  (let ((permutations (permutations dim-map))
        (found nil)
        (multiple nil)
        (rslt nil))
    (dolist (dim permutations)
      (let ((config-node (find dim
                               (configs storage)
                               :key #'dimension
                               :test #'string-equal)))
        (when config-node
          (let ((config (find name
                              (config-list config-node)
                              :key #'name
                              :test #'string-equal)))
            (when config
              (when found         ; finding this config more than once
                (setf multiple t))
              (setf found t)
              (push (value config) rslt))))))
    ;; if not found, then reduce/generalize dim-str and re-do
    (unless found
      (setf permutations (sort (set-difference (permutations-i '(1 2 3))
                                               permutations
                                               :test 'equal)
                               #'> :key #'length)))))

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

(defun get-config (name &optional (dim-str *default-dimensions*) (storage *config-storage*))
  (get-config-helper name (split-sequence "," dim-str :test #'string-equal) storage))

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
                (find dim-str *dimensions-combos* :test #'equal))
        (dolist (config-node (rest c)) ; (rest c) => config-list (list of config nodes)
          (let ((configs (build-config-node config-node)))
            (dolist (config configs)
              (add-config (first config) (second config) dim-str storage))))))))

(defun init-config ()
  (setf *config-storage* (make-instance 'config-storage))
  (setf *dimensions-combos* (build-dimensions-combos))
  (init-config-tree *config*))
