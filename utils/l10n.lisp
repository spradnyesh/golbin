(in-package :hawksbill.utils)

#|(
 (let ((*my-bundle* (make-instance 'bundle)))
   (defun init-l10n-repo ()
     (declare (optimize (safety 3)))
     (let ((locale (scwe ".locale")))
       (with-open-file (fp (merge-pathnames
                            (make-pathname :directory '(:relative "data"
                                                        "translations")
                                           :name locale
                                           :type "lisp")
                            (scwe ".basepath")))
         (dolist (l (read fp))
           (add-resource (bundle locale)
                         (car l) (car (cdr l))))))))


 (defun rb-init ()
   (setf *translation-file-root*
         (concatenate 'string "/"
                      (join-string-list-with-delim
                       (rest (pathname-directory
                              (if (boundp '*home*)
                                  *home*
                                  *default-pathname-defaults*)))
                       "/")
                      "/"
                      ((get-config "i18n.trans-root")))
         (let ((locale ((get-config "i18n.l10n.locale")))
               (when locale
                 (load-language locale)))))))|#
