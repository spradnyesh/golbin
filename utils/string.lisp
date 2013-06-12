(in-package :hawksbill.utils)

;; http://stackoverflow.com/questions/211717/common-lisp-programmatic-keyword
(defun make-keyword (name)
  (values (intern (string-upcase name) "KEYWORD")))

(defun trim-name (name)
  (first (split-sequence " " name :test #'string-equal)))

;; prepend/append (based on 'direction) string of 'character
;; of length (- 'length (length 'string)) to given 'string
(defun string-pad (string character length &optional (direction :l))
  (let ((str-len (length string)))
    (if (> length str-len)
        (let ((padder (make-string (- length str-len) :initial-element character)))
          (case direction
            (:l (concatenate 'string padder string))
            (:r (concatenate 'string string padder))))
        string)))

(defun join-string-list-with-delim (delim list &key (key nil))
  (when list
    (let ((first-element (if key
                             (funcall key (first list))
                             (first list))))
      (if (= 1 (length list))
          first-element
          (concatenate 'string first-element
                       delim
                       (join-string-list-with-delim delim (rest list) :key key))))))

(defun split-string-by-delim (string delim)
  (conditionally-accumulate #'(lambda (l) (not (string-equal l "")))
                            (mapcar #'(lambda (l) (string-trim " " l))
                                    (split-sequence delim string
                                                    :test #'string-equal))))

(defun nil-or-empty (string)
  (when (or (null string)
            (string-equal "" string))
    t))

(defun slugify (title)
  "create slug out of title: took help from http://stackoverflow.com/questions/1302022/best-way-to-generate-slugs-human-readable-ids-in-rails"
  (string-downcase
   (regex-replace-all                   ; " " -> "-"
    " "
    (regex-replace-all                  ; " +" -> " "
     " +"
     (regex-replace-all        ; remove all special/invalid characters
      "[\/\\\"\?~`!@#$%^&*()+=|{}':;<,>.]"
      (string-trim " " title)           ; remove left/right spaces
      "")
     " ")
    "-")))
