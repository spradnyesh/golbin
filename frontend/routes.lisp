(in-package :hawksbill.golbin.frontend)

(restas:define-route home ("") (home-view))
(restas:define-route cat ("c/:(cat)") (cat-view cat))
(restas:define-route cat-subcat ("c/:(cat)/:(subcat)") (cat-subcat-view cat subcat))
(restas:define-route tag ("t/:(tag)") (tag-view tag))
(restas:define-route author ("a/:(author)") (author-view author))
(restas:define-route article (":(title)-:(id).html") (article-view title id))
