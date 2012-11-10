(in-package :hawksbill.golbin)

(setf *dimensions* '("envt" "lang"))
(setf *valid-envts* '("dev" "prod"))
(setf *valid-langs* '("en-IN" "hi-IN" "mr-IN"))
(setf *config*
      `(("master" ("site" ("name" "Golbin")
                          ("url" "golb.in")
                          ("lang" "en-IN")
                          ("envt" "dev"))
                  ("hunchentoot" ("debug" ("errors" ("catch" nil)
                                                    ("show" nil))
                                          ("backtraces" nil)))
                  ("fe" ("restas" ("package" :hawksbill.golbin.frontend)
                                  ("port" 8000)))
                  ("ed" ("restas" ("package" :hawksbill.golbin.editorial)
                                  ("port" 8080)))
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
                                ("home" ("carousel" ("tabs" 5))))
                  ("parenscript" ("obfuscation" nil)))
        ("envt:dev" ("db" ("type" "prevalence"))
                    ("hunchentoot" ("debug" ("errors" ("catch" t)
                                                      ("show" t))
                                            ("backtraces" t))))
        ("envt:prod" ("parenscript" ("obfuscation" t)))
        ("lang:en-IN" ("categorys" (("Business"
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
                                    ("Headlines")
                                    ("Lifestyle"
                                     "Automotive"
                                     "Culture"
                                     "Food and Beverage"
                                     "Home and Garden"
                                     "Health"
                                     "Theatre"
                                     "Travel")
                                    ("Politics")
                                    ("Religion")
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
        ("lang:mr-IN" ("categorys" (("व्यापार")
                                    ("िशक्षण") ; 'n' is wrong at the end
                                    ("देश-िवदेश")
                                    ("िवज्ान"
                                     "वातावरण")
                                    ("िक्रडा"
                                     "िक्रकेट")
                                    ("मौजमजा"
                                     "कला"
                                     "वाचन"
                                     "नट-नटी"
                                     "िसने-नाट्य"
                                     "संगीत"
                                     "टीवी")
                                    ("लाइफस्टाइल")
                                    ("तेक्नौलोगी"
                                     "कॉम्पुटर"
                                     "इंटरनेट"))))
        ("envt:dev,lang:en-IN" ("db" ("path" ,(merge-pathnames "../data/db/dev/en-IN/" *home*))))
        ("envt:dev,lang:hi-IN" ("db" ("path" ,(merge-pathnames "../data/db/dev/hi-IN/" *home*))))
        ("envt:dev,lang:mr-IN" ("db" ("path" ,(merge-pathnames "../data/db/dev/mr-IN/" *home*))))))
