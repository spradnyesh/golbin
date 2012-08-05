(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro label-input (for-name-id typeof)
  `(with-html
     (:p :class "input"
         (:label :class "label" :for ,for-name-id
                 (str (format nil "~a: " ,for-name-id)))
         (:input :class "input" :type ,typeof
                 :name ,for-name-id
                 :id ,for-name-id))))
