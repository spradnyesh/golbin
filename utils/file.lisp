(in-package :hawksbill.utils)

(defun normalize-file-name (file-name)
  ;; strip directory info sent by Windows browsers
  (when (search "Windows" (user-agent) :test #'char-equal)
    (setf file-name (regex-replace ".*\\\\" file-name "")))
  file-name)

;;; copied shamelessly ;) from http://paste.lisp.org/display/46015
;;; using buf-size of 1MB
(defun copy-stream (input output &optional (element-type (stream-element-type input)) (buf-size 1048576))
  "Reads data from INPUT and writes it to OUTPUT. Both INPUT and OUTPUT must be streams, they will be passed to read-sequence/write-sequence and must have compatable element-types."
  (loop
     with buffer-size = buf-size
     with buffer = (make-array buffer-size :element-type element-type)
     for bytes-read = (read-sequence buffer input)
     while (= bytes-read buffer-size)
     do (write-sequence buffer output)
     finally (write-sequence buffer output :end bytes-read)))

(defun get-parent-directory-path-string (path)
  (join-string-list-with-delim
   (reverse (rest (reverse
                   (split-sequence "/"
                                   path
                                   :test #'string-equal))))
   "/"))

(defun get-new-path (path)
  (let* ((parent-directory (get-parent-directory-path-string path))
         (name (pathname-name path))
         (type (pathname-type path))
         (id (length (directory (pathname (format nil
                                                  "~A/~A*.~A"
                                                  parent-directory
                                                  name
                                                  type))))))
    (format nil "~A/~A-~A.~A" parent-directory name id type)))

(defun mv (src dest)
  (when (probe-file src)
    (with-open-file (fp-in src
                           :element-type '(unsigned-byte 8))
      (when (probe-file dest) ; if dest exists, then create a new dest-name and return it
        (setf dest (get-new-path dest)))
      (with-open-file (fp-out dest
                              :element-type '(unsigned-byte 8)
                              :direction :output
                              :if-does-not-exist :create)
        (copy-stream fp-in fp-out)))
    dest))

(defun build-file-name (file-name user-id)
  (let ((md5 (md5sum-file file-name))
        (new-file-name ""))
    (dotimes (i (length md5))
      (setf new-file-name (concatenate 'string
                                       new-file-name
                                       (write-to-string (aref md5 i)))))
    (unless (string-equal user-id "")
      (setf new-file-name
            (concatenate 'string
                         user-id
                         "_"
                         new-file-name)))
    new-file-name))

(defun get-upload-file-path (filename filetype upload-type)
  (multiple-value-bind (year month date)
      (get-year-month-date)
    (make-pathname
     :name filename
     :type filetype
     :defaults (make-pathname :directory
                              (append (pathname-directory (get-config "path.uploads"))
                                      (list upload-type
                                            (write-to-string year)
                                            (write-to-string month)
                                            (write-to-string date)))))))
