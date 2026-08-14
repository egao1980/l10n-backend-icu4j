(in-package #:l10n-backend-icu4j)

#+abcl
(progn
  (defmethod backend-format-number ((backend icu4j-backend) value &key locale style skeleton options)
    (declare (ignore backend skeleton options))
    (icu:format-number value :locale (%locale-string locale) :style style))

  (defmethod backend-format-percent ((backend icu4j-backend) value &key locale skeleton options)
    (declare (ignore backend skeleton options))
    (icu:format-percent value :locale (%locale-string locale)))

  (defmethod backend-format-currency ((backend icu4j-backend) value currency &key locale skeleton options)
    (declare (ignore backend skeleton options))
    (icu:format-currency value currency :locale (%locale-string locale)))

  (defmethod backend-format-date ((backend icu4j-backend) value &key locale style skeleton options)
    (declare (ignore backend skeleton options))
    (icu:format-date value :locale (%locale-string locale) :style style))

  (defmethod backend-format-time ((backend icu4j-backend) value &key locale style skeleton options)
    (declare (ignore backend skeleton options))
    ;; Approximate with date formatter SHORT for smoke; full time styles later.
    (icu:format-date value :locale (%locale-string locale) :style (or style :short)))

  (defmethod backend-format-datetime ((backend icu4j-backend) value &key locale date-style time-style
                                      skeleton options)
    (declare (ignore backend time-style skeleton options))
    (icu:format-date value :locale (%locale-string locale) :style (or date-style :short)))

  (defmethod backend-format-relative-time ((backend icu4j-backend) value unit &key locale numeric options)
    (declare (ignore backend options))
    (icu:format-relative-time value unit
                              :locale (%locale-string locale)
                              :numeric (ecase (or numeric :auto)
                                         (:auto nil)
                                         (:always t)
                                         ((t) t)
                                         ((nil) nil))))

  (defmethod backend-format-list ((backend icu4j-backend) items &key locale type width options)
    (declare (ignore backend width options))
    (icu:format-list items :locale (%locale-string locale) :type (or type :and)))

  (defmethod backend-parse-number ((backend icu4j-backend) string &key locale style options)
    (declare (ignore backend options))
    (icu:parse-number string :locale (%locale-string locale) :style style))
)
