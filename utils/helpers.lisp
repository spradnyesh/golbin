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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; pagination
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
(defun pagination-low (page-number &optional (pagination-limit *pagination-limit*))
  "page number can be 0 at minimum"
  (let ((p (- page-number (/ pagination-limit 2)))
        (min 0))
    (if (< p min)
        min
        p)))
(defun pagination-high (page-number max-results &optional (pagination-limit *pagination-limit*))
  "page number can be (/ max-results *article-pagination-limit*) at maximum"
  (let ((p (+ page-number (/ pagination-limit 2)))
        (max (/ max-results pagination-limit)))
    (if (> p max)
        max
        p)))
(defun pagination-markup (route page-number max-results &optional (pagination-limit *pagination-limit*))
  "build URLs b/n route?p=low and route?p=high"
  ;; don't show pagination-markup when page-number = 13, *article-pagination-limit* = 10 and max-results = 100 ;)
  (if (< (* page-number pagination-limit) max-results)
      (with-html
        (:ul
         (loop for i
            from (pagination-low page-number pagination-limit)
            to (pagination-high page-number max-results pagination-limit) do
            (if (eql page-number i)
                (htm (:li :id "pagination-match" (str i)))
                (htm (:li (:a :href (genurl route :page i) (str i))))))))
      ""))
