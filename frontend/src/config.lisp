(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; dimensional configs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setf *dimensions* '("envt"))
(defvar *valid-envts* '("dev" "prod"))
(setf *config*
      '(("master"
         ("basepath" *home*)
         ("static-path" )
         ("uploads-path" )
         ("categories" (("Business"
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
        ("envt:dev" ("n1" "v1") ("n2" "v2"))
        ("envt:prod" ("n3" "v3") ("n4" "v4"))))

(defun init ()
  (init-storage)
  (init-config-tree *config*)
  (add-cat/subcat *config-storage* *category-storage*))
