(defpackage :golbin-system
  (:use :cl :asdf))

(in-package :golbin-system)

(defsystem golbin
  :components ((:module "utils"
                        :components ((:file "package")
                                     (:file "threads" :depends-on ("package"))
                                     (:file "list" :depends-on ("package"))
                                     (:file "macros" :depends-on ("package"))
                                     (:file "string" :depends-on ("list"))
                                     (:file "config" :depends-on ("string"))
                                     (:file "init" :depends-on ("config"))
                                     (:file "dimensions" :depends-on ("config"))
                                     (:file "file" :depends-on ("config"))
                                     (:file "photo" :depends-on ("file"))
                                     (:file "lang" :depends-on ("file" "string" "macros"))
                                     (:file "js" :depends-on ("package"))
                                     (:file "restas" :depends-on ("dimensions" "string" "lang"))
                                     (:file "memcache" :depends-on ("package"))
                                     (:file "ckeditor" :depends-on ("package"))
                                     (:file "html" :depends-on ("string"))
                                     (:file "http" :depends-on ("string" "threads"))
                                     (:file "l10n" :depends-on ("package"))
                                     (:file "pagination" :depends-on ("restas"))
                                     (:file "db" :depends-on ("config" "dimensions" "macros"))
                                     (:file "datetime" :depends-on ("lang" "string"))
                                     (:file "cipher" :depends-on ("string"))
                                     (:file "token-card" :depends-on ("package"))
                                     (:file "email" :depends-on ("threads"))
                                     (:file "google-ads" :depends-on ("package"))))
               (:module "common"
                        :components ((:file "package")
                                     (:file "init" :depends-on ("package"))
                                     (:file "config" :depends-on ("init")))
                        :depends-on ("utils"))
               (:module "model"
                        :components ((:file "package")
                                     (:file "category" :depends-on ("package"))
                                     (:file "comments" :depends-on ("package"))
                                     (:file "tag" :depends-on ("package"))
                                     (:file "user" :depends-on ("package"))
                                     (:file "article" :depends-on ("user" "comments"))
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
                                                           (:file "carousel" :depends-on ("template"))
                                                           (:file "comments" :depends-on ("carousel"))
                                                           (:file "article" :depends-on ("carousel" "comments"))
                                                           (:file "index" :depends-on ("carousel"))
                                                           (:file "rss")
                                                           (:file "home" :depends-on ("article" "index"))
                                                           (:file "static" :depends-on ("template")))
                                              :depends-on ("package"))
                                     (:file "routes" :depends-on ("view")))
                        :depends-on ("model"))
               (:module "editorial"
                        :components ((:file "package")
                                     (:module "view"
                                              :components ((:file "css")
                                                           (:file "js")
                                                           (:file "misc")
                                                           (:file "template" :depends-on ("css" "js" "misc"))
                                                           (:file "article" :depends-on ("template"))
                                                           (:file "login" :depends-on ("template"))
                                                           (:file "register" :depends-on ("template"))
                                                           (:file "password" :depends-on ("template"))
                                                           (:file "home" :depends-on ("template"))
                                                           (:file "photo" :depends-on ("template"))
                                                           (:file "accounts" :depends-on ("template"))
                                                           (:file "static" :depends-on ("template")))
                                              :depends-on ("package"))
                                     (:file "routes" :depends-on ("view")))
                        :depends-on ("model" "frontend"))
               (:module "reports"))
  :depends-on (:restas :sexml :local-time :cl-memcached :cl-ppcre :parenscript :cl-json :css-lite :hunchentoot :restas :restas-directory-publisher :cl-prevalence :cl-gd :ironclad :trivial-utf-8 :flexi-streams :cl-smtp :cl-recaptcha :html-entities :trivial-timeout :sanitize :drakma :eager-future2))
