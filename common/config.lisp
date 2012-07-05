(in-package :hawksbill.golbin)

(setf *dimensions* '("envt"))
(defvar *valid-envts* '("dev" "prod"))
(setf *current-dimensions-string* "envt:dev") ; TODO: need to set this dynamically for every request (thread safe)
(setf *config*
      `(("master" ("hunchentoot" ("debug" ("errors" nil)
                                          ("backtraces" nil)))
                  ("path" ("uploads" ,(merge-pathnames "uploads/" *home*))
                          ("images" ,(merge-pathnames "static/images/" *home*)))
                  ("photo" ("article-lead" ("center" ("max-width" 600)
                                                     ("max-height" 300))
                                           ("side" ("max-width" 300)
                                                   ("max-height" 300)))
                           ("author" ("article-logo" ("max-width" 50)
                                                     ("max-height" 50))))
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
         ("frontend" ("restas" ("package" :hawksbill.golbin)
                         ("port" 8000)))
         ("editorial" ("restas" ("package" :hawksbill.golbin)
                         ("port" 8080)))
         ("hunchentoot" ("debug" ("errors" t)
                                 ("backtraces" t))))
        ("envt:prod" ("n3" "v3") ("n4" "v4"))))
