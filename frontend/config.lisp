(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; dimensional configs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setf *dimensions* '("envt"))
(defvar *valid-envts* '("dev" "prod"))
(setf *config*
      '(("master" ("categories" (("Sports"
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
                                 ("Entenrtainment"
                                  "Arts"
                                  "Books"
                                  "Celebrities"
                                  "Movies"
                                  "Music"
                                  "TV"
                                  "Humor")
                                 ("Lifestyle"
                                  "Automotive"
                                  "Culture"
                                  "Food and Beverage"
                                  "Home and Garden"
                                  "Theatre"
                                  "Travel"
                                  "Health")
                                 ("Technology"
                                  "Computing"
                                  "Internet"
                                  "Personal Technology"
                                  "Video Games")
                                 ("Business"
                                  "Companies"
                                  "Economy"
                                  "Industry"
                                  "Markets")
                                 ("Education")
                                 ("Science"
                                  "Environmenent"
                                  "Geography"
                                  "Space")
                                 ("Headlines")
                                 ("Politics")
                                 ("Religion"))))
        ("envt:dev" ("n1" "v1") ("n2" "v2"))
        ("envt:prod" ("n3" "v3") ("n4" "v4"))))

(defun init ()
  (init-storage)
  (init-config-tree *config*)
  (add-cat/subcat *config-storage* *category-storage*))
