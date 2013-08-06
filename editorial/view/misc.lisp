(in-package :hawksbill.golbin.editorial)

(defun v-ajax-tags ()
  (encode-json-to-string (get-tags-for-autocomplete (get-parameter "term"))))

(defmacro submit-success (route)
  `(if ajax
       (encode-json-to-string `((:status . "success")
                                (:data . ,,route)))
       (redirect ,route)))

(defmacro submit-error (route)
  `(if ajax
       (encode-json-to-string `((:status . "error")
                                (:errors . ,err0r)))
       ;; no-ajax => we lose all changes here
       (redirect ,route)))
