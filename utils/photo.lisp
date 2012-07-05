(in-package :hawksbill.utils)

(defmacro scale-photo-dimensions (dim-1 dim-2 max-1 max-2 orig-dim)
  `(progn
     (setf ,dim-1 ,max-1)
     (setf ,dim-2 (ceiling (* (/ ,orig-dim ,max-1) ,max-2)))))
(defun get-scaled-dimensions (max-width max-height orig-width orig-height)
  (let (new-width new-height)
    (if (> orig-width orig-height)
        (scale-photo-dimensions new-width new-height max-width max-height orig-width)
        (scale-photo-dimensions new-height new-width max-height max-width orig-height))
    (values new-width new-height)))
(defmacro scale-photo (dimension name)
  `(multiple-value-bind (new-width new-height)
       (get-scaled-dimensions ,(if (string-equal large-thumb
                                                 "large")
                                   *large-length*
                                   *thumb-length*) width height)
     (with-image (image new-width new-height t)
       (copy-image *default-image*
                   image 0 0 0 0
                   width height
                   :resize t
                   :dest-width new-width
                   :dest-height new-height)
       (write-image-to-file (format nil
                                    "~A~A"
                                    (directory-namestring (get-photo-upload-path ,name "photo"))
                                    ,name)
                            :image image))))
(defun save-photo-to-disk (orig-path new-path)
  (mv orig-path (ensure-directories-exist new-path)))
(defun save-photo-to-db (&rest args)
  (apply *save-photo-to-db-function* args))
(defun upload-photo (title tags photo &optional (user-id ""))
  (destructuring-bind (path-to-orig-file orig-filename content-type) photo
    (when (search "image" content-type :test #'char-equal)
      (let ((path-to-new-file (get-upload-file-path
                               (build-file-name path-to-orig-file
                                                user-id)
                               (second (split-sequence "/"
                                                       content-type
                                                       :test #'string-equal))
                               "images")))
        (save-photo-to-db title
                          (normalize-file-name orig-filename)
                          ;; the dest filename might change below
                          (save-photo-to-disk path-to-orig-file path-to-new-file)
                          tags
                          user-id)))))
