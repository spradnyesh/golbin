(in-package :hawksbill.utils)

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

(defun conditionally-accumulate (cond list)
  (let ((rslt nil))
    (dolist (l list rslt)
      (when (funcall cond l)
        (push l rslt)))))

(defun paginate (list &key (offset 0) (limit *pagination-limit*))
  (let* ((list (if (consp list)
                   list
                   (list list)))
         (len (length list))
         (end (+ limit offset)))
    (if (and (not (minusp offset))
             (> len offset))
        (subseq list
                offset
                (if (and list (< end len))
                    end)))))
