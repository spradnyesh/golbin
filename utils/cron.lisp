(in-package :hawksbill.utils)

(defmacro cron-restart ()
  `(progn (stop-cron)
          (start-cron)))
