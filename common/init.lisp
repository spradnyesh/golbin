(in-package :hawksbill.golbin)

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; i18n
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setf *translation-file-root* (get-directory-path-string (merge-pathnames "locale/" *home*)))
