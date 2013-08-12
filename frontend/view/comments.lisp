(in-package :hawksbill.golbin.frontend)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun do-child-comments (parent-id children)
  (<:ul :class "comment"
       (let ((i 0)
             (str-i nil))
         (join-loop child children
                    (progn
                      (setf str-i (write-to-string i))
                      (get-comment-markup child
                                          (if (string= "-1" parent-id)
                                              str-i
                                              (join-string-list-with-delim "." (list parent-id str-i))))
                      (incf i))))))

(defun get-comment-markup (comment parent-id)
  (<:li (<:p :class "c-name-says"
           (<:span :class "c-name" (username comment))
           (<:span :class "c-says" " says:")) ; XXX: translate
       (<:p :class "c-date-at" (date comment))
       (let ((url (userurl comment)))
         (when url
           (<:p :class "c-url" url)))
       (<:p :class "c-body" (body comment))
       (<:p :class "c-reply" (<:a :id parent-id :href "" "Reply")) ; XXX: translate
       (let ((children (children comment)))
         (when children
           (do-child-comments parent-id children)))))

(defun article-comments-markup (article-id)
  (<:form :id "comments"
         :method "POST"
         :action (h-genurl 'r-article-comment :id article-id)
         (<:input :class "td-input parent"
                 :type "hidden"
                 :name "parent")
         (<:p :class "c-reply"
              (<:a :id "-1" :href "" (translate "add-a-comment"))
              (<:table :id "c-table"
                       (tr-td-input "name")
                       (tr-td-input "email")
                       (tr-td-input "url")
                       (tr-td-text "comment")
                       (tr-td-input "submit" :value (translate "submit") :typeof "submit")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; view functions
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
