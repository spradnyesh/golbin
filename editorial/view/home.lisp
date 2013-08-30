(in-package :hawksbill.golbin.editorial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; views
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-home ()
  (with-ed-login
    (template
     :title "Home"
     :js nil
     :body (let ((author (who-am-i)))
             (if (eq (status author) :a)
                 (let* ((articles-list (get-all-articles-by-author author))
                        (page (get-parameter "page"))
                        (page (if page (parse-integer page) 0))
                        (num-per-page (get-config "pagination.article.limit"))
                        (num-pages (get-config "pagination.article.range"))
                        (offset (* page num-per-page)))
                   (<:div :id "articles"
                          :class "wrapper"
                          (<:ul
                           (join-loop article
                                      (paginate articles-list
                                                offset
                                                num-per-page)
                                      (let* ((id (id article))
                                             (status (status article))
                                             (delete (if (can-article-be-deleted?)
                                                         "d"
                                                         "u")))
                                        (<:li :class (cond ((eq :r (status article)) "draft")
                                                           ((eq :s (status article)) "submitted")
                                                           (t ""))
                                              (<:div :class "crud"
                                                     (<:p (<:a :href (h-genurl 'r-article-edit-get :id id) "Edit"))
                                                     (<:form :method "POST"
                                                             :action (h-genurl 'r-article-delete-post :id id)
                                                             (<:input :name "page"
                                                                      :type "hidden"
                                                                      :value page)
                                                             (<:input :name "delete"
                                                                      :type "hidden"
                                                                      :value delete)
                                                             (<:input :class "delete"
                                                                      :type "submit"
                                                                      :value (if (eq :e (status article))
                                                                                 (translate "undelete")
                                                                                 (translate "delete")))))
                                              (when (photo article)
                                                (<:div :class "index-thumb"
                                                       (article-lead-photo-url (photo article) "index-thumb")))
                                              (<:h3 :class (format nil
                                                                   "a-title ~a"
                                                                   (if (eq :e (status article))
                                                                       "deleted"
                                                                       ""))
                                                    (<:a :href (h-genurl 'r-article
                                                                         :slug-and-id (get-slug-and-id article))
                                                         (title article)))
                                              (<:p :class "a-summary" (summary article))))))
                          (pagination-markup page
                                             (length articles-list)
                                             num-per-page
                                             num-pages
                                             'r-home)))
                 (<:p :class "wrapper"
                      (translate "wait-till-approval")))))))
