(defpackage :golbin-system
  (:use :cl :asdf))

(in-package :golbin-system)

(defsystem golbin
  :components ((:module "utils"
                        :components ((:file "package")
                                     (:file "config" :depends-on ("package"))
                                     (:file "memcache" :depends-on ("package"))
                                     (:file "html":depends-on ("package"))
                                     (:file "string":depends-on ("package"))
                                     (:file "helpers":depends-on ("package"))
                                     (:file "init" :depends-on ("package" "config"))))
               (:module "frontend"
                        :components ((:file "package")
                                     (:module "model"
                                              :components ((:file "article")
                                                           (:file "category")
                                                           (:file "user")
                                                           (:file "photo")
                                                           (:file "tag")
                                                           (:file "view")
                                                           (:file "misc"))
                                              :depends-on ("package"))
                                     (:file "storage" :depends-on ("model"))
                                     (:file "config" :depends-on ("storage"))
                                     (:file "init" :depends-on ("package"))
                                     (:module "view"
                                              :components ((:file "helpers")
                                                           (:file "template")
                                                           (:file "views"))
                                              :depends-on ("model"))
                                     (:file "routes" :depends-on ("view")))
                        :depends-on ("utils"))
               #|(:module
               "boomerang"
               :components ((:file "src")))|#
               #|(:module
               "reports"
               :components ((:file "package")
               (:file "routes" :depends-on ("package"))
               (:file "models" :depends-on ("package"))
               (:file "views" :depends-on ("package"))))|#)
  :depends-on (:restas :cl-who :local-time :cl-memcached :cl-ppcre :parenscript :cl-json))
