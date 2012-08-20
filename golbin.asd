(defpackage :golbin-system
  (:use :cl :asdf))

(in-package :golbin-system)

(defsystem golbin
  :components ((:module "utils"
                        :components ((:file "package")
                                     (:file "string" :depends-on ("package"))
                                     (:file "config" :depends-on ("string"))
                                     (:file "init" :depends-on ("config"))
                                     (:file "restas" :depends-on ("config"))
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
                                     (:file "init" :depends-on ("package"))
                                     (:file "config" :depends-on ("init")))
                        :depends-on ("utils"))
               (:module "model"
                        :components ((:file "package")
                                     (:file "category" :depends-on ("package"))
                                     (:file "tag" :depends-on ("package"))
                                     (:file "user" :depends-on ("package"))
                                     (:file "article" :depends-on ("user"))
                                     (:file "photo" :depends-on ("user"))
                                     (:file "init" :depends-on ("article" "category" "user" "photo" "tag")))
                        :depends-on ("common"))
               (:module "frontend"
                        :components ((:file "package")
                                     (:module "view"
                                              :components ((:file "css")
                                                           (:file "js")
                                                           (:file "helpers")
                                                           (:file "template" :depends-on ("css" "js" "helpers"))
                                                           (:file "common" :depends-on ("template"))
                                                           (:file "article" :depends-on ("common"))
                                                           (:file "home" :depends-on ("common"))
                                                           (:file "index" :depends-on ("common")))
                                              :depends-on ("package"))
                                     (:file "routes" :depends-on ("view")))
                        :depends-on ("model"))
               (:module "editorial"
                        :components ((:file "package")
                                     (:module "view"
                                              :components ((:file "css")
                                                           (:file "js")
                                                           (:file "helpers")
                                                           (:file "template" :depends-on ("css" "js" "helpers"))
                                                           (:file "author" :depends-on ("template"))
                                                           (:file "article" :depends-on ("template"))
                                                           (:file "login" :depends-on ("template"))
                                                           (:file "home" :depends-on ("template"))
                                                           (:file "photo" :depends-on ("author")))
                                              :depends-on ("package"))
                                     (:file "routes" :depends-on ("view")))
                        :depends-on ("model"))
               (:module "boomerang")
               (:module "reports"))
  :depends-on (:restas :cl-who :local-time :cl-memcached :cl-ppcre :parenscript :cl-json :css-lite :restas-directory-publisher :cl-prevalence :cl-gd :ironclad))
