(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro nav- (list class route-name route-param field)
  `(with-html
    (:ul
     (dolist (l ,list)
       (htm
        (:li :class ,class
             (:a :href (genurl ',route-name
                               ,route-param (,field l))
                 (str (name l)))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun nav-categories-json ()
  (let ((rslt nil))
    (dolist (cat-node (get-category-tree *category-storage*))
      (let* ((cat (first cat-node))
             (subcat-node (second cat-node))
             (c-node nil))
        (push (make-instance 'navigation-node
                             :name (name cat)
                             :url (slug cat)#|(genurl 'route-cat
                                          :cat (slug cat))|#)
              c-node)
        (dolist (subcat subcat-node)
          (when (status subcat)     ; show only enabled sub-categories
            (let ((s-node (make-instance 'navigation-node
                                         :name (name subcat)
                                         :url (slug subcat)#|(genurl 'route-cat-subcat
                                                      :cat (slug cat)
                                                      :subcat (slug subcat))|#)))
              (push s-node c-node))))
        (push (nreverse c-node) rslt)))
    (encode-json-to-string (nreverse rslt))))

(defun nav-tags ()
  (nav- (get-all-tags *tag-storage*) "tag" route-tag :tag slug))

(defun nav-authors ()
  (nav- (get-all-authors *author-storage*) "author" route-author :author handle))

(defun latest-articles-markup (&key (offset 0) (category (most-popular-categories)))
  (declare (ignore offset))
  (latest-articles category))

(defun most-popular-articles-markup (&key (offset 0) (category (most-popular-categories)))
  (declare (ignore offset))
  (most-popular-articles category))
