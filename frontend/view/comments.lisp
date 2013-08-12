(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-comment-markup (comment)
  (let ((url (userurl comment))
        (email (useremail comment))
        (datetime (universal-to-timestamp (date comment))))
    (<:li :class "comment"
          (translate "user-comment-prelude"
                     (if (nil-or-empty url)
                         (if (nil-or-empty email)
                             (username comment)
                             (<:a :href (concatenate 'string "mailto:" email)
                                  (username comment)))
                         (<:a :href url
                              (username comment)))
                     (prettyprint-date datetime)
                     (prettyprint-time datetime))
          (<:p :class "c-body" (body comment)))))

(defun article-comments-markup (article-id start)
  (<:div :id "comments"
         (<:h3 "Comments")
         (<:form :method "POST"
                 :action (h-genurl 'r-article-comment :id article-id)
                 (<:table
                  (tr-td-input "name")
                  (tr-td-input "email")
                  (tr-td-input "url")
                  (tr-td-text "comment")
                  (tr-td-input "submit" :value (translate "submit") :typeof "submit"))
                 (<:ul (join-loop comment
                                  (paginate (get-article-comments article-id)
                                            start
                                            (get-config "pagination.comments"))
                                  (get-comment-markup comment))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; views
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun v-comment (article-id)
  (let ((name (post-parameter "name"))
        (email (post-parameter "email"))
        (url (post-parameter "url"))
        (body (post-parameter "comment")))
    (add-comment (make-instance 'comment
                                :body body
                                :date (get-universal-time)
                                :status :a
                                :article-id article-id
                                :username name
                                :useremail email
                                :userurl url
                                :userip (remote-addr*)
                                :useragent (user-agent)))
    (redirect (h-genurl 'r-article :slug-and-id (get-slug-and-id (get-article-by-id article-id))))))
