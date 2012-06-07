(in-package :hawksbill.golbin.frontend)

(define-route route-home ("") (view-home "0"))
(define-route route-home-page (":page") (view-home page))
#|(define-route route-cat ("c/:cat") (view-cat cat))|#
#|(define-route route-cat-subcat ("c/:cat/:subcat") (view-cat-subcat cat subcat))|#
#|(define-route route-tag ("t/:tag") (view-tag tag))|#
#|(define-route route-author ("a/:author") (view-author author))|#
(define-route route-article (":(title-and-id).html") (view-article title-and-id))
