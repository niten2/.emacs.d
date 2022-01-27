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
                      ;; Functional
                      :def "function"
                      :lambda "() =>"
                      :composition "compose"
                      ;; Types
                      :null "null"
                      :true "true" :false "false"
                      ;; Flow
                      :not "!"
                      :and "&&" :or "||"
                      :for "for"
                      :return "return"
                      ;; Other
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
      (js2r-add-keybindings-with-prefix (format "%s r" doom-localleader-key)))))

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


;;
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
  (set-company-backend! 'tide-mode 'company-tide)

  ;; lookup
  ;; (set-lookup-handlers! 'tide-mode :async t
  ;;   :xref-backend #'xref-tide-xref-backend
  ;;   :documentation #'tide-documentation-at-point)

  (set-popup-rule! "^\\*tide-documentation" :quit t)

  (setq tide-completion-detailed t
        tide-always-show-documentation t
        ;; Fix #1792: by default, tide ignores payloads larger than 100kb. This
        ;; is too small for larger projects that produce long completion lists,
        ;; so we up it to 512kb.
        tide-server-max-response-length 524288
        ;; We'll handle it
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


;; (use-package typescript-mode
;;   :config
;;   (require 'dap-node)
;;   (dap-node-setup)
;;   (require 'indium)
;;   (add-hook 'js-mode-hook #'indium-interaction-mode)
;;   )

;; (dap-register-debug-template "Node Attach"
;;                              (list :type "node"
;;                                    :port 9229
;;                                    :request "attach"
;;                                    :hostName "localhost"
;;                                    :program "__ignored"
;;                                    :name "Node::Attach"))




;; (add-hook 'typescript-mode-hook #'format-all-buffer)
;; (add-hook 'js2-mode-hook #'format-all-buffer)

;; aligns annotation to the right hand side


;; (add-hook 'js2-mode-hook
;;           (lambda ()
;;             (add-hook 'before-save-hook 'format-all-buffer)))

;; (add-hook 'typescript-mode-hook
;;           (lambda ()
;;             (add-hook 'before-save-hook 'format-all-buffer)))




;; (add-hook 'before-save-hook 'tide-format-before-save)







;; old
;; (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
;; (setq xref-show-definitions-function #'xref-show-definitions-completing-read)


;; NOTE lookup
;; (use-package! xref-js2
;;   :init
;;   (setq xref-js2-search-program 'rg)
;;   (set-lookup-handlers! 'js2-mode :xref-backend #'xref-js2-xref-backend nil t))


;; (set-lookup-handlers! 'js2-mode :xref-backend #'xref-js2-xref-backend nil t)

;; (set-lookup-handlers! 'go-mode
;;   :definition #'go-guru-definition
;;   :references #'go-guru-referrers
;;   :documentation #'godoc-at-point)



;; ;; (define-key js2-mode-map (kbd "M-.") nil)
;; (add-hook 'js2-mode-hook (lambda () (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))
;; (setq xref-js2-search-program 'ag)

;; (setq lsp-sonarlint-javascript-enabled t)
;; (setq lsp-sonarlint-html-enabled t)
;; (setq lsp-sonarlint-typescript-enabled t)

;; (use-package! typescript-mode
;;   :hook (typescript-mode . rainbow-delimiters-mode)
;;   :hook (typescript-tsx-mode . rainbow-delimiters-mode)
;;   :commands typescript-tsx-mode
;;   :init
;;   ;; REVIEW We associate TSX files with `typescript-tsx-mode' derived from
;;   ;;        `web-mode' because `typescript-mode' does not officially support
;;   ;;        JSX/TSX. See emacs-typescript/typescript.el#4
;;   (add-to-list 'auto-mode-alist
;;                (cons "\\.tsx\\'"
;;                      (if (featurep! :lang web)
;;                          #'typescript-tsx-mode
;;                        #'typescript-mode)))

;;   (when (featurep! :checkers syntax)
;;     (after! flycheck
;;       (flycheck-add-mode 'javascript-eslint 'web-mode)
;;       (flycheck-add-mode 'javascript-eslint 'typescript-mode)
;;       (flycheck-add-mode 'javascript-eslint 'typescript-tsx-mode)
;;       (flycheck-add-mode 'typescript-tslint 'typescript-tsx-mode)
;;       (unless (featurep! +lsp)
;;         (after! tide
;;           (flycheck-add-next-checker 'typescript-tide '(warning . javascript-eslint) 'append)
;;           (flycheck-add-mode 'typescript-tide 'typescript-tsx-mode)))
;;       (add-hook! 'typescript-tsx-mode-hook
;;         (defun +javascript-disable-tide-checkers-h ()
;;           (pushnew! flycheck-disabled-checkers
;;                     'javascript-jshint
;;                     'tsx-tide
;;                     'jsx-tide)))))
;;   :config
;;   (when (fboundp 'web-mode)
;;     (define-derived-mode typescript-tsx-mode web-mode "TypeScript-TSX"))

;;   (set-docsets! '(typescript-mode typescript-tsx-mode)
;;                 :add "TypeScript" "AngularTS")
;;   (set-electric! '(typescript-mode typescript-tsx-mode)
;;     :chars '(?\} ?\))
;;     :words '("||" "&&"))
;;   ;; HACK Fixes comment continuation on newline
;;   (autoload 'js2-line-break "js2-mode" nil t)
;;   (setq-hook! 'typescript-mode-hook
;;     comment-line-break-function #'js2-line-break

;;     ;; Most projects use either eslint, prettier, .editorconfig, or tsf in order
;;     ;; to specify indent level and formatting. In the event that no
;;     ;; project-level config is specified (very rarely these days), the community
;;     ;; default is 2, not 4. However, respect what is in tsfmt.json if it is
;;     ;; present in the project
;;     typescript-indent-level
;;     (or (and (bound-and-true-p tide-mode)
;;              (plist-get (tide-tsfmt-options) :indentSize))
;;         typescript-indent-level)))


;;
;;; Tools

;; (add-hook! '(typescript-mode-local-vars-hook
;;              typescript-tsx-mode-local-vars-hook
;;              web-mode-local-vars-hook
;;              rjsx-mode-local-vars-hook)
;;   (defun +javascript-init-lsp-or-tide-maybe-h ()
;;     "Start `lsp' or `tide' in the current buffer.
;;     LSP will be used if the +lsp flag is enabled for :lang javascript AND if the current buffer represents a file in a project.
;;     If LSP fails to start (e.g. no available server or project), then we fall back to tide."
;;     (let ((buffer-file-name (buffer-file-name (buffer-base-buffer))))
;;       (when (derived-mode-p 'js-mode 'typescript-mode 'typescript-tsx-mode)
;;         (if (null buffer-file-name)
;;             ;; necessary because `tide-setup' and `lsp' will error if not a
;;             ;; file-visiting buffer
;;             (add-hook 'after-save-hook #'+javascript-init-lsp-or-tide-maybe-h
;;                       nil 'local)
;;           (or (if (featurep! +lsp) (lsp!))
;;               ;; fall back to tide
;;               (if (executable-find "node")
;;                   (and (require 'tide nil t)
;;                        (progn (tide-setup) tide-mode))
;;                 (ignore
;;                  (doom-log "Couldn't start tide because 'node' is missing"))))
;;           (remove-hook 'after-save-hook #'+javascript-init-lsp-or-tide-maybe-h
;;                        'local))))))
