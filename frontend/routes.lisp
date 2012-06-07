(in-package :hawksbill.golbin.frontend)

(restas:define-route route-home ("") (view-home))
(restas:define-route route-cat ("c/:cat") (view-cat cat))
(restas:define-route route-cat-subcat ("c/:cat/:subcat") (view-cat-subcat cat subcat))
(restas:define-route route-tag ("t/:tag") (view-tag tag))
(restas:define-route route-author ("a/:author") (view-author author))
(restas:define-route route-article (":(title-and-id).html") (view-article title-and-id))
