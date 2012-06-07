(defpackage :golbin-system
  (:use :cl :asdf))

(in-package :golbin-system)

(defsystem golbin
  :components ((:module
				"utils"
				:components ((:file "packages")
							 (:file "config" :depends-on ("packages"))
							 (:file "memcache" :depends-on ("packages"))
							 (:file "html":depends-on ("packages"))
							 (:file "init" :depends-on ("packages" "config"))))
			   (:module
				"frontend"
				:components ((:file "packages")
							 (:file "models" :depends-on ("packages"))
							 (:file "storage" :depends-on ("packages" "models"))
							 (:file "routes" :depends-on ("packages" "models")))
				:depends-on ("utils"))
			   #|(:module
				"boomerang"
				:components ((:file "src")))|#
			   #|(:module
				"reports"
				:components ((:file "packages")
							 (:file "routes" :depends-on ("packages"))
							 (:file "models" :depends-on ("packages"))
							 (:file "views" :depends-on ("packages"))))|#)
  :depends-on (:hunchentoot :restas :cl-who :local-time :cl-memcached))
