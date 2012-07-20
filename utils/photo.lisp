(in-package :hawksbill.utils)

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

#|(defmacro scale-photo (dimension name)
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
                            :image image))))|#

;;; photos is really a list of photo names
;;; typeof: author, article
;;; TODO: find a way to get the config names automatically from config-tree instead of hardcoding them below. the drawback w/ the below is that everytime a new photo config gets added to config-tree, it'll have to be added here too.
(defun scale-photos (photos typeof out-directory)
  (let ((sizes nil))
	(cond ((string-equal typeof "author")
		   (push (list (get-config "photo.author.avatar.max-width")
					   (get-config "photo.author.avatar.max-height")) sizes)
		   (push (list (get-config "photo.author.article-logo.max-width")
					   (get-config "photo.author.article-logo.max-height")) sizes))
		  ((string-equal typeof "article")
		   (push (list (get-config "photo.article-lead.left.max-width")
					   (get-config "photo.article-lead.left.max-height")) sizes)
		   (push (list (get-config "photo.article-lead.right.max-width")
					   (get-config "photo.article-lead.right.max-height")) sizes)
		   (push (list (get-config "photo.article-lead.block.max-width")
					   (get-config "photo.article-lead.block.max-height")) sizes)))
	(dolist (photo photos)
	  )))