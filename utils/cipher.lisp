(in-package :hawksbill.utils)

(defun generate-salt (&optional (length 32))
  (get-random-string length :alphabetic t :numeric t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; http://www.cliki.net/ironclad
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun hash-password (password)
  (byte-array-to-hex-string
   (digest-sequence
    :sha256
    (ascii-string-to-byte-array password))))

(defun get-cipher (key)
  (make-cipher :blowfish
               :mode :ecb
               :key (ascii-string-to-byte-array key)))

;; need to name the below 2 functions as do-* because otherwise they shadow ironclad:$1 :(
(defun do-encrypt (plaintext &optional (key (get-config "cipher.key")))
  (let ((cipher (get-cipher key))
        (msg (ascii-string-to-byte-array plaintext)))
    (encrypt-in-place cipher msg)
    (write-to-string (octets-to-integer msg) :base 36)))

(defun do-decrypt (ciphertext-int &optional (key (get-config "cipher.key")))
  (let ((cipher (get-cipher key))
        (msg (integer-to-octets (parse-integer ciphertext-int :radix 36))))
    (decrypt-in-place cipher msg)
    (coerce (mapcar #'code-char (coerce msg 'list)) 'string)))
