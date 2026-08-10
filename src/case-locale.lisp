(in-package #:l10n-backend-icu4j)

#+abcl
(progn
  (defmethod backend-locale-downcase ((backend icu4j-backend) string &key locale)
    (declare (ignore backend))
    (icu:locale-downcase string :locale (%locale-string locale)))

  (defmethod backend-locale-upcase ((backend icu4j-backend) string &key locale)
    (declare (ignore backend))
    (icu:locale-upcase string :locale (%locale-string locale)))

  (defmethod backend-locale-titlecase ((backend icu4j-backend) string &key locale)
    (declare (ignore backend))
    (icu:locale-titlecase string :locale (%locale-string locale)))
)
