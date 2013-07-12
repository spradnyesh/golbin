(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; http://lisp-univ-etc.blogspot.kr/2009/03/cl-who-macros.html
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *who-macros* (make-array 0 :adjustable t :fill-pointer t)
  "Vector of macros, that MACROEXPAND-TREE should expand.")

(defun macroexpand-tree (tree)
  "Recursively expand all macro from *WHO-MACROS* list in TREE."
  (cl-who::apply-to-tree
   (lambda (subtree)
     (macroexpand-tree (macroexpand-1 subtree)))
   (lambda (subtree)
     (and (consp subtree)
   (find (first subtree) *who-macros*)))
   tree))

(defmacro def-internal-macro (name attrs &body body)
  "Define internal macro, that will be added to *WHO-MACROS*
and macroexpanded during W-H-O processing.
Other macros can be defined with DEF-INTERNAL-MACRO, but a better way
would be to add additional wrapper, that will handle such issues, as
multiple evaluation of macro arguments (frequently encountered) etc."
  `(eval-when (:compile-toplevel :load-toplevel :execute)
     (prog1 (defmacro ,name ,attrs
              ,@body)
       (unless (find ',name *who-macros*)
         ;; the earlier the macro is defined, the faster it will be found
         ;; (optimized for frequently used macros, like the inernal ones,
         ;; defined first)
         (vector-push-extend ',name *who-macros*)))))

;; basic who-macros

(def-internal-macro htm (&rest rest)
  "Defines macroexpasion for HTM special form."
  (cl-who::tree-to-commands rest '*who-stream*))

(def-internal-macro str (form &rest rest)
  "Defines macroexpansion for STR special form."
  (declare (ignore rest))
  (let ((result (gensym)))
    `(let ((,result ,form))
       (when ,result (princ ,result *who-stream*)))))

(def-internal-macro esc (form &rest rest)
  "Defines macroexpansion for ESC special form."
  (declare (ignore rest))
  (let ((result (gensym)))
    `(let ((,result ,form))
       (when ,form (write-string (escape-string ,result)
                                 *who-stream*)))))

(def-internal-macro fmt (form &rest rest)
  "Defines macroexpansion for FMT special form."
  `(format *who-stream* ,form ,@rest))
