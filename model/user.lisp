(in-package :hawksbill.golbin.model)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; classes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defclass user ()
  ((id :initarg :id :initform nil :accessor id)
   (username :initarg :username :initform nil :accessor username)
   (handle :initarg :handle :initform nil :accessor handle) ; name that the user wants others to see
   (password :initarg :password :initform nil :accessor password)
   (name :initarg :name :initform nil :accessor name)
   (status :initarg :status :initform nil :accessor status) ; :d draft, :a active, :b blocked
   (gender :initarg :gender :initform nil :accessor gender)
   (age :initarg :age :initform nil :accessor age)
   (email :initarg :email :initform nil :accessor email)))

(defclass author (user)
  ((address-1 :initarg :address1 :initform nil :accessor address-1)
   (address-2 :initarg :address2 :initform nil :accessor address-2)
   (address-3 :initarg :address3 :initform nil :accessor address-3)
   (city :initarg :city :initform nil :accessor city)
   (state :initarg :state :initform nil :accessor state)
   (country :initarg :country :initform nil :accessor country)
   (zipcode :initarg :zipcode :initform nil :accessor zipcode)
   (location :initarg :location :initform nil :accessor location)
   (contact-1 :initarg :contact1 :initform nil :accessor contact-1)
   (contact-2 :initarg :contact2 :initform nil :accessor contact-2)
   (contact-3 :initarg :contact3 :initform nil :accessor contact-3)
   (bank-name :initarg :bank-name :initform nil :accessor bank-name)
   (bank-account-no :initarg :account :initform nil :accessor bank-account-no)
   (bank-ifsc :initarg :ifsc :initform nil :accessor bank-ifsc)
   (author-type :initarg :author-type :initform nil :accessor author-type)
   (education :initarg :education :initform nil :accessor education)))

(defclass visitor (user)
  ((preference :initarg :preference :initform nil :accessor preference)))

(defclass mini-author (author)
  ((id :initarg :id :initform nil :accessor id)
   (handle :initarg :handle :initform nil :accessor handle)
   (name :initarg :name :initform nil :accessor name))
  (:documentation "to be used as a foreign key in articles"))

(defclass author-storage ()
  ((authors :initform nil :accessor authors)
   (last-id :initform 0 :accessor last-id))
  (:documentation "Object of this class will act as the storage for Authors"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; setters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun add-author (author)
  (let ((storage (get-storage :authors)))
    (setf (id author)
          (execute *db* (make-transaction 'incf-author-last-id)))
    ;; save author into storage
    (execute *db* (make-transaction 'insert-author author))

    ;; TODO: sort authors in storage
    #|(setf (authors storage) (sort (authors storage) #'string< :key #'name))|#

    author))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; getters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-mini-author-details-from-id (id)
  (let ((author (find id (get-all-authors)
                      :key #'id)))
    (values (id author)
            (name author)
            (handle author)
            (status author))))

(defun get-author-by-handle (handle)
  (find handle
        (get-all-authors)
        :key #'handle
        :test #'string-equal))

(defun get-random-author ()
  (let ((all-authors (get-all-authors)))
    (nth (random (length all-authors)) all-authors)))

(defun get-active-authors ()
  (conditionally-accumulate #'(lambda (author)
                                (> (length (get-articles-by-author author)) 1))
                            (get-all-authors)))

(defun get-current-author-id ()
  "TODO: return the id of the currently logged in author"
  (id (get-random-author)))

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
                   "Roger Federer")))
        (dolist (author-name authors)
          (add-author (make-instance 'author
                                     :name author-name
                                     :handle (slugify author-name)
                                     :status :a)))))
