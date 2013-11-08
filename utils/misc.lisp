(in-package :hawksbill.utils)

(defmacro build-gravtar-image (email alt)
  `(<:img :alt ,alt
          :src (concatenate 'string
                            (get-config "gravatar.url")
                            (byte-array-to-hex-string
                             (digest-sequence :md5
                                              (ascii-string-to-byte-array ,email)))
                            "?s="
                            (get-config "gravatar.size.comments")
                            "&d="
                            (get-config "gravatar.type"))))
