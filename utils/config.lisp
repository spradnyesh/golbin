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

(defun are-dimension-nodes-equal (dimensions-map node fn)
  (dotimes (i (length dimensions-map))
    (when (not (string-equal (nth i node)
                      (funcall fn (nth i dimensions-map))))
      (return-from are-dimension-nodes-equal nil)))
  t)

(defun get-dimension-node (dimensions-map &optional (config-tree *config-tree*))
  (let ((len (length dimensions-map)))
    (dolist (ct config-tree)
      (let ((node (first ct)))
        (when (and (= len (length node))
                   (are-dimension-nodes-equal dimensions-map node #'first))
          (return-from get-dimension-node ct)))))
  nil)

(defun get-dimension-value-node (dimensions-map dimensions-value-nodes)
  (dolist (dvn dimensions-value-nodes)
    (let ((node (first dvn)))
      (when (are-dimension-nodes-equal dimensions-map node #'second)
        (return-from get-dimension-value-node dvn))))
  nil)

(defun get-config (name dimensions &optional (config-tree *config-tree*))
  (let* ((dimensions-map (get-dimensions-map dimensions))
         (config-value-node (get-dimension-value-node dimensions-map
                                                      (rest (get-dimension-node dimensions-map config-tree)))))
    (find name config-value-node :test #'string-equal)))

(defun make-value-node (dimensions-map)
  (let ((rslt nil))
    (dolist (m dimensions-map)
      (push (second m) rslt))
    (list (reverse rslt))))

(defun add-config (name value dimensions &optional (config-tree *config-tree*))
  (let* ((dimensions-map (get-dimensions-map dimensions))
         (dimension-node (get-dimension-node dimensions-map config-tree))
         (value-node (get-dimension-value-node dimensions-map
                                               (rest dimension-node))))
    (print dimension-node)
    (print value-node)
    (if value-node
        (append value-node (list (list name value)))
        (append dimension-node
                (list (append (make-value-node dimensions-map)
                              (list (list name value)))))))
  config-tree)
