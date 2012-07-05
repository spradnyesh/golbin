(in-package :hawksbill.golbin)

(setf *config*
      `(("master" ("restas" ("package" :hawksbill.golbin)
                            ("port" 8000))
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
               ("path" ,(format nil "/~a"
                                (join-string-list-with-delim
                                 "/"
                                 (rest (append (pathname-directory *home*)
                                               '("model/data/dev/"))))))))
        ("envt:prod" ("n3" "v3") ("n4" "v4"))))
