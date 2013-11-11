(in-package :hawksbill.utils)

(defun generate-salt (&optional (length 32))
  (get-random-string length :alphabetic t :numeric t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; http://www.cliki.net/ironclad
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro hash (digest)
  `(byte-array-to-hex-string (digest-sequence ,digest
                                              (ascii-string-to-byte-array text))))

(defun md5-hash (text)
  (hash :md5))

(defun sha256-hash (text)
  (hash :sha256))

(defun get-cipher (key)
  (make-cipher :blowfish
               :mode :ecb
               :key (ascii-string-to-byte-array key)))

;; need to name the below 2 functions as do-* because otherwise they shadow ironclad:$1 :(
(defun do-encrypt (plaintext &optional (key (get-config "cipher.secure")))
  (let ((cipher (get-cipher key))
        (msg (ascii-string-to-byte-array plaintext)))
    (encrypt-in-place cipher msg)
    (write-to-string (octets-to-integer msg) :base 36)))

(defun do-decrypt (ciphertext &optional (key (get-config "cipher.secure")))
  (let ((cipher (get-cipher key))
        (msg (integer-to-octets (parse-integer ciphertext :radix 36))))
    (decrypt-in-place cipher msg)
    (coerce (mapcar #'code-char (coerce msg 'list)) 'string)))

(defun insecure-encrypt (plaintext)
  (do-encrypt plaintext (get-config "cipher.insecure")))

(defun insecure-decrypt (ciphertext)
  (do-decrypt ciphertext (get-config "cipher.insecure")))
