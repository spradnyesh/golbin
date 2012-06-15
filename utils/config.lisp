(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; global configs for use in this package
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; make sure these are initialized in every project
(defvar *home* "")
(defvar *config* nil)
(defvar *translation-file-root* nil)
(defvar *db-init-ids* nil)
(defvar *save-photo-to-db-function* nil)
(defvar *pagination-limit* 10)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; dimensions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar *dimensions* '("envt" "intl" "lang"))
(defvar *default-envt* nil)
(defvar *default-intl* nil)
(defvar *default-lang* nil)
(defvar *valid-envt* '("dev" "prod"))
(defvar *valid-intl* '("IN"))
(defvar *valid-lang* '("en-IN"))
(defvar *config-tree* (sort (make-config-tree *dimensions*) #'(lambda (a b) (< (length a) (length b)))))

(defclass config ()
  ((name :initarg :name :initform nil :accessor name)
   (value :initarg :value :initform nil :accessor value)))

(defun make-config-tree (&optional (list *dimensions*))
  (do ((queue list)
       (rslt nil))
      ((null queue) rslt)
    (let* ((item (pop queue))
           (item (if (consp item)
                     item
                     (list item)))
           (diff (set-difference list
                                 item)))
      (push item rslt)
      (dolist (d diff)
        (push (cons d item)
              queue)))))

#|(defmacro vcp (dimension list) ; dunno why this ain't working below
  `((eql dimension ,dimension)
              (set-difference (list param) ,list :test #'string-equal)))|#
(defun is-valid-dimension-value (dimension value)
  (not (cond ((equal dimension "envt")
              (set-difference (list value) *valid-envt* :test #'string-equal))
             ((equal dimension "intl")
              (set-difference (list value) *valid-intl* :test #'string-equal))
             ((equal dimension "lang")
              (set-difference (list value) *valid-lang* :test #'string-equal)))))

(defun get-dimensions-map (dimensions)
  (let ((rslt nil))
    (dolist (dl (split-sequence "," dimensions :test #'string-equal))
      (let ((d (split-sequence ":" dl :test #'string-equal)))
        (when (is-valid-dimension-value (first d) (second d))
          (push d rslt))))
    (nreverse rslt)))

#|(conditionally-accumulate #'(lambda (c)
                              (equal (third c) "lang"))
                          (conditionally-accumulate #'(lambda (c)
                                                        (equal (second c) "intl"))
                                                    (conditionally-accumulate #'(lambda (c)
                                                                                  (equal (first c) "envt"))
                                                                              *config-tree*)))|#
(defun add-config (name value dimensions)
  (let ((list nil)
        (dimension-name-node *config-tree*)
        (dimensions-map (get-dimensions-map dimensions)))
    ;; traverse down to the specific dimension-name node
    ;; in the *same* order as given in the _dimensions_ parameter
    (dotimes (d (length dimensions-map))
      (let* ((d+1 (1+ d))
             (dimension (nth d+1 dimensions-map)))
        (setf dimension-name-node (conditionally-accumulate #'(lambda (c)
                                                                (equal (nth d+1 c)
                                                                       (first dimension)))
                                                            dimension-name-node))))
    (setf list dimension-name-node)
    ;; now inside the dimension-name node, traverse down to the dimension-value node
    (dotimes (d (length dimensions-map))
      (let* ((d+1 (1+ d))
            (dimension (nth d+1 dimensions-map)))
        (setf list (conditionally-accumulate #'(lambda (c)
                                                 (equal (nth d+1 c)
                                                        (second dimension)))
                                             list))))
    (unless list
      (push (list (join-string-list-with-delim "," dimensions-map :key #'second)
                  (list name value))
            dimension-name-node))))

(defun get-config (name &key (envt nil) (intl nil) (lang nil))
  (declare (ignore name envt intl lang)))
