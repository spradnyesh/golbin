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
               (:module "model" ; so that it can be shared b/n frontend, editorial, boomerang
                        :components ((:file "package")
                                     (:file "article" :depends-on ("package"))
                                     (:file "category" :depends-on ("package"))
                                     (:file "user" :depends-on ("package"))
                                     (:file "photo" :depends-on ("package"))
                                     (:file "tag" :depends-on ("package"))
                                     (:file "view" :depends-on ("package"))
                                     (:file "init" :depends-on ("article" "category" "user" "photo" "tag")))
                        :depends-on ("utils"))
               (:module "frontend"
                        :components ((:module "src"
                                              :components ((:file "package")
                                                           (:file "storage" :depends-on ("package"))
                                                           (:file "config" :depends-on ("storage"))
                                                           (:file "init" :depends-on ("storage"))
                                                           (:module "view"
                                                                    :components ((:file "css")
                                                                                 (:file "helpers")
                                                                                 (:file "template" :depends-on ("css" "helpers"))
                                                                                 (:file "views" :depends-on ("template"))))
                                                           (:file "routes" :depends-on ("view")))))
                        :depends-on ("utils" "model"))
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
