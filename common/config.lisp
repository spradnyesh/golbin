(in-package :hawksbill.golbin)

(setf *dimensions* '("envt"))
(defvar *valid-envts* '("dev" "prod"))
(setf *current-dimensions-string* "envt:dev") ; TODO: need to set this dynamically for every request (thread safe)
(setf *config*
      `(("master" ("hunchentoot" ("debug" ("errors" nil)
                                          ("backtraces" nil)))
                  ("path" ("uploads" ,(merge-pathnames "../data/uploads/" *home*))
                          ("photos" ,(merge-pathnames "../data/static/photos/" *home*)))
                  ("photo" ("article-lead" ("left" ("max-width" 300)
                                                   ("max-height" 300))
                                           ("right" ("max-width" 300)
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
                  ("pagination" ("article" ("limit" 10)
                                           ("related" 4)
                                           ("editorial" ("lead-photo-select-pane" 16))))
                  ("parenscript" ("obfuscation" nil))
                  ("categorys" (("Business"
                                 "Companies"
                                 "Economy"
                                 "Industry"
                                 "Markets")
                                ("Education")
                                ("Entenrtainment"
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
                                 "Environmenent"
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
        ("envt:dev"
         ("db" ("type" "prevalence")
               ("path" ,(merge-pathnames "../data/db/dev/" *home*)))
         ("fe" ("restas" ("package" :hawksbill.golbin.frontend)
                         ("port" 8000)))
         ("ed" ("restas" ("package" :hawksbill.golbin.editorial)
                         ("port" 8080)))
         ("hunchentoot" ("debug" ("errors" t)
                                 ("backtraces" t))))
        ("envt:prod" ("parenscript" ("obfuscation" t)))))
