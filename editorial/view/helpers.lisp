(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro label-input (for-name-id typeof)
  `(<:p (<:label :class "label" :for ,for-name-id
                 (format nil "~a: " (translate ,for-name-id)))
        (<:input :class "input" :type ,typeof
                 :name ,for-name-id
                 :id ,for-name-id)))
