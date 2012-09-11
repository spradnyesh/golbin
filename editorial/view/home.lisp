(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; views
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-home ()
  (with-ed-login
    (ed-page-template "Home"
        t
        nil
      (let* ((author (get-author-by-handle (session-value :user)))
             (articles-list (get-all-articles-by-author author))
             (page (get-parameter "page"))
             (page (if page (parse-integer page) 0))
             (num-per-page (get-config "pagination.article.limit"))
             (num-pages (get-config "pagination.article.range"))
             (offset (* page num-per-page)))
        (htm (:div :id "articles"
                   (:ul
                    (dolist (article (paginate articles-list
                                               offset
                                               num-per-page))
                      (let* ((id (id article))
                             (status (status article))
                             (delete (if (can-article-be-deleted?)
                                         "Delete"
                                         "Undelete")))
                        (htm (:li (:div :class "crud"
                                        (:p (:a :href (genurl 'r-article-edit-get :id id) "Edit"))
                                        (when (can-article-be-deleted?)
                                          (htm (:form :method "POST"
                                                      :action (genurl 'r-article-delete-post :id id)
                                                      (:input :name "page"
                                                              :type "hidden"
                                                              :value page)
                                                      (:input :id "delete"
                                                              :name "delete"
                                                              :type "submit"
                                                              :value delete)))))
                                  (when (photo article)
                                    (htm (:div :class "index-thumb"
                                               (str (article-lead-photo-url (photo article) "index-thumb")))))
                                  (:h3 :class (format nil
                                                      "a-title ~a"
                                                      (if (string-equal delete "Undelete")
                                                          "deleted"
                                                          ""))
                                       (:a :href (genurl 'r-article
                                                         :slug-and-id (format nil
                                                                              "~a-~a"
                                                                              (slug article)
                                                                              id))
                                           (str (title article))))
                                  (:p :class "a-summary" (str (summary article)))))))))
             (str (pagination-markup page
                                     (length articles-list)
                                     num-per-page
                                     num-pages
                                     'r-home)))))))
