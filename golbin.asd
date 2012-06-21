(defpackage :golbin-system
  (:use :cl :asdf))

(in-package :golbin-system)

(defsystem golbin
  :components ((:module "utils"
                        :components ((:file "package")
                                     (:file "string":depends-on ("package"))
                                     (:file "config" :depends-on ("string"))
                                     (:file "memcache" :depends-on ("package"))
                                     (:file "html":depends-on ("package"))
                                     (:file "helpers":depends-on ("package"))
                                     (:file "pagination":depends-on ("package"))
                                     (:file "init" :depends-on ("config"))))
               (:module "frontend"
                        :components ((:module "src"
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
                                                           (:file "tmp-init" :depends-on ("storage"))
                                                           (:module "view"
                                                                    :components ((:file "css")
                                                                                 (:file "helpers")
                                                                                 (:file "template" :depends-on ("css" "helpers"))
                                                                                 (:file "views" :depends-on ("template")))
                                                                    :depends-on ("model"))
                                                           (:file "routes" :depends-on ("view")))))
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
  :depends-on (:restas :cl-who :local-time :cl-memcached :cl-ppcre :parenscript :cl-json :css-lite :restas-directory-publisher :cl-kyoto-cabinet))
