(in-package :hawksbill.utils)

;; make sure these are initialized in every project
(defvar *home* "")
(defvar *config* nil)
(defvar *environment* nil)
(defvar *translation-file-root* nil)
(defvar *db-init-ids* nil)
(defvar *save-photo-to-db-function* nil)
(defvar *pagination-limit* 10)

(defmacro scwe (key)
  `(search-config (with-environment ,key)))

(defmacro with-environment (param)
  `(concatenate 'string
                *environment*
                ,param))

(defmacro make-config-tuple (key value)
  `(list (format nil "~A" ,key) ,value))

(defun search-in-list (key lst)
  (loop for item in lst do
       (when (string-equal (first item) key)
         (return (first (rest item))))))

(defun search-config-helper (key lst)
  (if (= 1 (length key))
      (search-in-list (first key) lst)
      (search-config-helper (rest key) (search-in-list (first key) lst))))

(defun search-config (key &optional (lst *config*))
  (let* ((key (split-sequence:split-sequence "."
                                             (string-upcase key)
                                             :test #'string-equal))
         (config-value (search-config-helper key lst)))
    (if config-value
        config-value
        (search-config-helper (reverse (append (reverse (rest key)) '("master")))
                              lst))))
