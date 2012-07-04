(in-package :hawksbill.golbin.frontend)

(setf *dimensions* '("envt"))
(defvar *valid-envts* '("dev" "prod"))
(setf *config*
      `(("master"
         ("restas" ("package" :hawksbill.golbin.frontend)
                   ("port" 8000))
         ("author" ("article-logo" ("width" 120)
                                   ("height" 30)))
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
                                 (rest (append (butlast (pathname-directory *home*))
                                               '("model/data/dev/"))))))))
        ("envt:prod" ("n3" "v3") ("n4" "v4"))))
