;; ;;; tools/debugger/config.el -*- lexical-binding: t; -*-

;; (defvar +debugger--realgud-alist
;;   '((realgud:bashdb    :modes (sh-mode))
;;     (realgud:gdb)
;;     (realgud:gub       :modes (go-mode))
;;     (realgud:kshdb     :modes (sh-mode))
;;     (realgud:pdb       :modes (python-mode))
;;     (realgud:perldb    :modes (perl-mode perl6-mode))
;;     (realgud:rdebug    :modes (ruby-mode enh-ruby-mode))
;;     (realgud:remake)
;;     (realgud:trepan    :modes (perl-mode perl6-mode))
;;     (realgud:trepan2   :modes (python-mode))
;;     (realgud:trepan3k  :modes (python-mode))
;;     (realgud:trepanjs  :modes (javascript-mode js2-mode js3-mode))
;;     (realgud:trepanpl  :modes (perl-mode perl6-mode))
;;     (realgud:zshdb     :modes (sh-mode))))

;; ;;; Packages

;; ;;;###package gdb
;; (setq gdb-show-main t
;;       gdb-many-windows t)

;; (use-package! dap-mode
;;   :when (featurep! :tools lsp)
;;   :after lsp-mode
;;   :preface
;;   (add-hook 'dap-mode-hook #'dap-ui-mode) ; use a hook so users can remove it
;;   (setq dap-breakpoints-file (concat doom-etc-dir "dap-breakpoints")
;;         dap-utils-extension-path (concat doom-etc-dir "dap-extension/"))
;;   :config
;;   (dap-mode 1)
;;   (dolist (module '(((:lang . cc) ccls dap-lldb dap-gdb-lldb)
;;                     ((:lang . elixir) elixir-mode dap-elixir)
;;                     ((:lang . go) go-mode dap-go)
;;                     ((:lang . java) lsp-java dap-java)
;;                     ((:lang . php) php-mode dap-php)
;;                     ((:lang . python) python dap-python)
;;                     ((:lang . ruby) enh-ruby-mode dap-ruby)
;;                     ((:lang . rust) rust-mode dap-lldb)))
;;     (when (doom-module-p (caar module) (cdar module) '+lsp)
;;       (with-eval-after-load (nth 1 module)
;;         (mapc #'require (cddr module)))))

;;   (when (featurep! :lang javascript +lsp)
;;     (with-eval-after-load 'js2-mode
;;       (require 'dap-node)
;;       (require 'dap-chrome)
;;       (require 'dap-firefox)
;;       (when IS-WINDOWS
;;         (require 'dap-edge)))))


;; (use-package! realgud
;;   :defer t
;;   :init
;;   (use-package! realgud-trepan-ni
;;     :defer t
;;     :init (add-to-list '+debugger--realgud-alist
;;                        '(realgud:trepan-ni :modes (javascript-mode js2-mode js3-mode)
;;                                            :package realgud-trepan-ni)))

;;   ;; Realgud doesn't generate its autoloads properly so we do it ourselves
;;   (dolist (debugger +debugger--realgud-alist)
;;     (autoload (car debugger)
;;       (if-let (sym (plist-get (cdr debugger) :package))
;;           (symbol-name sym)
;;         "realgud")
;;       nil t))

;;   :config
;;   (set-popup-rule! "^\\*\\(?:trepanjs:\\(?:g\\|zsh\\|bash\\)db\\|pdb \\)"
;;     :size 20 :select nil :quit nil)

;;   (defadvice! +debugger--cleanup-after-realgud-a (&optional buf)
;;     "Kill command buffer when debugging session ends (which closes its popup)."
;;     :after #'realgud:terminate
;;     (when (stringp buf)
;;       (setq buf (get-buffer buf)))
;;     (when-let (cmdbuf (realgud-get-cmdbuf buf))
;;       (let (kill-buffer-hook)
;;         (kill-buffer buf))))

;;   ;; Monkey-patch `realgud:run-process' to run in a popup.
;;   ;; TODO Find a more elegant solution
;;   ;; FIXME Causes realgud:cmd-* to focus popup on every invocation
;;   (defadvice! +debugger--realgud-open-in-other-window-a
;;     (debugger-name script-filename cmd-args minibuffer-history-var &optional no-reset)
;;     :override #'realgud:run-process
;;     (let* ((cmd-buf (apply #'realgud-exec-shell debugger-name script-filename
;;                            (car cmd-args) no-reset (cdr cmd-args)))
;;            (process (get-buffer-process cmd-buf)))
;;       (cond ((and process (eq 'run (process-status process)))
;;              (pop-to-buffer cmd-buf)
;;              (when (boundp 'evil-emacs-state-local-map)
;;                (define-key evil-emacs-state-local-map (kbd "ESC ESC") #'+debugger/quit))
;;              (realgud:track-set-debugger debugger-name)
;;              (realgud-cmdbuf-info-in-debugger?= 't)
;;              (realgud-cmdbuf-info-cmd-args= cmd-args)
;;              (when cmd-buf
;;                (switch-to-buffer cmd-buf)
;;                (when realgud-cmdbuf-info
;;                  (let* ((info realgud-cmdbuf-info)
;;                         (cmd-args (realgud-cmdbuf-info-cmd-args info))
;;                         (cmd-str  (mapconcat #'identity cmd-args " ")))
;;                    (if (boundp 'starting-directory)
;;                        (realgud-cmdbuf-info-starting-directory= starting-directory))
;;                    (set minibuffer-history-var
;;                         (cl-remove-duplicates (cons cmd-str (eval minibuffer-history-var))
;;                                               :from-end t))))))
;;             (t
;;              (if cmd-buf (switch-to-buffer cmd-buf))
;;              (message "Error running command: %s" (mapconcat #'identity cmd-args " "))))
;;       cmd-buf)))


;; (use-package dap-mode
;;   ;; Uncomment the config below if you want all UI panes to be hidden by default!
;;   ;; :custom
;;   ;; (lsp-enable-dap-auto-configure nil)
;;   ;; :config
;;   ;; (dap-ui-mode 1)

;;   :config
;;   ;; Set up Node debugging
;;   (require 'dap-node)
;;   ;; (require 'dap-python)
;;   (dap-node-setup)

;;   ;; :hook ((python-mode . dap-ui-mode) (python-mode . dap-mode))

;;   ;; Bind `C-c l d` to `dap-hydra` for easy access
;;   (general-define-key
;;    :keymaps 'lsp-mode-map
;;    :prefix lsp-keymap-prefix
;;    "d" '(dap-hydra t :wk "debugger")))

;; (setq dap-auto-configure-features '(sessions locals controls tooltip))
;; (add-hook 'dap-stopped-hook (lambda (arg) (call-interactively #'dap-hydra)))


;; (dap-register-debug-template "Node Attach"
;;                              (list :type "node"
;;                                    :cwd nil
;;                                    :request "attach"
;;                                    :program nil
;;                                    :name "Node::Attach"))

;; (dap-debug
;;  (list :type "node"
;;        :request "attach"
;;        :port 9229
;;        :program "__ignored"
;;        :name "Debug docker language server."))

;; (dap-register-debug-template "Python :: test"
;;                              (list :type "python"
;;                                    :args ""
;;                                    :cwd nil
;;                                    :program "/home/q/code/code/test.py"
;;                                    :module nil
;;                                    :request "launch"
;;                                    :name "Python :: Run Configuration"))

;; (dap-register-debug-template "Node Run TEST"
;;                              (list :type "node"
;;                                    :args "-r esm --timeout 120000 --exit"
;;                                    :cwd nil
;;                                    :request "launch"
;;                                    :program "mocha"
;;                                    :name "Node::Run"
;;                                    ))

;; (dap-register-debug-template "node:test"
;;                              (list :type "node"
;;                                    :runtimeArgs ["-r" "esm"]
;;                                    :env '(("ENVIRONMENT" . "test"))
;;                                    :cwd nil
;;                                    :request "launch"
;;                                    :program "/home/q/_link/LuckyLinkTeam/eva-microservices-backend/node_modules/.bin/_mocha"
;;                                    :sourceMaps t
;;                                    :name "node::test"))


; (dap-register-debug-template "node:attach"
;;  (list :type "node"
;;        :request "attach"
;;        :port 9229
;;        :program "__ignored"
;;        :name "node:attach"))

;; (dap-register-debug-template
;;  (list :type "node"
;;        :request "attach"
;;        :port 9229
;;        :program "__ignored"
;;        :name "node:attach"))
;; {
;; "name": "Attach",
;; "port": 9229,
;; "request": "attach",
;; "skipFiles": [
;;               "<node_internals>/**"
;;               ],
;; "type": "pwa-node"
;; },

;; (dap-register-debug-template "debug node server"
;;   (list :type "node"
;;         :request "launch"
;;         :program "${workspaceFolder}/src/index.js"
;;         ))
