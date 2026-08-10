(in-package #:l10n-backend-icu4j)

(defun %locale-string (locale)
  (cond ((null locale) "en")
        ((stringp locale) locale)
        (t (princ-to-string locale))))
