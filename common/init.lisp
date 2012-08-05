(in-package :hawksbill.golbin)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; parameters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defparameter *site-name* "Golbin")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setf *home*
      (make-pathname :directory
                     (pathname-directory
                                (load-time-value
                                 (or #.*compile-file-pathname* *load-pathname*)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; storages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar *config* nil)
(defvar *article-storage* nil)
(defvar *author-storage* nil)
(defvar *category-storage* nil)
(defvar *tag-storage* nil)
#|(defvar *view-storage* nil)|#
#|(defvar *count-storage* nil)|#
