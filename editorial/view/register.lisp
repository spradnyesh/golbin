(in-package :hawksbill.golbin.editorial)

(defun random-digits (&optional (n 4))
  (join-string-list-with-delim "" (loop for i from 1 to n collect (write-to-string (random 10)))))

(defun put-space-at-center (string)
  (let ((len-by-2 (/ (length string) 2)))
    (concatenate 'string
                 (subseq string 0 len-by-2)
                 " "
                 (subseq string len-by-2))))

(defun create-code-map ()
  (loop for i from 1 to 50 collect (put-space-at-center (random-digits))))

(defun create-code-map-image (code-map)
  (with-image* (400 235)
    (allocate-color 255 255 255) ; background: white
    (with-default-color ((allocate-color 0 0 0)) ; font: black
      (with-default-font (:medium)
        (let ((row 0)
              (col 0)
              (col-pad 75)
              (row-pad 20)
              (i 1))
          (dolist (code code-map)
            ;; index (font: red)
            (draw-string (+ 20 (* col-pad col)) (+ 20 (* row-pad row)) (string-pad (write-to-string i) #\Space 2)
                         :color (allocate-color 255 0 0))
            ;; code
            (draw-string (+ 40 (* col-pad col)) (+ 20 (* row-pad row)) code)
            (incf col)
            (incf i)
            (when (zerop (mod col 5))
              (incf row)
              (setf col 0))))))
    (write-image-to-file (make-pathname :name "code"
                                        :type "jpg"
                                        :defaults (merge-pathnames "../data/static/photos/" *home*))
                         :if-exists :supersede)))

(defun v-register-author-post ()
  (let* ((author-name (post-parameter "author-name"))
         (slug (slugify author-name)))
    (add-author (make-instance 'author
                               :name author-name
                               :alias author-name
                               :username slug
                               :handle slug
                               :password slug
                               :status :a))))
