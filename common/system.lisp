(in-package :hawksbill.golbin)

(defun golbin-restart (&optional (restart nil))
  (when restart
    (ql:quickload :golbin))
  (setf *system-status* nil)
  (hawksbill.golbin.frontend::fe-restart)
  (hawksbill.golbin.editorial::ed-restart))
