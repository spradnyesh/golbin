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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar *config-tree* nil "((('envt'))
                            (('intl'))
                            (('lang'))
                            (('envt' 'intl'))
                            (('envt' 'lang'))
                            (('intl' 'lang'))
                            (('intl' 'envt'))
                            (('lang' 'intl'))
                            (('lang' 'envt'))
                            (('envt' 'intl' 'lang')
                                    (('dev' 'IN' 'en-IN') ('name1' 'val1') ('name2' 'val2'))
                                    (('prod' 'IN' 'en-IN') ('name1' 'val3') ('name2' 'val4')))
                            (('envt' 'lang' 'intl'))
                            (('intl' 'envt' 'lang'))
                            (('intl' 'lang' 'envt'))
                            (('lang' 'envt' 'intl'))
                            (('lang' 'intl' 'envt')))")

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
      (push (list item) rslt)
      (dolist (d diff)
        (push (cons d item)
              queue)))))

(setf *config-tree* (sort (make-config-tree *dimensions*)
                          #'(lambda (a b)
                              (< (length (first a)) (length (first b))))))

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

(defun get-dimension-node (full-dimensions-map &optional (current-dimensions-map full-dimensions-map) (degree 0) (root *config-tree*))
  "traverse down to the specific dimension-name node
   in the *same* order as given in the _dimensions_ parameter
   pass 0: (GET-DIMENSION-NODE (('lang' 'en-US') ('envt' 'dev') ('intl' 'IN')))
   pass 1: (GET-DIMENSION-NODE (('lang' 'en-US') ('envt' 'dev') ('intl' 'IN'))
                           (('envt' 'dev') ('intl' 'IN')) 1
                           (('lang') ('lang' 'intl') ('lang' 'envt')
                            ('lang' 'envt' 'intl') ('lang' 'intl' 'envt')))
   pass 2: (GET-DIMENSION-NODE (('lang' 'en-US') ('envt' 'dev') ('intl' 'IN'))
                             (('intl' 'IN')) 2
                             (('lang' 'envt') ('lang' 'envt' 'intl')))"
  (let* ((current-dimension (first current-dimensions-map))
         (rest-dimensions (rest current-dimensions-map))
         (current-nodes (conditionally-accumulate #'(lambda (c)
                                                      (equal (nth degree c)
                                                             (first current-dimension)))
                                                  root)))
    (if (null rest-dimensions)
        (conditionally-accumulate #'(lambda (c)
                                      (= (length c)
                                         (length full-dimensions-map)))
                                  current-nodes)
        (get-dimension-node full-dimensions-map rest-dimensions (1+ degree) current-nodes))))

(defun get-dimension-value-node (full-dimensions-map current-dimensions-map nodes &optional (degree 0))
  (let* ((current-dimension (first current-dimensions-map))
         (rest-dimensions (rest current-dimensions-map))
         (current-nodes (conditionally-accumulate #'(lambda (c)
                                                      (equal (nth degree c)
                                                             (first current-dimension)))
                                                  root)))
    (if (null rest-dimensions)
        (conditionally-accumulate #'(lambda (c)
                                      (= (length c)
                                         (length full-dimensions-map)))
                                  current-nodes)
        (get-dimension-node full-dimensions-map rest-dimensions (1+ degree) current-nodes))))

(defun add-config (name value dimensions)
  (let ((list nil)
        (dimension-name-node *config-tree*)
        (dimensions-map (get-dimensions-map dimensions)))
    (dotimes (d (length dimensions-map))
      (let* ((d+1 (1+ d))
             (dimension (nth d+1 dimensions-map)))
        (setf dimension-name-node )))
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

(defun get-config (name dimensions)
  (declare (ignore name dimensions)))
