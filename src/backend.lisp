(in-package #:l10n-backend-icu4j)

(defclass icu4j-backend (l10n-backend) ()
  (:documentation "l10n-protocol backend over cl-stack-icu4j (ICU4J / ABCL)."))

(defvar *icu4j-backend* nil)

(defmethod backend-capabilities ((backend icu4j-backend))
  #+abcl '(:collate :number :date :currency :list :locale-case)
  #-abcl '())

#-abcl
(eval-when (:compile-toplevel :load-toplevel :execute)
  (warn "l10n-backend-icu4j: designed for ABCL (ICU4J)."))

(defun use-icu4j-backend (&optional (backend (or *icu4j-backend*
                                                 (setf *icu4j-backend*
                                                       (make-instance 'icu4j-backend)))))
  (use-l10n-backend backend)
  backend)

#+abcl
(use-icu4j-backend)
