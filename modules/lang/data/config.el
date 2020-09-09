(add-to-list 'auto-mode-alist '("/sxhkdrc\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.\\(?:hex\\|nes\\)\\'" . hexl-mode))

(use-package! nxml-mode
  :mode "\\.p\\(?:list\\|om\\)\\'" ; plist, pom
  :mode "\\.xs\\(?:d\\|lt\\)\\'"   ; xslt, xsd
  :mode "\\.rss\\'"
  :magic "<\\?xml"
  :config
  (setq nxml-slash-auto-complete-flag t
        nxml-auto-insert-xml-declaration-flag t)
  (set-company-backend! 'nxml-mode '(company-nxml company-yasnippet))
  (setq-hook! 'nxml-mode-hook tab-width nxml-child-indent)
)

;;; Third-party plugins
(map! :after csv-mode
      :localleader
      :map csv-mode-map
      "a" #'csv-align-fields
      "u" #'csv-unalign-fields
      "s" #'csv-sort-fields
      "S" #'csv-sort-numeric-fields
      "k" #'csv-kill-fields
      "t" #'csv-transpose
)

(use-package! graphql-mode
  :mode "\\.gql\\'"
  :config (setq-hook! 'graphql-mode-hook tab-width graphql-indent-level)
)

(use-package! json-mode
  :mode "\\.js\\(?:on\\|[hl]int\\(?:rc\\)?\\)\\'"
  :mode "\\.json"
  :config
  (set-electric! 'json-mode :chars '(?\n ?: ?{ ?}))
  ;; (map!
  ;;     :localleader
  ;;       (:prefix ("f" . "format")
  ;;         "b" #'json-mode-beautify
  ;;         "p" #'json-pretty-print
  ;;       )
  ;; )
)

(after! jsonnet-mode (set-electric! 'jsonnet-mode :chars '(?\n ?: ?{ ?})))
(after! yaml-mode (setq-hook! 'yaml-mode-hook tab-width yaml-indent-offset))

;; TODO
;; https://github.com/yoshiki/yaml-mode/issues/25

;;; Frameworks
;; (def-project-mode! +data-vagrant-mode :files ("Vagrantfile"))


;; (after! sql-mode ((setq tab-width 1))

;; (global-set-key "\t" (lambda () (interactive) (insert-char 32 2))) ;; [tab] inserts two spaces
;; (add-hook 'sql-mode-hook 'my-sql-mode-hook)
