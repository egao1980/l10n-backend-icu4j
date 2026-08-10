(defpackage #:l10n-backend-icu4j/tests
  (:use #:cl #:rove #:l10n-protocol #:l10n-backend-icu4j))

(in-package #:l10n-backend-icu4j/tests)

#+abcl
(deftest smoke
  (use-icu4j-backend)
  (ok (typep *l10n-backend* 'icu4j-backend))
  (ok (minusp (collate "a" "b" :locale "en")))
  (ok (plusp (length (format-number 1234.5d0 :locale "en-US"))))
  (ok (plusp (length (format-currency 10 "USD" :locale "en-US"))))
  (ok (string= "İ" (locale-upcase "i" :locale "tr"))))

#-abcl
(deftest skip (ok t))
