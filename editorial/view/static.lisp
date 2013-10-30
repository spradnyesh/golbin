(in-package :hawksbill.golbin.editorial)

(defun v-tnc ()
  (template
   :title "tnc"
   :js nil
   :body (<:div :class "wrapper static"
                (translate "tnc-body"))))

(defun v-originality ()
  (template
   :title "originality"
   :js nil
   :body (<:div :class "wrapper static"
                (translate "originality-body"))))

(defun v-faq ()
  (template
   :title "faq"
   :js nil
   :body (<:div :class "wrapper static"
                (translate "faq-body"))))

(defun v-help ()
  (template
   :title "help"
   :js nil
   :body (<:div :class "wrapper static"
                (translate "help-body"))))
