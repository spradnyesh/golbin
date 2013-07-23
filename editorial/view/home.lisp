(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; views
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-home ()
  (with-ed-login
    (template
     :title "Home"
     :logged-in t
     :js nil
     :body (let* ((author (get-author-by-handle (session-value :author)))
                  (articles-list (get-all-articles-by-author author))
                  (page (get-parameter "page"))
                  (page (if page (parse-integer page) 0))
                  (num-per-page (get-config "pagination.article.limit"))
                  (num-pages (get-config "pagination.article.range"))
                  (offset (* page num-per-page)))
             (<:div :id "articles"
                    (<:ul
                     (join-loop article
                                (paginate articles-list
                                          offset
                                          num-per-page)
                                (let* ((id (id article))
                                       (status (status article))
                                       (delete (if (can-article-be-deleted?)
                                                   "Delete"
                                                   "Undelete")))
                                  (<:li (<:div :class "crud"
                                               (<:p (<:a :href (h-genurl 'r-article-edit-get :id id) "Edit"))
                                               (when (can-article-be-deleted?)
                                                 (<:form :method "POST"
                                                         :action (h-genurl 'r-article-delete-post :id id)
                                                         (<:input :name "page"
                                                                  :type "hidden"
                                                                  :value page)
                                                         (<:input :class "delete"
                                                                  :name "delete"
                                                                  :type "submit"
                                                                  :value delete))))
                                        (when (photo article)
                                          (<:div :class "index-thumb"
                                                 (article-lead-photo-url (photo article) "index-thumb")))
                                        (<:h3 :class (format nil
                                                             "a-title ~a"
                                                             (if (string-equal delete "Undelete")
                                                                 "deleted"
                                                                 ""))
                                              (<:a :href (h-genurl 'r-article
                                                                   :slug-and-id (format nil
                                                                                        "~a-~a"
                                                                                        (slug article)
                                                                                        id))
                                                   (title article)))
                                        (<:p :class "a-summary" (summary article))))))
                    (pagination-markup page
                                       (length articles-list)
                                       num-per-page
                                       num-pages
                                       'r-home))))))
