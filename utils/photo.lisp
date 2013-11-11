(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; misc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro build-sized-image (path file-name x &optional (y x))
  `(concatenate 'string
                ,path
                (regex-replace "\\\."
                               ,file-name
                               (concatenate 'string
                                            "_"
                                            ,x
                                            "x"
                                            ,y
                                            "."))))

(defmacro build-gravtar-image (hash alt size)
  `(<:img :alt ,alt
          :src (concatenate 'string
                            (get-config "gravatar.url")
                            ,hash
                            "?s="
                            ,size
                            "&d="
                            (get-config "gravatar.type"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; upload
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun save-photo-to-disk (photo)
  (destructuring-bind (orig-path orig-filename content-type) photo
    (when (search "image" content-type :test #'char-equal)
      (let* ((orig-filename (normalize-file-name orig-filename))
             (new-path (get-upload-file-path
                        (build-file-name orig-path)
                        (second (split-sequence "/" content-type :test #'string-equal))
                        "photos")))
        (values orig-filename (mv orig-path (ensure-directories-exist new-path)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; scaling
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro scale-photo-dimensions (dim-1 dim-2 max)
  `(progn
     (setf ,dim-2 (ceiling (* (/ ,max ,dim-1) ,dim-2)))
     (setf ,dim-1 ,max)))

;; m- => max-, o- => orig-
(defun get-scaled-dimensions (m-width m-height width height)
  (if (> width height)
      ;; w > h, so w = mw and h < mh
      (scale-photo-dimensions width height m-width)
      ;; w <= h, so h = mh and w < mw
      (scale-photo-dimensions height width m-height))
  (values width height))

;; m- => max-, n- => new-, o- => orig-
(defun scale-and-save-photo (o-path n-path o-filename m-width m-height)
  (let* ((name-extn (split-sequence "." o-filename :test #'string-equal))
         (n-filename (format nil
                             "~a/~a_~ax~a.~a"
                             n-path
                             (first name-extn)
                             m-width
                             m-height
                             (second name-extn))))
    (unless (probe-file n-filename) ; do-the-do only if the file does not already exist
      (with-image-from-file (o-photo (merge-pathnames o-filename o-path))
        (multiple-value-bind (o-width o-height)
            (image-size o-photo)
          (multiple-value-bind (n-width n-height)
              (get-scaled-dimensions m-width
                                     m-height
                                     o-width
                                     o-height)
            #|(format t "~a x ~a ::: ~a x ~a -> ~a x ~a~%" m-width m-height o-width o-height n-width n-height)|#
            (with-image (n-photo n-width n-height t)
              (copy-image o-photo
                          n-photo
                          0 0 0 0
                          o-width o-height
                          :resize t
                          :dest-width n-width
                          :dest-height n-height)
              (write-image-to-file n-filename
                                   :image n-photo))))))))
