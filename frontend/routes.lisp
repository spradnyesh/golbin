(in-package :hawksbill.golbin.frontend)

#|(setf *dispatch-table*
      (nconc
       (mapcar (lambda (args)
                 (apply 'create-folder-dispatcher-and-handler args))
               `(("/static/" ,*static-path*)))))|#
(restas:define-route route-home ("/") (view-home))
(restas:define-route route-cat ("c/:cat/") (view-cat cat))
(restas:define-route route-cat-subcat ("c/:cat/:subcat/") (view-cat-subcat cat subcat))
(restas:define-route route-tag ("t/:tag/") (view-tag tag))
(restas:define-route route-author ("a/:author/") (view-author author))
(restas:define-route route-article (":(slug-and-id).html") (view-article slug-and-id))
(restas:define-route route-search ("search.html") (view-search))
