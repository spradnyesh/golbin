(in-package :hawksbill.golbin)

(defun golbin-restart ()
  (hawksbill.golbin.frontend::fe-restart)
  (hawksbill.golbin.editorial::ed-restart))
