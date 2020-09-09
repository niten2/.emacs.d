;; -*- no-byte-compile: t; -*-

(package! js2-mode :pin "fe53814dc2")
(package! rjsx-mode :pin "014c760138")
(package! typescript-mode :pin "a0f2c3ebd4")

;; Tools
;; (package! eslintd-fix :pin "98c669e365")
(package! eslint-fix)
(package! js2-refactor :pin "d4c40b5fc8")
(package! npm-mode :pin "3ee7c0bad5")

;; Eval
(package! nodejs-repl)
;; (package! skewer-mode :pin "123215dd9b")

;; Programming environment
(package! tide :pin "1878a097fc")

(when (featurep! :tools lookup)
  (package! xref-js2 :pin "6f1ed5dae0")
)

(package! import-js)

;; npm install -g indium
(package! indium)

(package! mocha)
