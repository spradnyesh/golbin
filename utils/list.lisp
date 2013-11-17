(in-package :hawksbill.utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; list manipulation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun conditionally-accumulate (cond list)
  (remove-if #'null (mapcar #'(lambda (l) (when (funcall cond l) l)) list)))

(defun replace-all (list item replacement &key (test #'eql))
  (loop for l in list
     collect (if (funcall test item l)
                 replacement
                 l)))

(defun insert-at (list item position)
  (let ((len (length list)))
    (cond ((< position 0) (return-from insert-at list))
          ((> position len) (setf position len)))
    (let ((rslt nil))
      (dotimes (i position)
        (setf rslt (append rslt (list (pop list)))))
      (setf rslt (append rslt (list item)))
      (dotimes (i (length list))
        (setf rslt (append rslt (list (pop list)))))
      rslt)))

(defun splice (list &key (from 0) (to (1- (length list))))
  (if (and list
           (>= from 0)
           (>= to from)
           (< to (length list)))
      (let ((rslt nil))
        (dotimes (i (1+ (- to from)))
          (push (nth (+ from i) list) rslt))
        (nreverse rslt))
      (values nil list)))

(defun get-random-from-list (list)
  (nth (random (length list)) list))

(defun subset (l1 l2)
  (when (<= (length l1) (length l2))
    (dolist (l l1)
      (unless (member l l2)
        (return nil)))
    t))

(defun group-list (fn list)
  (let ((ht (make-hash-table :test 'equal))
        (key nil)
        (ele nil)
        (rslt nil))
    (dolist (l list)
      (setf key (funcall fn l))
      (setf ele (push l (gethash key ht)))
      (setf (gethash key ht) ele))
    (maphash #'(lambda (k v) (declare (ignore k)) (push v rslt)) ht)
    (values rslt ht)))

;; '((1.1 1.2) (2.1 2.2)) => '((1.1 1.2 nil) (2.1 2.2 nil))
(defun append-nil (list-of-lists)
  (let ((rslt nil))
    (dolist (list list-of-lists)
      (push (append list '(nil)) rslt))
    (reverse rslt)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; permutations, combinations and cross-products
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; '(1 2 3) => '((1) (2) (3) (1 2) (1 3) (2 3) (1 2 3)), but not in that order
;; 1-to-n sized combinations
(defun combinations-i (list)
  (let ((rslt nil))
    (dolist (l list)
      (dolist (r rslt)
        (push (append (list l) r) rslt))
      (push (list l) rslt))
    rslt))

;; '(1 2 3) => '((1 2 3) (1 3 2) (2 1 3) (2 3 1) (3 1 2) (3 2 1))
;; (only) n sized permutations
;; http://forum.codecall.net/topic/46721-lisp-permutations/
(defun permutations (l)
  (if (null l) '(())
      (mapcan #'(lambda (x)
                  (mapcar #'(lambda (y) (cons x y))
                          (permutations (remove x l :count 1)))) l)))

;; '(1 2 3) => '((1) (2 1) (1 2) (2) (3 2) (2 3) (3 2 1) (3 1 2) (2 3 1) (2 1 3) (1 3 2)
;; (1 2 3) (3 1) (1 3) (3))
;; 1-to-n sized permutations
(defun permutations-i (list)
  (let ((rslt nil))
    (dolist (l (loop for c in (combinations-i list)
                  collect (permutations c)))
      (setf rslt (append l rslt)))
    rslt))

;; '((1.1 1.2) (2.1 2.2) (3.1 3.2 3.3)) => '((1.1) (1.2) (2.1) (2.2) (3.1) (3.2) (3.3) (1.1 2.1) (1.1 2.2) (1.1 3.1) (1.1 3.2) (1.1 3.3) (1.2 2.1) (1.2 2.2) (1.2 3.1) (1.2 3.2) (1.2 3.3) (2.1 3.1) (2.1 3.2) (2.1 3.3) (2.2 3.1) (2.2 3.2) (2.2 3.3) (1.1 2.1 3.1) (1.1 2.1 3.2) (1.1 2.1 3.3) (1.1 2.2 3.1) (1.1 2.2 3.2) (1.1 2.2 3.3) (1.2 2.1 3.1) (1.2 2.1 3.2) (1.2 2.1 3.3) (1.2 2.2 3.1) (1.2 2.2 3.2) (1.2 2.2 3.3)), but not necessarily in that order
;; 1-n sized cross-products
(defun cross-product-i (list-of-lists)
  (let ((rslt nil)
        (list-of-lists (append-nil list-of-lists)))
    (dolist (f (first list-of-lists))
      (push f rslt))                    ; rslt => '(1.1 1.2 nil)
    (dolist (list (rest list-of-lists)) ; list => '(2.1 2.2 nil), etc
      (dolist (r rslt)                  ; r => 1.1 1.2 nil
        (dolist (l list)                ; l => 2.1 2.2 nil
          (push (append (if (atom r) (list r) r)
                        (if (atom l) (list l) l))
                rslt)))) ; rslt => '(1.1 1.2 (1.1 2.1) (1.1 2.2) (1.1 nil) ...)
    ;; remove internal-nil, atoms and duplicates
    (remove-if #'atom (remove-duplicates (loop for i in (remove-if #'atom rslt)
                                            collect (remove-if #'null i)) :test #'equal))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hashmap manipulation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun print-map (hm)
  (maphash #'(lambda (k v) (format t "~a: ~a~%" k v))
           hm))

(defmacro push-key-hm (obj)
  `(setf (gethash key hm) ,obj))

(defun push-map (hm key ele)
  (let ((obj (gethash key hm)))
    (if obj
        (push-key-hm (push ele obj))
        (push-key-hm (list ele)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; set manipulation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun make-set (list &rest args)
  (let ((rslt nil))
    (dolist (l list)
      (setf rslt (apply #'adjoin l rslt args)))
    rslt))
