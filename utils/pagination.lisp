(in-package :hawksbill.utils)

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
(defmacro pagination-markup (route page-number max-results pagination-limit &rest route-params)
  "build URLs b/n route?p=low and route?p=high"
  ;; don't show pagination-markup when page-number = 13, *article-pagination-limit* = 10 and max-results = 100 ;)
  `(if (< (* ,page-number ,pagination-limit) ,max-results)
       (with-html
         (:ol :class "pagination"
              (loop for i
                 from (pagination-low ,page-number ,pagination-limit)
                 to (pagination-high ,page-number ,max-results ,pagination-limit) do
                 (if (eql ,page-number i)
                     (htm (:li :class "disabled" (str i)))
                     (htm (:li (:a :href (genurl ,route ,@route-params :page i) (str i)))))))
         (:p (str (format nil "~a results" ,max-results))))
       ""))