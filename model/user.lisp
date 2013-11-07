(in-package :hawksbill.golbin.model)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; classes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defclass user ()
  ((id :initarg :id :initform nil :accessor id)
   (username :initarg :username :initform nil :accessor username) ; used for logging in (can be the same as handle)
   (alias :initarg :alias :initform nil :accessor alias) ; name that the user wants others to see
   (handle :initarg :handle :initform nil :accessor handle) ; sanitized alias for use in URLs
   (password :initarg :password :initform nil :accessor password) ; encrypted
   (salt :initarg :salt :initform nil :accessor salt) ; for encryption of password
   (name :initarg :name :initform nil :accessor name)
   (status :initarg :status :initform nil :accessor status) ; :d draft, :a active, :b blocked
   (email :initarg :email :initform nil :accessor email)))

(defclass author (user)
  ((author-type :initarg :author-type :initform nil :accessor author-type) ; :u author, :e editor, :d admin
   (street :initarg :street :initform nil :accessor street)
   (city :initarg :city :initform nil :accessor city)
   (state :initarg :state :initform nil :accessor state)
   (country :initarg :country :initform nil :accessor country)
   (zipcode :initarg :zipcode :initform nil :accessor zipcode)
   (bank-name :initarg :bank-name :initform nil :accessor bank-name)
   (bank-branch :initarg :bank-branch :initform nil :accessor bank-branch)
   (bank-account-no :initarg :bank-account-no :initform nil :accessor bank-account-no)
   (bank-ifsc :initarg :bank-ifsc :initform nil :accessor bank-ifsc)
   (paypal-userid :initarg :paypal-userid :initform nil :accessor paypal-userid)))

(defclass visitor (user)
  ((preference :initarg :preference :initform nil :accessor preference)))

(defclass mini-author ()
  ((id :initarg :id :initform nil :accessor id)
   (handle :initarg :handle :initform nil :accessor handle)
   (alias :initarg :alias :initform nil :accessor alias))
  (:documentation "to be used as a foreign key in articles"))

(defclass author-storage ()
  ((authors :initform nil :accessor authors)
   (last-id :initform 0 :accessor last-id))
  (:documentation "Object of this class will act as the storage for Authors"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-mini-author ()
  (multiple-value-bind (author-id author-alias author-handle)
      (get-mini-author-details-from-id (get-current-author-id))
    (make-instance 'mini-author
                   :id author-id
                   :alias author-alias
                   :handle author-handle)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun verify-login (username password)
  (let ((author (get-author-by-username username)))
    (when (and author
               (string-equal (hash-password password)
                             (password author)))
      author)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; setters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun add-author (author)
  (setf (id author)
        (execute (get-db-handle) (make-transaction 'incf-author-last-id)))

  ;; save author into storage
  (execute (get-db-handle) (make-transaction 'insert-author author))

  ;; TODO: sort authors in storage
  #- (and)
  (setf (authors storage) (sort (authors storage) #'string< :key #'name))

  author)

(defun edit-author (author)
  ;; save author into storage
  (execute (get-db-handle) (make-transaction 'update-author author))
  author)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; getters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-mini-author-details-from-id (id)
  (let ((author (find id (get-all-authors)
                      :key #'id)))
    (values (id author)
            (alias author)
            (handle author))))

(defun get-author-by-handle (handle)
  (find handle
        (get-all-authors)
        :key #'handle
        :test #'string-equal))

(defun get-author-by-username (username)
  (find username
        (get-all-authors)
        :key #'username
        :test #'string-equal))

(defun get-author-by-email (email)
  (find email
        (get-all-authors)
        :key #'email
        :test #'string-equal))

(defun get-random-author ()
  (let ((all-authors (get-all-authors)))
    (nth (random (length all-authors)) all-authors)))

(defun get-current-author-id ()
  (id (get-author-by-handle (session-value :author))))

(defun find-author-by-email-salt (email salt)
  (find (make-instance 'author
                       :email email
                       :salt salt)
        (get-all-authors)
        :test #'(lambda (a b)
                  (and (string-equal (email a) (email b))
                       (string-equal (salt a) (salt b))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; needed for tmp-init
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
                   "Roger Federer"
                   "Rupert Sanders"
                   "Madonna"
                   "Sarah Jessica Parker"
                   "Anjelina Jolie"
                   "Jennifer Aniston"
                   "Courtey Cox"
                   "Tom Cruise"
                   "Emma Wason"
                   "Megan Fox")))
    (dolist (author-name authors)
      (let ((slug (slugify author-name)))
        (add-author (make-instance 'author
                                   :name author-name
                                   :alias author-name
                                   :username slug
                                   :handle slug
                                   :password slug
                                   :salt (generate-salt 32)
                                   :status :a))))))
