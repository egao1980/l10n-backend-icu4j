(defsystem "l10n-backend-icu4j"
  :version "0.1.0"
  :description "l10n-protocol backend over cl-stack-icu4j (ICU4J / ABCL)"
  :author "egao1980"
  :license "MIT"
  :depends-on ("l10n-protocol" "cl-stack-icu4j")
  :serial t
  :pathname "src"
  :components ((:file "package")
               (:file "util")
               (:file "backend")
               (:file "collate")
               (:file "format")
               (:file "case-locale"))
  :in-order-to ((test-op (test-op "l10n-backend-icu4j/tests")))
  :properties
  (:cl-repo (:provides ("l10n-backend-icu4j"))))

(defsystem "l10n-backend-icu4j/tests"
  :depends-on ("l10n-backend-icu4j" "rove")
  :pathname "tests"
  :serial t
  :components ((:file "package")
               (:file "backend-test"))
  :perform (test-op (o c)
             (unless (symbol-call :rove :run c)
               (error "tests failed for ~A" (component-name c)))))
