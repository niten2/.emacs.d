;; -*- no-byte-compile: t; -*-
;;; Packages

(after! go-mode
  (set-docsets! 'go-mode "Go")
  (set-repl-handler! 'go-mode #'gorepl-run)
  (set-lookup-handlers! 'go-mode
    :definition #'go-guru-definition
    :references #'go-guru-referrers
    :documentation #'godoc-at-point)

  ;; Redefines default formatter to *not* use goimports if reformatting a
  ;; region; as it doesn't play well with partial code.
  (set-formatter! 'gofmt
    '(("%s" (if (or +format-region-p
                    (not (executable-find "goimports")))
                "gofmt"
              "goimports"))))

  (if (featurep! +lsp)
      (add-hook 'go-mode-local-vars-hook #'lsp!)
    (add-hook 'go-mode-hook #'go-eldoc-setup))

  (map! :map go-mode-map
        :localleader
        "f" #'gofmt
        "a" #'go-tag-add
        "d" #'go-tag-remove
        "e" #'+go/play-buffer-or-region
        "i" #'go-goto-imports      ; Go to imports
        (:prefix ("h" . "help")
          "." #'godoc-at-point     ; Lookup in godoc
          "d" #'go-guru-describe   ; Describe this
          "v" #'go-guru-freevars   ; List free variables
          "i" #'go-guru-implements ; Implements relations for package types
          "p" #'go-guru-peers      ; List peers for channel
          "P" #'go-guru-pointsto   ; What does this point to
          "r" #'go-guru-referrers  ; List references to object
          "e" #'go-guru-whicherrs  ; Which errors
          "w" #'go-guru-what       ; What query
          "c" #'go-guru-callers    ; Show callers of this function
          "C" #'go-guru-callees)   ; Show callees of this function
        (:prefix ("ri" . "imports")
          "a" #'go-import-add
          "r" #'go-remove-unused-imports)
        (:prefix ( "b" . "build")
          :desc "go run ." "r" (λ! (compile "go run ."))
          :desc "go build" "b" (λ! (compile "go build"))
          :desc "go clean" "c" (λ! (compile "go clean")))
        (:prefix ("t" . "test")
          "t" #'+go/test-rerun
          "a" #'+go/test-all
          "s" #'+go/test-single
          "n" #'+go/test-nested
          "g" #'go-gen-test-dwim
          "G" #'go-gen-test-all
          "e" #'go-gen-test-exported
          (:prefix ("b" . "bench")
            "s" #'+go/bench-single
            "a" #'+go/bench-all))))

(use-package! gorepl-mode
  :commands gorepl-run-load-current-file)

(use-package! company-go
  :when (featurep! :completion company)
  :unless (featurep! +lsp)
  :after go-mode
  :config
  (set-company-backend! 'go-mode 'company-go)
  (setq company-go-show-annotation t))

(use-package! flycheck-golangci-lint
  :when (featurep! :checkers syntax)
  :hook (go-mode . flycheck-golangci-lint-setup))




;; TODO

; file: .emacs.d/init.el
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "GOPATH"))

(setq-default indent-tabs-mode nil)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(define-key global-map (kbd "RET") 'newline-and-indent)

(setq package-list '(async auto-complete dash
  go-add-tags go-autocomplete go-errcheck go-mode go-playground
  go-rename gotest markdown-mode
  yaml-mode))
(dolist (package package-list)
  (unless (package-installed-p package)
    (message "installing %s..." package)
    (package-install package)))

(defun arvados-gopath ()
  (let ((bfn (buffer-file-name)))
    (setenv "GOPATH"
            (with-temp-buffer
              (call-process "bash" nil t nil "-c"
                            "gp=${GOPATH:-${HOME}/go}; d=${0}; while [[ ${d} != '' ]]; do if [[ -e ${d}/services/keep-web/. ]]; then gp=${d}/tmp/GOPATH; mkdir -p ${gp}/src/git.curoverse.com; ln -sfn ${d} ${gp}/src/git.curoverse.com/arvados.git; break; fi; d=${d%/*}; done; mkdir -p ${gp}; echo -n ${gp}"
                            bfn)
              (buffer-substring (point-min) (point-max))))))

(defun go-mode-omnibus ()
  (let ((gopath (arvados-gopath)))
    (make-local-variable 'process-environment)
    (make-local-variable 'exec-path)
    (add-to-list 'exec-path (concat gopath "/bin"))
    (with-temp-buffer
      (call-process "bash" nil t t "-c" "([[ -x ${1}/bin/gocode ]] && ${1}/bin/goimports -srcdir / /dev/null) || go get -u -v golang.org/x/tools/cmd/... github.com/rogpeppe/godef github.com/nsf/gocode" "-" gopath))
    (auto-complete-mode 1)
                                        ; call gofmt before saving
    (add-hook 'before-save-hook 'gofmt-before-save)
    (setq gofmt-command "goimports")
                                        ; compile with go
    (if (not (string-match "go" compile-command))
        (set (make-local-variable 'compile-command)
             "go build -v && go test -v && go vet"))
                                        ; godef-jump key bindings
    (local-set-key (kbd "M-.") 'godef-jump)
    (local-set-key (kbd "M-*") 'pop-tag-mark)))
(add-hook 'go-mode-hook 'go-mode-omnibus)
