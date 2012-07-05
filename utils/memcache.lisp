(in-package :hawksbill.utils)

#|(
 (defun memcache-connect ()
   (setf *use-pool* ((get-config "memcache.use-pool"))
         (setf *memcache*
               (mc-make-memcache-instance
                :ip ((get-config "memcache.host")
                     :port ((get-config "memcache.port")
                            :pool-size ((get-config "memcache.pool-size"))))))))

 (defmacro with-cache (&body body)
   `(let ((data (mc-get+ key)))
      (if data
          data
          (progn
            (setf data ,@body)
            (mc-store key data)
            data)))))|#
