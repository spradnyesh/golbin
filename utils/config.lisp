(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; global configs for use in this package
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; make sure these are initialized in every project
(defvar *home* "")
(defvar *config-storage* nil)
(defvar *translation-file-root* nil)
(defvar *db-init-ids* nil)
(defvar *save-photo-to-db-function* nil)
(defvar *pagination-limit* 10)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; dimensions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar *dimensions* nil)
(defvar *default-envt* nil)
(defvar *default-intl* nil)
(defvar *default-lang* nil)
(defvar *valid-envts* nil)
(defvar *valid-intls* nil)
(defvar *valid-langs* nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defclass config ()
  ((name :initarg :name :initform nil :accessor name)
   (value :initarg :value :initform nil :accessor value)))
(defclass config-node ()
  ((dimension :initarg :dimension :initform nil :accessor dimension)
   (value :initarg :value :initform nil :accessor value)))
(defclass config-storage ()
  ((configs :initform nil :accessor configs)))

(defun is-valid-dimension-value (dimension value)
  (not (cond ((equal dimension "envt")
              (set-difference (list value) *valid-envts* :test #'string-equal))
             ((equal dimension "intl")
              (set-difference (list value) *valid-intls* :test #'string-equal))
             ((equal dimension "lang")
              (set-difference (list value) *valid-langs* :test #'string-equal)))))

(defun is-valid-dimension (dimensions-map)
  (dolist (dm dimensions-map)
    (unless (is-valid-dimension-value (first dm) (second dm))
      (return-from is-valid-dimension nil)))
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

(defun get-config-helper (name dimensions-map config-storage)
  (when dimensions-map
    (let ((config-node (find (get-dimensions-string dimensions-map)
                             (configs config-storage)
                             :key #'dimension
                             :test #'string-equal)))
      (if config-node
          (let ((value (find name
                             (value config-node)
                             :key #'name
                             :test #'string-equal)))
            (if value
                (value value)
                (get-config-helper name (reduce-dimensions-map dimensions-map) config-storage)))
          (get-config-helper name (reduce-dimensions-map dimensions-map) config-storage)))))

(defun get-config (name dimensions-string &optional (config-storage *config-storage*))
  (get-config-helper name (get-dimensions-map dimensions-string) config-storage))

(defun add-config (name value dimensions-string &optional (config-storage *config-storage*))
  "does _not_ check for duplicates while adding; due to _push_, get-config will always get the latest value => the older values just increase the size, but that's nominal, and hence ok ;)"
  (when (is-valid-dimension (get-dimensions-map dimensions-string))
    (let ((config (make-instance 'config :name name :value value))
          (config-node (find dimensions-string
                             (configs config-storage)
                             :key #'dimension
                             :test #'string-equal)))
      (if config-node
          (push config (value config-node))
          (push (make-instance 'config-node :dimension dimensions-string :value (list config))
                (configs config-storage))))))

(defun show-config-tree (&optional (config-storage *config-storage*))
  (dolist (cn (configs config-storage))
    (format t "***** ~a *****~%" (dimension cn))
    (dolist (v (value cn))
      (format t "~a: ~a~%" (name v) (value v)))))
