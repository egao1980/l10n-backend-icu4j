(in-package #:l10n-backend-icu4j)

#+abcl
(progn
  (defmethod backend-make-collator ((backend icu4j-backend) &key locale strength options)
    (declare (ignore backend options))
    (make-instance 'collator
                   :locale locale
                   :strength (or strength :tertiary)
                   :raw (icu:make-collator :locale (%locale-string locale)
                                           :strength (or strength :tertiary))))

  (defmethod backend-collate ((backend icu4j-backend) collator string-a string-b)
    (declare (ignore backend))
    (icu:collate (collator-raw collator) string-a string-b))

  (defmethod backend-sort-key ((backend icu4j-backend) collator string)
    (declare (ignore backend))
    (icu:sort-key (collator-raw collator) string))
)
