;;; lang/javascript/config.el -*- lexical-binding: t; -*-

;; counsel-imenu
(after! projectile
  (pushnew! projectile-project-root-files "package.json")
  (pushnew! projectile-globally-ignored-directories "node_modules" "flow-typed"))

(dolist (feature '(rjsx-mode
                   typescript-mode
                   web-mode
                   (nodejs-repl-mode . nodejs-repl)))
  (let ((pkg  (or (cdr-safe feature) feature))
        (mode (or (car-safe feature) feature)))
    (with-eval-after-load pkg
      (set-docsets! mode "JavaScript"
                    "AngularJS" "Backbone" "BackboneJS" "Bootstrap" "D3JS" "EmberJS" "Express"
                    "ExtJS" "JQuery" "JQuery_Mobile" "JQuery_UI" "KnockoutJS" "Lo-Dash"
                    "MarionetteJS" "MomentJS" "NodeJS" "PrototypeJS" "React" "RequireJS"
                    "SailsJS" "UnderscoreJS" "VueJS" "ZeptoJS")
      (set-ligatures! mode
                      :def "function"
                      :lambda "() =>"
                      :composition "compose"
                      :null "null"
                      :true "true" :false "false"
                      :not "!"
                      :and "&&" :or "||"
                      :for "for"
                      :return "return"
                      :yield "import"))))


(use-package! rjsx-mode
  :mode "\\.[mc]?js\\'"
  :mode "\\.es6\\'"
  :mode "\\.pac\\'"
  :interpreter "node"
  :hook (rjsx-mode . rainbow-delimiters-mode)
  :init
  ;; Parse node stack traces in the compilation buffer
  (after! compilation
    (add-to-list 'compilation-error-regexp-alist 'node)
    (add-to-list 'compilation-error-regexp-alist-alist
                 '(node "^[[:blank:]]*at \\(.*(\\|\\)\\(.+?\\):\\([[:digit:]]+\\):\\([[:digit:]]+\\)"
                        2 3 4)))
  :config
  (set-repl-handler! 'rjsx-mode #'+javascript/open-repl)
  (set-electric! 'rjsx-mode :chars '(?\} ?\) ?. ?:))

  (setq js-chain-indent t
        ;; These have become standard in the JS community
        js2-basic-offset 2
        ;; Don't mishighlight shebang lines
        js2-skip-preprocessor-directives t
        ;; let flycheck handle this
        js2-mode-show-parse-errors nil
        js2-mode-show-strict-warnings nil
        ;; Flycheck provides these features, so disable them: conflicting with
        ;; the eslint settings.
        js2-strict-missing-semi-warning nil
        ;; maximum fontification
        js2-highlight-level 3
        js2-idle-timer-delay 0.15)

  (setq-hook! 'rjsx-mode-hook
    ;; Indent switch-case another step
    js-switch-indent-offset js2-basic-offset)

  ;; HACK `rjsx-electric-gt' relies on js2's parser to tell it when the cursor
  ;;      is in a self-closing tag, so that it can insert a matching ending tag
  ;;      at point. The parser doesn't run immediately however, so a fast typist
  ;;      can outrun it, causing tags to stay unclosed, so force it to parse:
  (defadvice! +javascript-reparse-a (n)
    ;; if n != 1, rjsx-electric-gt calls rjsx-maybe-reparse itself
    :before #'rjsx-electric-gt
    (if (= n 1) (rjsx-maybe-reparse))))

(use-package! js2-refactor
  :hook ((js2-mode rjsx-mode) . js2-refactor-mode)
  :init
  (map! :after js2-mode
        :map js2-mode-map
        :localleader
        (:prefix ("r" "refactor")
         (:prefix ("a" . "add/arguments"))
         (:prefix ("b" . "barf"))
         (:prefix ("c" . "contract"))
         (:prefix ("d" . "debug"))
         (:prefix ("e" . "expand/extract"))
         (:prefix ("i" . "inject/inline/introduce"))
         (:prefix ("l" . "localize/log"))
         (:prefix ("o" . "organize"))
         (:prefix ("r" . "rename"))
         (:prefix ("s" . "slurp/split/string"))
         (:prefix ("t" . "toggle"))
         (:prefix ("u" . "unwrap"))
         (:prefix ("v" . "var"))
         (:prefix ("w" . "wrap"))
         (:prefix ("3" . "ternary"))))
  :config
  (when (featurep! :editor evil +everywhere)
    (add-hook 'js2-refactor-mode-hook #'evil-normalize-keymaps)
    (let ((js2-refactor-mode-map (evil-get-auxiliary-keymap js2-refactor-mode-map 'normal t t)))
      (js2r-add-keybindings-with-prefix (format "%s r" doom-localleader-key))))

  (set-company-backend! 'company-tide 'company-tabnine)
  )

;;;###package skewer-mode
(map! :localleader
      (:after js2-mode
       :map js2-mode-map
       "S" #'+javascript/skewer-this-buffer
       :prefix ("s" . "skewer"))
      :prefix "s"
      (:after skewer-mode
       :map skewer-mode-map
       "E" #'skewer-eval-last-expression
       "e" #'skewer-eval-defun
       "f" #'skewer-load-buffer)

      (:after skewer-css
       :map skewer-css-mode-map
       "e" #'skewer-css-eval-current-declaration
       "r" #'skewer-css-eval-current-rule
       "b" #'skewer-css-eval-buffer
       "c" #'skewer-css-clear-all)

      (:after skewer-html
       :map skewer-html-mode-map
       "e" #'skewer-html-eval-tag))


;;;###package npm-mode
(use-package! npm-mode
  :hook ((js-mode typescript-mode) . npm-mode)
  :config
  (map! :localleader
        (:map npm-mode-keymap
         "n" npm-mode-command-keymap)
        (:after js2-mode
         :map js2-mode-map
         :prefix ("n" . "npm"))))


;;; Projects

(def-project-mode! +javascript-npm-mode
  :modes '(html-mode
           css-mode
           web-mode
           markdown-mode
           js-mode  ; includes js2-mode and rjsx-mode
           json-mode
           typescript-mode
           solidity-mode)
  :when (locate-dominating-file default-directory "package.json")
  :add-hooks '(add-node-modules-path npm-mode))

(def-project-mode! +javascript-gulp-mode
  :when (locate-dominating-file default-directory "gulpfile.js"))

(use-package! eslint-fix
  :init
  (map! :localleader
        (:after js2-mode
         :map js2-mode-map
         "f" (lambda () (interactive) (save-buffer) (eslint-fix))
         )
        )
  )

(use-package! tide
  :init
  ;; (setq tide-tsserver-executable "node_modules/typescript/bin/tsserver")
  (setq tide-tsserver-executable "/home/q/.nvm/versions/node/v14.16.0/bin/tsserver")
  :hook (tide-mode . tide-hl-identifier-mode)

  :config
  ;; (set-company-backend! 'tide-mode 'company-tide 'company-yasnippet 'company-tabnine)

  ;; lookup
  ;; (set-lookup-handlers! 'tide-mode :async t
  ;;   :xref-backend #'xref-tide-xref-backend
  ;;   :documentation #'tide-documentation-at-point)

  (set-popup-rule! "^\\*tide-documentation" :quit t)

  (setq tide-completion-detailed t
        tide-always-show-documentation t
        tide-server-max-response-length 524288
        tide-completion-setup-company-backend nil)

  ;; Resolve to `doom-project-root' if `tide-project-root' fails
  (advice-add #'tide-project-root :override #'+javascript-tide-project-root-a)

  ;; Cleanup tsserver when no tide buffers are left
  (add-hook! 'tide-mode-hook
    (add-hook 'kill-buffer-hook #'+javascript-cleanup-tide-processes-h
              nil 'local))

  (advice-add #'tide-setup :after #'eldoc-mode)

  (map! :localleader
        :map tide-mode-map
        "r" #'tide-restart-server
        ;; "f" #'tide-format
        "s" #'tide-rename-symbol
        "i" #'tide-organize-imports))

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (tide-enable-xref t)
  (tide-jump-to-definition-reuse-window t)
  (company-mode +1))

(add-hook 'typescript-mode-hook #'setup-tide-mode)
(add-hook 'js2-mode-hook #'setup-tide-mode)
(setq company-tooltip-align-annotations t)



;; (eval-after-load 'js-mode
;;   '(add-hook 'js-mode-hook (lambda () (add-hook 'after-save-hook 'eslint-fix nil t))))

;; (eval-after-load 'js2-mode
;;   '(add-hook 'js2-mode-hook (lambda () (add-hook 'after-save-hook 'eslint-fix nil t))))

(add-hook 'typescript-mode-hook 'prettier-js-mode)


;; (defun eslint-fix-file ()
;;   (interactive)
;;   (message "eslint --fixing the file" (buffer-file-name))
;;   (shell-command (concat "eslint --fix " (buffer-file-name))))

;; (defun eslint-fix-file-and-revert ()
;;   (interactive)
;;   (eslint-fix-file)
;;   (revert-buffer t t))

;; (add-hook 'js2-mode-hook
;;           (lambda ()
;;             (add-hook 'after-save-hook #'eslint-fix-file-and-revert)))



;; (defun tim-eslint-fix-file ()
;;   (interactive)
;;   (message "eslint --fix the file" (buffer-file-name))
;;   (call-process-shell-command
;;    (concat "yarn eslint --fix " (buffer-file-name))
;;    nil "*Shell Command Output*" t)
;;   (revert-buffer t t))

;; (add-hook 'js2-mode-hook
;;           (lambda ()
;;             (add-hook 'after-save-hook #'tim-eslint-fix-file)))

;; (require 'company-tabnine)
;; (add-to-list 'company-backends #'company-tabnine)
;; (setq company-idle-delay 0)
;; (setq company-show-numbers t)

;; (after! js2-mode
;;   (set-company-backend! 'js2-mode 'company-yasnippet 'company-tabnine 'company-tide))

;; (after! tide-mode
;;   (set-company-backend! 'tide-mode 'company-tide 'company-yasnippet 'company-tabnine))


(eval-after-load "company"
  '(add-to-list 'company-backends 'company-tabnine))
