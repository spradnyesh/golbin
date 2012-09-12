(in-package :hawksbill.utils)

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
  ;; steps
  ;; 1. strip (left and right spaces)
  ;;     (string-trim " " "  trim me  ")
  ;; 1. "&" -> "and", "@" -> "at", "  *" -> " " (strip multiple consequtive spaces to a single space)
  ;;     (cl-ppcre:regex-replace-all " +" "rt   ear  &e  snr  &es  rnt" " ")
  ;; 1. " " -> "-"
  ;;     (substitute #\- #\Space "spr @y.com")
  ;; 1. remove all non-alphanum characters
  ;;     (cl-ppcre:regex-replace-all "[^a-z0-9]" "esnt@!#<,.fewnt" "")
  ;; 1. downcase
  ;;     (string-downcase "RAT")
  (string-downcase
   (regex-replace-all                   ; " " -> "-"
    " "
    (regex-replace-all                  ; " +" -> " "
     " +"
     (regex-replace-all           ; remove all non-alphanum characters
      "[^- a-zA-Z0-9]"
      (regex-replace-all                ; "@" -> "or"
       "@"
       (regex-replace-all               ; "&" -> "and"
        "&"
        (string-trim " " title)         ; remove left/right spaces
        "and")
       "at")
      "")
     " ")
    "-")))
