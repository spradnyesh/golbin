(defpackage :golbin-system
  (:use :cl :asdf))

(in-package :golbin-system)

(defsystem golbin
  :components ((:module "utils"
                        :components ((:file "packages")
                                     (:file "config" :depends-on ("packages"))
                                     (:file "memcache" :depends-on ("packages"))
                                     (:file "html":depends-on ("packages"))
                                     (:file "helpers":depends-on ("packages"))
                                     (:file "init" :depends-on ("packages" "config"))))
               (:module "frontend"
                        :components ((:file "packages")
                                     (:file "config" :depends-on ("packages"))
                                     (:file "init" :depends-on ("packages" "config"))
                                     (:module "models"
                                              :components ((:file "article")
                                                           (:file "category")
                                                           (:file "user")
                                                           (:file "photo")
                                                           (:file "tag")
                                                           (:file "view")
                                                           (:file "misc"))
                                              :depends-on ("packages"))
                                     (:file "storage" :depends-on ("packages" "models"))
                                     (:file "views" :depends-on ("packages" "models"))
                                     (:file "routes" :depends-on ("packages" "views")))
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
  :depends-on (:restas :cl-who :local-time :cl-memcached :cl-ppcre :parenscript :cl-json))
