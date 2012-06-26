(in-package :hawksbill.golbin.frontend)

(defun r-stop ()
  (stop-all))
(defun r-start ()
  (init)
  (tmp-init)
  (start :hawksbill.golbin.frontend :port 8000))
(defun r-restart ()
  (r-stop)
  (r-start))

(defun get-random-tag ()
  (let ((all-tags (get-all-tags)))
    (nth (random (length all-tags)) all-tags)))

(defun get-random-cat-subcat ()
  (let* ((all-categories (get-root-categorys))
         (random-category (nth (random (length all-categories)) all-categories))
         (all-subcategories (get-subcategorys (id random-category))))
    (if all-subcategories
        (values random-category (nth (random (length all-subcategories)) all-subcategories))
        (get-random-cat-subcat))))

(defun add-tags ()
  (let ((tags "1500s 1960s aldus been book centuries containing desktop dummy electronic essentially ever five galley including industry industrys into ipsum leap letraset like lorem make more only pagemaker passages popularised printer printing publishing recently release remaining scrambled sheets simply since software specimen standard survived text took type typesetting unchanged unknown versions when with"))
    (dolist (tag (split-sequence " " tags :test #'string-equal))
      (add-tag (make-instance 'tag :name tag)))))

(defun add-authors ()
  (let ((authors '("Kristen Stewart"
                   "Cameron Diaz"
                   "Penelope Cruz"
                   "Charlize Theron"
                   "Sandra Bullock"
                   "Angelina Jolie"
                   "Floyd Mayweather"
                   "Manny Pacquiao"
                   "Tiger Woods"
                   "LeBron James"
                   "Roger Federer")))
        (dolist (author-name authors)
          (add-author (make-instance 'author
                                     :name author-name
                                     :handle (slugify author-name))))))

(defun add-articles ()
  "add a new articles to the db"
  (dotimes (i 1000)
    (multiple-value-bind (cat subcat) (get-random-cat-subcat)
      (add-article (make-instance 'article
                                  :title (format nil "title  of $ % ^ * the ~Ath article" (1+ i))
                                  :summary (format nil "~A: There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain... --http://lipsum.com/" (1+ i))
                                  :tags (list (get-random-tag) (get-random-tag))
                                  :body (format nil "~A: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.

It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)." (1+ i))
                                  :cat cat
                                  :subcat subcat)))))

(defun tmp-init ()
  (add-authors)
  (add-tags)
  (add-articles))
