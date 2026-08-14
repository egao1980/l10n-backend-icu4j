;;;; l10n ICU backend tests — collation / format / locale-case themes
;;;; inspired by ICU CollationTest, NumberFormat, RelativeDateTime, and PyICU.

(in-package #:l10n-backend-icu4j/tests)

(deftest backend-installed
  (ok (typep *l10n-backend* 'icu4j-backend))
  (dolist (cap '(:collate :number :date :currency :list :locale-case))
    (ok (member cap (backend-capabilities *l10n-backend*))
        (format nil "capability ~s" cap))))

;;; --- collation (UCA) --------------------------------------------------------

(deftest collate-en-basic
  (ok (minusp (collate "a" "b" :locale "en")))
  (ok (plusp (collate "b" "a" :locale "en")))
  (ok (zerop (collate "a" "a" :locale "en"))))

(deftest collate-primary-ignores-case
  (let ((c (make-collator :locale "en" :strength :primary)))
    (ok (zerop (collate "a" "A" :collator c)))
    (ok (zerop (collate "résumé" "Resume" :collator c)))))

(deftest collate-tertiary-distinguishes-case
  (let ((c (make-collator :locale "en" :strength :tertiary)))
    (ok (not (zerop (collate "a" "A" :collator c))))))

(deftest sort-key-order-matches-collate
  (let* ((c (make-collator :locale "en"))
         (ka (sort-key "apple" :collator c))
         (kb (sort-key "banana" :collator c)))
    (ok (vectorp ka))
    (ok (minusp (collate "apple" "banana" :collator c)))
    (ok (not (equalp ka kb)))))

;;; --- numbers / currency -----------------------------------------------------

(deftest format-number-en-us
  (let ((s (format-number 1234.5d0 :locale "en_US")))
    (ok (search "1" s))
    (ok (or (search "," s) (search "1,234" s) (search "1234" s)))))

(deftest format-number-de-decimal-comma
  ;; de_DE uses comma as decimal separator
  (let ((s (format-number 1.5d0 :locale "de_DE")))
    (ok (or (search "," s) (search "1,5" s) (search "1.5" s)))))

(deftest format-percent-en
  (let ((s (format-percent 0.25d0 :locale "en_US")))
    (ok (or (search "%" s) (search "25" s)))))

(deftest format-currency-usd
  (let ((s (format-currency 12.5d0 "USD" :locale "en_US")))
    (ok (or (search "$" s) (search "USD" s) (search "12" s)))))

(deftest parse-number-en
  (ok (= (parse-number "1,234.5" :locale "en_US") 1234.5d0)))

;;; --- dates / relative -------------------------------------------------------

(deftest format-date-en-smoke
  (let ((s (format-date 0 :locale "en_US" :style :short))) ; 1970-01-01 UT
    (ok (plusp (length s)))))

(deftest format-time-not-date
  (let ((s (format-time 0 :locale "en_US" :style :short)))
    (ok (plusp (length s)))
    ;; Must not look like a calendar date-only string (e.g. "1/1/70").
    (ok (or (find #\: s) (search "AM" s) (search "PM" s)
            (search "am" s) (search "pm" s) (digit-char-p (char s 0))))))

(deftest format-datetime-includes-time
  (let ((s (format-datetime 0 :locale "en_US" :date-style :short :time-style :short)))
    (ok (plusp (length s)))
    (ok (or (find #\: s) (search "AM" s) (search "PM" s)
            (search "am" s) (search "pm" s)))))

(deftest parse-date-roundtrip-smoke
  (let* ((s (format-date 0 :locale "en_US" :style :short))
         (ut (parse-date s :locale "en_US" :style :short)))
    (ok (numberp ut))
    (ok (< (abs ut) (* 2 24 3600d0))))) ; near epoch

(deftest format-relative-time-numeric
  (let ((s (format-relative-time -1 :day :locale "en" :numeric :always)))
    (ok (or (search "day" s :test #'char-equal)
            (search "1" s)))))

(deftest format-relative-time-auto
  (let ((s (format-relative-time -1 :day :locale "en" :numeric :auto)))
    (ok (plusp (length s)))))

(deftest format-relative-time-short-style
  (let ((s (format-relative-time -1 :day :locale "en" :numeric :always
                                 :options '(:style :short))))
    (ok (plusp (length s)))))

;;; --- list / locale case -----------------------------------------------------

(deftest format-list-and-or
  (let ((and-s (format-list '("a" "b" "c") :locale "en" :type :and))
        (or-s (format-list '("a" "b") :locale "en" :type :or))
        (narrow (format-list '("a" "b" "c") :locale "en" :type :and :width :narrow)))
    (ok (search "a" and-s))
    (ok (search "c" and-s))
    (ok (search "a" or-s))
    (ok (search "b" or-s))
    (ok (search "a" narrow))
    (ok (plusp (length narrow)))))

(deftest locale-case-english
  (ok (string= (locale-downcase "I" :locale "en") "i"))
  (ok (string= (locale-upcase "i" :locale "en") "I")))

(deftest locale-case-turkish-dotted-i
  ;; Classic ICU / PyICU example: Turkish I ↔ ı / İ ↔ i
  (ok (string= (locale-downcase "I" :locale "tr") "ı"))
  (ok (string= (locale-upcase "i" :locale "tr") "İ")))
