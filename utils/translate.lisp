(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun load-language (file-path)
  (let ((ht (make-hash-table :test 'equal))
        (rslt nil))
    (with-open-file (stream file-path)
      (do ((line (read-line stream nil)
                 (read-line stream nil)))
          ((null line))
        (setf rslt (split-sequence "=" line :test #'string=))
        (setf (gethash (first rslt) ht)
              (join-string-list-with-delim "=" (rest rslt)))))
    ht))

(defun get-translation (key &optional (lang *lang*))
  (gethash key (gethash lang *translation-table*)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; APIs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun load-all-languages (&optional (locale-path (get-config "path.locale")))
  (setf *translation-table* (make-hash-table :test 'equal))
  (dolist (f (directory (concatenate 'string
                                     (get-parent-directory-path-string locale-path) "??-??.lisp")))
    (setf (gethash (pathname-name f) *translation-table*) (load-language f))))

(defun show-translation-tree ()
  (maphash #'(lambda (k-out v-out)
               (format t "########## [~a]~%" k-out)
               (maphash #'(lambda (k-in v-in)
                            (format t "[~a]: [~a]~%" k-in v-in))
                        v-out)
               (format t "~%"))
           *translation-table*))

;; if #params are less than #~a in translated format-string
;; then die silently and return nil instead of an error
(defun translate (key &rest params)
  (handler-case (apply #'format nil (get-translation key) params)
    (sb-format:format-error () nil)))
