(in-package :freepress)

(defpclass user ()
  ((username
    :accessor username
    :initarg :username)
   (password
    :accessor password
    :initarg :password)
   (firstname
    :accessor firstname
    :initarg :firstname)
   (lastname
    :accessor lastname
    :initarg :lastname)
   (gender
    :accessor gender
    :initarg :gender)
   (age
    :accessor age
    :initarg :age)
   (email
    :accessor email
    :initarg :email)))
(defpclass author (user)
  ((address-1
    :accessor address-1
    :initarg :address1)
   (address-2
    :accessor address-2
    :initarg :address2)
   (address-3
    :accessor address-3
    :initarg :address3)
   (city
    :accessor city
    :initarg :city)
   (state
    :accessor state
    :initarg :state)
   (country
    :accessor country
    :initarg :country)
   (zipcode
    :accessor zipcode
    :initarg :zipcode)
   (location
    :accessor location
    :initarg :location)
   (contact-1
    :accessor contact-1
    :initarg :contact1)
   (contact-2
    :accessor contact-2
    :initarg :contact2)
   (contact-3
    :accessor contact-3
    :initarg :contact3)
   (bank-name
    :accessor bank-name
    :initarg :bank-name)
   (bank-account-no
    :accessor bank-account-no
    :initarg :account)
   (bank-ifsc
    :accessor bank-ifsc
    :initarg :ifsc)
   (author-type
    :accessor author-type)
   (education
    :accessor education
    :initarg :education)))
(defpclass visitor (user)
  ((preference
    :accessor preference
    :initarg :preference)))
(defpclass category ()
  ((id
    :accessor id
    :initarg :id)
   (name
    :accessor name
    :initarg :name)
   (parent
    :accessor parent
    :initarg :parent)))
(defpclass photo ()
  ((title
    :accessor title
    :initarg :title)
   (orig-filename
    :accessor orig-filename
    :initarg :orig-filename)
   (path
    :accessor path
    :initarg :path)
   (tags
    :accessor tags
    :initarg :tags)
   (author
    :accessor author
    :initarg :author)))
(defpclass article ()
  ((title
    :accessor title
    :initarg :title)
   (slug
    :accessor slug
    :initarg :slug)
   (subtitle
    :accessor subtitle
    :initarg :subtitle)
   (summary
    :accessor summary
    :initarg :summary)
   (createdate
    :accessor createdate
    :initarg :createdate)
   (status
    :accessor status
    :initarg :status)
   (body
    :accessor body
    :initarg :body)
   (author
    :accessor author
    :initarg :author)
   (category
    :accessor category
    :initarg :category)
   (subcategory
    :accessor subcategory
    :initarg :tags)
   (tags
    :accessor tags
    :initarg :tags)
   (location
    :accessor location
    :initarg :location)
   (lead-photo
    :accessor lead-photo
    :initarg :lead-photo)))
