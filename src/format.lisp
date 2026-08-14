(in-package #:l10n-backend-icu4j)

#+abcl
(progn
  (defmethod backend-format-number ((backend icu4j-backend) value &key locale style skeleton options)
    (declare (ignore backend options))
    (icu:format-number value :locale (%locale-string locale) :style style :skeleton skeleton))

  (defmethod backend-format-percent ((backend icu4j-backend) value &key locale skeleton options)
    (declare (ignore backend options))
    (icu:format-percent value :locale (%locale-string locale) :skeleton skeleton))

  (defmethod backend-format-currency ((backend icu4j-backend) value currency &key locale skeleton options)
    (declare (ignore backend options))
    (icu:format-currency value currency :locale (%locale-string locale) :skeleton skeleton))

  (defmethod backend-format-date ((backend icu4j-backend) value &key locale style skeleton options)
    (declare (ignore backend options))
    (icu:format-date value :locale (%locale-string locale) :style style :skeleton skeleton))

  (defmethod backend-format-time ((backend icu4j-backend) value &key locale style skeleton options)
    (declare (ignore backend options))
    (icu:format-time value :locale (%locale-string locale) :style (or style :short) :skeleton skeleton))

  (defmethod backend-format-datetime ((backend icu4j-backend) value &key locale date-style time-style
                                      skeleton options)
    (declare (ignore backend options))
    (icu:format-datetime value
                         :locale (%locale-string locale)
                         :date-style (or date-style :short)
                         :time-style (or time-style :short)
                         :skeleton skeleton))

  (defmethod backend-format-relative-time ((backend icu4j-backend) value unit &key locale numeric options)
    (declare (ignore backend))
    (icu:format-relative-time value unit
                              :locale (%locale-string locale)
                              :numeric (ecase (or numeric :auto)
                                         (:auto nil)
                                         (:always t)
                                         ((t) t)
                                         ((nil) nil))
                              :style (getf options :style :long)))

  (defmethod backend-format-list ((backend icu4j-backend) items &key locale type width options)
    (declare (ignore backend options))
    (icu:format-list items
                     :locale (%locale-string locale)
                     :type (or type :and)
                     :width (or width :wide)))

  (defmethod backend-parse-number ((backend icu4j-backend) string &key locale style options)
    (declare (ignore backend options))
    (icu:parse-number string :locale (%locale-string locale) :style style))

  (defmethod backend-parse-date ((backend icu4j-backend) string &key locale style skeleton options)
    (declare (ignore backend skeleton options))
    (icu:parse-date string :locale (%locale-string locale) :style style))
)
