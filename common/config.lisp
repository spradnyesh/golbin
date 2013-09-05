(in-package :hawksbill.golbin)

(setf *dimensions* '("envt" "lang"))
(setf *valid-envts* '("dev" "prod"))
(setf *valid-langs* '("en-IN" "hi-IN" "mr-IN"))
(setf *config*
      `(("master" ("site" ("name" "Golbin")
                          ("url" "golb.in")
                          ("lang" "en-IN")
                          ("envt" "prod")
                          ("email" ("address" "golb_in@yahoo.com")
                                   ("host" "smtp.mail.yahoo.com")
                                   ("password" "")))
                  ("cipher" ("insecure" "aCpLvFWfcfUxmz4h") ; used for non-secure encryption
                            ("secure" "")
                            ("fe" ("comments" ("public" "6LekB-YSAAAAAC55se2xnWzfaPKvvN0cm8b46mgi")
                                              ("private" ""))))
                  ("db" ("type" "prevalence"))
                  ("hunchentoot" ("timeout" 3)
                                 ("debug" ("errors" ("catch" t)
                                                    ("show" nil))
                                          ("backtraces" nil)))
                  ("fe" ("restas" ("package" :hawksbill.golbin.frontend)
                                  ("port" 8000)))
                  ("ed" ("restas" ("package" :hawksbill.golbin.editorial)
                                  ("port" 8888)))
                  ("path" ("uploads" ,(merge-pathnames "../data/uploads/" *home*))
                          ("photos" ,(merge-pathnames "../data/static/photos/" *home*))
                          ("locale" ,(merge-pathnames "locale/" *home*)))
                  ("photo" ("article-lead" ("side" ("max-width" 300)
                                                   ("max-height" 300))
                                           ("block" ("max-width" 600)
                                                    ("max-height" 300))
                                           ("index-thumb" ("max-width" 65)
                                                          ("max-height" 65))
                                           ("related-thumb" ("max-width" 100)
                                                            ("max-height" 100)))
                           ("author" ("avatar" ("max-width" 100)
                                               ("max-height" 100))
                                     ("article-logo" ("max-width" 50)
                                                     ("max-height" 50))))
                  ("pagination" ("article" ("limit" 10) ; number of articles per (index) page
                                           ("range" 10) ; number of entries in pagination markup
                                           ("related" 4)
                                           ("editorial" ("lead-photo-select-pane" 16)))
                                ("comments" 20)
                                ("home" ("carousel" ("tabs" 10))))
                  ("parenscript" ("obfuscation" t))
                  ("timestamp" ("password-link-validity" 86400)))
        ("envt:dev" ("hunchentoot" ("debug" ("errors" ("catch" nil)
                                                      ("show" t))
                                            ("backtraces" t)))
                    ("parenscript" ("obfuscation" nil))
                    ("timestamp" ("password-link-validity" 60)))
        ("envt:dev,lang:en-IN" ("db" ("path" ,(merge-pathnames "../data/db/dev/en-IN/" *home*))))
        ("envt:dev,lang:hi-IN" ("db" ("path" ,(merge-pathnames "../data/db/dev/hi-IN/" *home*))))
        ("envt:dev,lang:mr-IN" ("db" ("path" ,(merge-pathnames "../data/db/dev/mr-IN/" *home*))))
        ("envt:prod,lang:en-IN" ("db" ("path" ,(merge-pathnames "../data/db/prod/en-IN/" *home*))))
        ("envt:prod,lang:hi-IN" ("db" ("path" ,(merge-pathnames "../data/db/prod/hi-IN/" *home*))))
        ("envt:prod,lang:mr-IN" ("db" ("path" ,(merge-pathnames "../data/db/prod/mr-IN/" *home*))))

        ;; Categories (not needed in config; given here just for reference)
        #-(and)
        (progn
          ("lang:en-IN" ("categorys" (("Editorial"
                                       "Politics"
                                       "Religion")
                                      ("Business"
                                       "Companies"
                                       "Economy"
                                       "Industry"
                                       "Markets")
                                      ("Education")
                                      ("Entertainment"
                                       "Arts"
                                       "Books"
                                       "Celebrities"
                                       "Humor"
                                       "Movies"
                                       "Music"
                                       "TV")
                                      ("Lifestyle"
                                       "Automotive"
                                       "Culture"
                                       "Food and Beverage"
                                       "Home and Garden"
                                       "Health"
                                       "Theatre"
                                       "Travel")
                                      ("Science"
                                       "Environment"
                                       "Geography"
                                       "Space")
                                      ("Sports"
                                       "American Football"
                                       "Badminton"
                                       "Baseball"
                                       "Basketball"
                                       "Boxing"
                                       "Cricket"
                                       "Cycling"
                                       "Hockey"
                                       "Golf"
                                       "Handball"
                                       "Olympics"
                                       "Racing"
                                       "Rugby"
                                       "Table Tennis"
                                       "Tennis")
                                      ("Technology"
                                       "Computing"
                                       "Internet"
                                       "Personal Technology"
                                       "Video Games"))))
          ("lang:mr-IN" ("categorys" (("लेख"
                                       "अग्रलेख"
                                       "कविता")
                                      ("व्यापार")
                                      ("शिक्षण")
                                      ("देश-विदेश")
                                      ("विज्ञान"
                                       "वातावरण")
                                      ("क्रीडा"
                                       "क्रिकेट")
                                      ("मौजमजा"
                                       "कला"
                                       "वाचन"
                                       "नट-नटी"
                                       "िसने-नाट्य"
                                       "संगीत"
                                       "टीवी")
                                      ("लाइफस्टाइल")
                                      ("टेक्नोलॉजी"
                                       "कॉम्प्युटर"
                                       "इंटरनेट")))))))
