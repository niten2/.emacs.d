;; -*- no-byte-compile: t; -*-

(def-project-mode! +javascript-gulp-mode :when (locate-dominating-file default-directory "gulpfile.js"))

(after! (:any js2-mode rjsx-mode web-mode)
  (set-docsets! '(js2-mode rjsx-mode) "JavaScript"
                "AngularJS" "Backbone" "BackboneJS" "Bootstrap" "D3JS" "EmberJS" "Express"
                "ExtJS" "JQuery" "JQuery_Mobile" "JQuery_UI" "KnockoutJS" "Lo-Dash"
                "MarionetteJS" "MomentJS" "NodeJS" "PrototypeJS" "React" "RequireJS"
                "SailsJS" "UnderscoreJS" "VueJS" "ZeptoJS"
                )

  (set-pretty-symbols! '(js2-mode rjsx-mode web-mode)
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
                       :yield "import"
                       )
  )

(after! projectile
  (pushnew! projectile-project-root-files "package.json")
  (pushnew! projectile-globally-ignored-directories "node_modules" "flow-typed")
  )

;; Major modes
(use-package! js2-mode
  :mode "\\.m?js\\'"
  :interpreter "node"
  :commands js2-line-break
  :config
  (setq
   js-chain-indent t

   ;; Don't mishighlight shebang lines
   js2-skip-preprocessor-directives t

   ;; let flycheck handle this
   js2-mode-show-parse-errors nil
   js2-mode-show-strict-warnings nil

   ;; Flycheck provides these features, so disable them: conflicting with
   ;; the eslint settings.
   js2-strict-trailing-comma-warning nil
   js2-strict-missing-semi-warning nil

   ;; maximum fontification
   js2-highlight-level 3
   js2-highlight-external-variables t
   js2-idle-timer-delay 0.1
   )

  (add-hook 'js2-mode-hook #'rainbow-delimiters-mode)
  ;; (add-hook 'js2-mode-hook #'indium-interaction-mode)

  ;; indent switch-case another step
  (setq-hook! 'js2-mode-hook
    js-switch-indent-offset js2-basic-offset
    mode-name "JS2"
    )

  (set-electric! 'js2-mode :chars '(?\} ?\) ?. ?:))
  (set-repl-handler! 'js2-mode #'+javascript/open-repl)

  (map! :map js2-mode-map
        :localleader
        ;; "S" #'+javascript/skewer-this-buffer
        ;; "i" #'indium-interaction-mode
        )
  )

(use-package! rjsx-mode
  :mode "components/.+\\.js$"
  :init
  (defun +javascript-jsx-file-p ()
    "Detect React or preact imports early in the file."
    (and buffer-file-name
         (string= (file-name-extension buffer-file-name) "js")
         (re-search-forward "\\(^\\s-*import +React\\|\\( from \\|require(\\)[\"']p?react\\)"
                            magic-mode-regexp-match-limit t)
         (progn (goto-char (match-beginning 1))
                (not (sp-point-in-string-or-comment)))))
  (add-to-list 'magic-mode-alist '(+javascript-jsx-file-p . rjsx-mode))
  :config
  (set-electric! 'rjsx-mode :chars '(?\} ?\) ?. ?>))

  (when (featurep! :checkers syntax)
    (add-hook! 'rjsx-mode-hook
               ;; jshint doesn't know how to deal with jsx
               (push 'javascript-jshint flycheck-disabled-checkers)
               )
    )

  ;; `rjsx-electric-gt' relies on js2's parser to tell it when the cursor is in
  ;; a self-closing tag, so that it can insert a matching ending tag at point.
  ;; However, the parser doesn't run immediately, so a fast typist can outrun
  ;; it, causing tags to stay unclosed, so we force it to parse.
  (defadvice! +javascript-reparse-a (n)
    ;; if n != 1, rjsx-electric-gt calls rjsx-maybe-reparse itself
    :before #'rjsx-electric-gt
    (if (= n 1) (rjsx-maybe-reparse))))

(use-package! typescript-mode
  :defer t
  :init
  ;; REVIEW Fix #2252. This is overwritten if the :lang web module is enabled.
  ;;        We associate TSX files with `web-mode' by default instead because
  ;;        `typescript-mode' does not officially support JSX/TSX. See
  ;;        https://github.com/emacs-typescript/typescript.el/issues/4
  (unless (featurep! :lang web)
    (add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-mode))
    )

  :config
  (add-hook 'typescript-mode-hook #'rainbow-delimiters-mode)
  (setq-hook! 'typescript-mode-hook
    comment-line-break-function #'js2-line-break)
  (set-electric! 'typescript-mode
    :chars '(?\} ?\)) :words '("||" "&&"))
  (set-docsets! 'typescript-mode "TypeScript" "AngularTS")
  (set-pretty-symbols! 'typescript-mode
                       ;; Functional
                       :def "function"
                       :lambda "() =>"
                       :composition "compose"
                       ;; Types
                       :null "null"
                       :true "true" :false "false"
                       :int "number"
                       :str "string"
                       :bool "boolean"
                       ;; Flow
                       :not "!"
                       :and "&&" :or "||"
                       :for "for"
                       :return "return" :yield "import"))

;;; Tools
(add-hook! '(js-mode-hook typescript-mode-hook web-mode-hook)
  (defun +javascript-init-lsp-or-tide-maybe-h ()
    "Start `lsp' or `tide' in the current buffer.
    LSP will be used if the +lsp flag is enabled for :lang javascript AND if the
    current buffer represents a file in a project.
    If LSP fails to start (e.g. no available server or project), then we fall back
    to tide."
    (let ((buffer-file-name (buffer-file-name (buffer-base-buffer))))
      (when (or (derived-mode-p 'js-mode 'typescript-mode)
                (and buffer-file-name
                     (eq major-mode 'web-mode)
                     (string= "tsx" (file-name-extension buffer-file-name))))
        (if (not buffer-file-name)
            ;; necessary because `tide-setup' and `lsp' will error if not a
            ;; file-visiting buffer
            (add-hook 'after-save-hook #'+javascript-init-tide-or-lsp-maybe-h nil 'local)
          (or (and (featurep! +lsp) (lsp!))
              ;; fall back to tide
              (if (executable-find "node")
                  (and (require 'tide nil t)
                       (progn (tide-setup) tide-mode))
                (ignore
                 (doom-log "Couldn't start tide because 'node' is missing"))))
          (remove-hook 'after-save-hook #'+javascript-init-tide-or-lsp-maybe-h 'local))))
    )
  )

(use-package! tide
  :defer t
  :config
  (setq tide-completion-detailed t tide-always-show-documentation t)
  ;; code completion
  (after! company
    ;; tide affects the global `company-backends', undo this so doom can handle
    ;; it buffer-locally
    (setq-default company-backends (delq 'company-tide (default-value 'company-backends))))

  (set-company-backend! 'tide-mode 'company-tide)
  ;; navigation
  (set-lookup-handlers! 'tide-mode
    :definition '(tide-jump-to-definition :async t)
    :references '(tide-references :async t))
  ;; resolve to `doom-project-root' if `tide-project-root' fails
  (advice-add #'tide-project-root :override #'+javascript-tide-project-root-a)
  ;; cleanup tsserver when no tide buffers are left
  (add-hook! 'tide-mode-hook
    (add-hook 'kill-buffer-hook #'+javascript-cleanup-tide-processes-h nil t))

  ;; Eldoc is activated too soon and disables itself, thinking there is no eldoc
  ;; support in the current buffer, so we must re-enable it later once eldoc
  ;; support exists. It is set *after* tide-mode is enabled, so enabling it on
  ;; `tide-mode-hook' is too early, so...
  (advice-add #'tide-setup :after #'eldoc-mode)

  (define-key tide-mode-map [remap +lookup/documentation] #'tide-documentation-at-point)

  (map!
   :map tide-mode-map
   :localleader
   (:prefix ("t" . "tide")
     "s" #'tide-restart-server
     "f" #'tide-format
     "r" #'tide-rename-symbol
     "o" #'tide-organize-imports
     )
   )
  )

(use-package! xref-js2
  :when (featurep! :tools lookup)
  :after (:or js2-mode rjsx-mode)
  :config
  (set-lookup-handlers! '(js2-mode rjsx-mode)
    :xref-backend #'xref-js2-xref-backend))

(use-package! js2-refactor
  :hook ((js2-mode rjsx-mode) . js2-refactor-mode)
  :init
  (map! :after js2-mode
        :map js2-mode-map
        :localleader
        (:prefix ("r" . "refactor")
          ;; "ee" #'js2r-expand-node-at-point
          ;; "cc" #'js2r-contract-node-at-point
          ;; "wi" #'js2r-wrap-buffer-in-iife
          ;; "ig" #'js2r-inject-global-in-iife

          ;; "ev" #'js2r-extract-var
          "el" #'js2r-extract-let
          "ec" #'js2r-extract-const

          "iv" #'js2r-inline-var
          "rv" #'js2r-rename-var
          "vt" #'js2r-var-to-this

          ;; "ag" #'js2r-add-to-globals-annotation
          ;; "sv" #'js2r-split-var-declaration
          ;; "ss" #'js2r-split-string
          ;; "st" #'js2r-string-to-template
          ;; "ef" #'js2r-extract-function
          ;; "em" #'js2r-extract-method
          ;; "ip" #'js2r-introduce-parameter
          ;; "lp" #'js2r-localize-parameter
          "tf" #'js2r-toggle-function-expression-and-declaration

          "ta" #'js2r-toggle-arrow-function-and-expression

          ;; "ts" #'js2r-toggle-function-async

          ;; "ao" #'js2r-arguments-to-object
          "uw" #'js2r-unwrap
          "wl" #'js2r-wrap-in-for-loop
          "3i" #'js2r-ternary-to-if
          "lt" #'js2r-log-this
          "dt" #'js2r-debug-thi
          "sl" #'js2r-forward-slur
          "ba" #'js2r-forward-bar
          "k" #'js2r-kill
          )
        )
  :config
  (when (featurep! :editor evil +everywhere)
    (add-hook 'js2-refactor-mode-hook #'evil-normalize-keymaps)
    (let ((js2-refactor-mode-map (evil-get-auxiliary-keymap js2-refactor-mode-map 'normal t t)))
      (js2r-add-keybindings-with-prefix (format "%s r" doom-localleader-key)))))

;;;###package skewer-mode
(map! :localleader
      (:after js2-mode
        :map js2-mode-map
        :prefix ("s" . "skewer")
        )

      :prefix "s"
      (:after skewer-mode
        :map skewer-mode-map
        "E" #'skewer-eval-last-expression
        "e" #'skewer-eval-defun
        "f" #'skewer-load-buffer
        )

      (:after skewer-css
        :map skewer-css-mode-map
        "e" #'skewer-css-eval-current-declaration
        "r" #'skewer-css-eval-current-rule
        "b" #'skewer-css-eval-buffer
        "c" #'skewer-css-clear-alli
        )

      (:after skewer-html
        :map skewer-html-mode-map
        "e" #'skewer-html-eval-tag
        )

      :prefix "x"
      (:after skewer-mode
        :map skewer-mode-map
        "E" #'skewer-eval-last-expression
        "e" #'skewer-eval-defun
        "f" #'skewer-load-buffer
        )
      )

(use-package! npm-mode
  :hook ((js-mode typescript-mode) . npm-mode)
  :config
  (map!
   (:localleader
     ;; :map npm-mode-keymap
     ;; "n" npm-mode-command-keymap

     (:after js2-mode
       :map js2-mode-map
       :localleader
       (:prefix ("n" . "npm")
         "n" #'npm-mode-npm-init
         "i" #'npm-mode-npm-install
         "s" #'npm-mode-npm-install-save
         "d" #'npm-mode-npm-install-save-dev
         "u" #'npm-mode-npm-uninstall
         "l" #'npm-mode-npm-list
         "r" #'npm-mode-npm-run
         "v" #'npm-mode-visit-project-file
         )
       )
     )
   )
  )

;;; Projects
(def-project-mode! +javascript-npm-mode
  :modes '(
           html-mode
           css-mode
           web-mode
           markdown-mode
           js-mode
           typescript-mode
           solidity-mode
           )
  :when (locate-dominating-file default-directory "package.json")
  :add-hooks '(+javascript-add-node-modules-path-h npm-mode)
  )

(use-package! nodejs-repl
  :init
  (map! :after js2-mode
        :map js2-mode-map
        :localleader
        (:prefix ("g" . "nodejs-repl")
          "r" #'nodejs-repl
          "b" #'nodejs-repl-send-buffer
          "v" #'nodejs-repl-send-region
          )
        )
  )

(use-package! import-js
  :init
  (map! :after js2-mode
        :map js2-mode-map
        :localleader
        (:prefix ("i" . "importjs")
          "r" #'run-import-js
          "k" #'kill-import-js
          "i" #'import-js-import
          "f" #'import-js-fix
          )
        )
  )

;; (use-package! indium
;;   :init
;;   (map! :after js2-mode
;;         :map js2-mode-map
;;         :localleader
;;         (:prefix ("d" . "indium")
;;           "c" #'indium-connect
;;           "l" #'indium-launch
;;           "a" #'indium-add-breakpoint
;;           "t" #'indium-toggle-breakpoint
;;           "s" #'indium-scratch
;;           "q" #'indium-quit
;;           "r" #'indium-reload
;;           "k" #'indium-deactivate-breakpoints
;;           "o" #'indium-debugger-locals
;;         )
;;   )
;; )

(use-package! eslint-fix
  :init
  (map! :localleader
        (:after js2-mode
          :map js2-mode-map
          "f" (lambda () (interactive) (save-buffer) (eslint-fix))
          )
        )
  )

(use-package! mocha
  :init
  (setq
   mocha-options "-r esm --timeout 50000 --reporter spec"
   mocha-which-node "/home/q/.nvm/versions/node/v12.10.0/bin/node"
   mocha-reporter "spec"
   mocha-project-test-directory "test"
   mocha-command "node_modules/.bin/mocha"
   mocha-environment-variables "NODE_ENV=test"
   )
  (map! :after js2-mode
        :map js2-mode-map
        :localleader
        (:prefix ("m" . "mocha")
          "h" #'mocha-test-at-point
          "f" #'mocha-test-file
          "p" #'mocha-test-project
          "d" #'mocha-debug-at-point
          )
        )
  )

