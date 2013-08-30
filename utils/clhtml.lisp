(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; chtml helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun clean-html (html)
  (parse html (make-string-sink)))

(defun remove-html-head-body (html)
  (nth 2 (nth 3 html)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; manipulate lists created by chtml:parse
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defclass node ()
  ((name :initarg :name :initform nil :accessor name)
   (children :initarg :children :initform nil :accessor children)
   (attributes :initarg :attributes :initform nil :accessor attributes)
   (parent :initarg :parent :initform nil :accessor parent)))

(defun make-tree-from-list (root parent)
  (let ((tree (make-instance 'node
                             :name (first root)
                             :attributes (second root)
                             :parent parent)))
    (setf (children tree)
          (loop for node in (rest (rest root))
               collecting (make-tree node tree)))
    tree))

(defun search-node (name attribute child-name)
  (declare (ignore name attribute child-name)))

(defun make-list-from-tree (tree)
  (declare (ignore tree)))
