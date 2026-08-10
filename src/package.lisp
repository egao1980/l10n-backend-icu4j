(defpackage #:l10n-backend-icu4j
  (:use #:cl #:l10n-protocol)
  (:local-nicknames (#:icu #:cl-stack-icu4j))
  (:export #:icu4j-backend #:use-icu4j-backend #:*icu4j-backend*))

(in-package #:l10n-backend-icu4j)
