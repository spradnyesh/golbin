(defpackage :golbin-system
  (:use :cl :asdf))

(in-package :golbin-system)

(defsystem golbin
  :components ((:module "utils"
                        :components ((:file "package")
                                     (:file "string" :depends-on ("package"))
                                     (:file "config" :depends-on ("string"))
                                     (:file "init" :depends-on ("config"))
                                     (:file "memcache" :depends-on ("package"))
                                     (:file "html" :depends-on ("package"))
                                     (:file "js" :depends-on ("package"))
                                     (:file "l10n" :depends-on ("package"))
                                     (:file "list" :depends-on ("package"))
                                     (:file "pagination" :depends-on ("package"))
                                     (:file "db" :depends-on ("config"))
                                     (:file "datetime" :depends-on ("package"))
                                     (:file "file" :depends-on ("config"))
                                     (:file "photo" :depends-on ("file" "datetime"))))
               (:module "common"
                        :components ((:file "package")
                                     (:file "config" :depends-on ("package")))
                        :depends-on ("utils"))
               (:module "model"
                        :components ((:file "category")
                                     (:file "tag")
                                     (:file "user")
                                     (:file "article" :depends-on ("user"))
                                     (:file "photo" :depends-on ("user"))
                                     (:file "view")
                                     (:file "init" :depends-on ("article" "category" "user" "photo" "tag" "view")))
                        :depends-on ("common"))
               (:module "frontend"
                        :components ((:module "view"
                                              :components ((:file "css")
                                                           (:file "helpers")
                                                           (:file "template" :depends-on ("css" "helpers"))
                                                           (:file "views" :depends-on ("template"))))
                                     (:file "routes" :depends-on ("view")))
                        :depends-on ("model"))
               (:module "editorial"
                        :components ((:module "view"
                                              :components ((:file "css")
                                                           (:file "helpers")
                                                           (:file "template" :depends-on ("css" "helpers"))
                                                           (:file "views" :depends-on ("template"))))
                                     (:file "routes" :depends-on ("view")))
                        :depends-on ("model"))
               (:module "boomerang")
               (:module "reports"))
  :depends-on (:restas :cl-who :local-time :cl-memcached :cl-ppcre :parenscript :cl-json :css-lite :restas-directory-publisher :cl-prevalence :cl-gd :ironclad))
