(defpackage :golbin-system
  (:use :cl :asdf))

(in-package :golbin-system)

(defsystem golbin
  :components ((:module "utils"
                        :components ((:file "package")
                                     (:file "string" :depends-on ("package"))
                                     (:file "config" :depends-on ("string"))
                                     (:file "memcache" :depends-on ("package"))
                                     (:file "html" :depends-on ("package"))
                                     (:file "helpers" :depends-on ("package"))
                                     (:file "pagination" :depends-on ("package"))
                                     (:file "init" :depends-on ("config"))
                                     (:file "db" :depends-on ("config"))))
               (:file "package" :depends-on ("utils")) ; common for all of model, frontend, boomerang and reports
               (:module "model" ; so that it can be shared b/n frontend, editorial, boomerang
                        :components ((:file "article")
                                     (:file "category")
                                     (:file "user")
                                     (:file "photo")
                                     (:file "tag")
                                     (:file "view")
                                     (:file "init" :depends-on ("article" "category" "user" "photo" "tag" "view")))
                        :depends-on ("package"))
               (:module "frontend"
                        :components ((:module "src"
                                              :components ((:file "config")
                                                           (:file "init")
                                                           (:module "view"
                                                                    :components ((:file "css")
                                                                                 (:file "helpers")
                                                                                 (:file "template" :depends-on ("css" "helpers"))
                                                                                 (:file "views" :depends-on ("template"))))
                                                           (:file "routes" :depends-on ("view")))))
                        :depends-on ("model"))
               #|(:module
               "boomerang"
               :components ((:file "src")))|#
               #|(:module
               "reports"
               :components ((:file "package")
               (:file "routes" :depends-on ("package"))
               (:file "models" :depends-on ("package"))
               (:file "views" :depends-on ("package"))))|#)
  :depends-on (:restas :cl-who :local-time :cl-memcached :cl-ppcre :parenscript :cl-json :css-lite :restas-directory-publisher :cl-prevalence))
