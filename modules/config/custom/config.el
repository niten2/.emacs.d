(set-input-method 'russian-computer)
(toggle-input-method)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(defun y-or-n-p-with-return (orig-func &rest args)
  (let ((query-replace-map (copy-keymap query-replace-map)))
    (define-key query-replace-map (kbd "RET") 'act)
    (apply orig-func args)
  )
)
(advice-add 'y-or-n-p :around #'y-or-n-p-with-return)

(setq user-full-name "niten2" user-mail-address "")

(defvar +default-minibuffer-maps
  `(minibuffer-local-map
    minibuffer-local-ns-map
    minibuffer-local-completion-map
    minibuffer-local-must-match-map
    minibuffer-local-isearch-map
    read-expression-map
    ,@(cond ((featurep! :completion ivy) '(ivy-minibuffer-map ivy-switch-buffer-map))
            ((featurep! :completion helm) '(helm-map helm-ag-map helm-read-file-map)))
    )
)

;;; Reasonable defaults
;;;###package avy
(setq avy-all-windows nil
      avy-all-windows-alt t
      avy-background t
      ;; the unpredictability of this (when enabled) makes it a poor default
      avy-single-candidate-jump nil
)

(after! epa
  ;; With GPG 2.1+, this forces gpg-agent to use the Emacs minibuffer to prompt
  ;; for the key passphrase.
  (setq epa-pinentry-mode 'loopback)
   ;; Default to the first secret key available in your keyring.
  (setq-default
   epa-file-encrypt-to
   (or (default-value 'epa-file-encrypt-to)
       (unless (string-empty-p user-full-name)
         (cl-loop for key in (ignore-errors (epg-list-keys (epg-make-context) user-full-name))
                  collect (epg-sub-key-id (car (epg-key-sub-key-list key)))))
       user-mail-address))
   ;; And suppress prompts if epa-file-encrypt-to has a default value (without
   ;; overwriting file-local values).
  (defadvice! +default--dont-prompt-for-keys-a (&rest _)
    :before #'epa-file-write-region
    (unless (local-variable-p 'epa-file-encrypt-to)
      (setq-local epa-file-encrypt-to (default-value 'epa-file-encrypt-to)))))

(use-package! drag-stuff
  :defer t
  :init
  (map! "<M-up>"    #'drag-stuff-up
        "<M-down>"  #'drag-stuff-down
        "<M-left>"  #'drag-stuff-left
        "<M-right>" #'drag-stuff-right
  )
)


;;; Smartparens config
(when (featurep! +smartparens)
  ;; You can disable :unless predicates with (sp-pair "'" nil :unless nil)
  ;; And disable :post-handlers with (sp-pair "{" nil :post-handlers nil)
  ;; or specific :post-handlers with:
  ;;   (sp-pair "{" nil :post-handlers '(:rem ("| " "SPC")))
  (after! smartparens
    ;; Smartparens' navigation feature is neat, but does not justify how
    ;; expensive it is. It's also less useful for evil users. This may need to
    ;; be reactivated for non-evil users though. Needs more testing!
    (add-hook! 'after-change-major-mode-hook
      (defun doom-disable-smartparens-navigate-skip-match-h ()
        (setq sp-navigate-skip-match nil
              sp-navigate-consider-sgml-tags nil)))

    ;; Autopair quotes more conservatively; if I'm next to a word/before another
    ;; quote, I don't want to open a new pair or it would unbalance them.
    (let ((unless-list '(sp-point-before-word-p
                         sp-point-after-word-p
                         sp-point-before-same-p)))
      (sp-pair "'"  nil :unless unless-list)
      (sp-pair "\"" nil :unless unless-list))

    ;; Expand {|} => { | }
    ;; Expand {|} => {
    ;;   |
    ;; }
    (dolist (brace '("(" "{" "["))
      (sp-pair brace nil
               :post-handlers '(("||\n[i]" "RET") ("| " "SPC"))
               ;; I likely don't want a new pair if adjacent to a word or opening brace
               :unless '(sp-point-before-word-p sp-point-before-same-p)))

    ;; In lisps ( should open a new form if before another parenthesis
    (sp-local-pair sp-lisp-modes "(" ")" :unless '(:rem sp-point-before-same-p))

    ;; Major-mode specific fixes
    (sp-local-pair '(ruby-mode enh-ruby-mode) "{" "}"
                   :pre-handlers '(:rem sp-ruby-pre-handler)
                   :post-handlers '(:rem sp-ruby-post-handler))

    ;; Don't do square-bracket space-expansion where it doesn't make sense to
    (sp-local-pair '(emacs-lisp-mode org-mode markdown-mode gfm-mode)
                   "[" nil :post-handlers '(:rem ("| " "SPC")))

    ;; Reasonable default pairs for HTML-style comments
    (sp-local-pair (append sp--html-modes '(markdown-mode gfm-mode))
                   "<!--" "-->"
                   :unless '(sp-point-before-word-p sp-point-before-same-p)
                   :actions '(insert) :post-handlers '(("| " "SPC")))

    ;; Disable electric keys in C modes because it interferes with smartparens
    ;; and custom bindings. We'll do it ourselves (mostly).
    (after! cc-mode
      (setq-default c-electric-flag nil)
      (dolist (key '("#" "{" "}" "/" "*" ";" "," ":" "(" ")" "\177"))
        (define-key c-mode-base-map key nil))

      ;; Smartparens and cc-mode both try to autoclose angle-brackets
      ;; intelligently. The result isn't very intelligent (causes redundant
      ;; characters), so just do it ourselves.
      (define-key! c++-mode-map "<" nil ">" nil)

      (defun +default-cc-sp-point-is-template-p (id action context)
        "Return t if point is in the right place for C++ angle-brackets."
        (and (sp-in-code-p id action context)
             (cond ((eq action 'insert)
                    (sp-point-after-word-p id action context))
                   ((eq action 'autoskip)
                    (/= (char-before) 32)))))

      (defun +default-cc-sp-point-after-include-p (id action context)
        "Return t if point is in an #include."
        (and (sp-in-code-p id action context)
             (save-excursion
               (goto-char (line-beginning-position))
               (looking-at-p "[ 	]*#include[^<]+"))))

      ;; ...and leave it to smartparens
      (sp-local-pair '(c++-mode objc-mode)
                     "<" ">"
                     :when '(+default-cc-sp-point-is-template-p
                             +default-cc-sp-point-after-include-p)
                     :post-handlers '(("| " "SPC")))

      (sp-local-pair '(c-mode c++-mode objc-mode java-mode)
                     "/*!" "*/"
                     :post-handlers '(("||\n[i]" "RET") ("[d-1]< | " "SPC"))))

    ;; Expand C-style doc comment blocks. Must be done manually because some of
    ;; these languages use specialized (and deferred) parsers, whose state we
    ;; can't access while smartparens is doing its thing.
    (defun +default-expand-asterix-doc-comment-block (&rest _ignored)
      (let ((indent (current-indentation)))
        (newline-and-indent)
        (save-excursion
          (newline)
          (insert (make-string indent 32) " */")
          (delete-char 2))))
    (sp-local-pair
     '(js2-mode typescript-mode rjsx-mode rust-mode c-mode c++-mode objc-mode
       csharp-mode java-mode php-mode css-mode scss-mode less-css-mode
       stylus-mode scala-mode)
     "/*" "*/"
     :actions '(insert)
     :post-handlers '(("| " "SPC")
                      ("|\n[i]*/[d-2]" "RET")
                      (+default-expand-asterix-doc-comment-block "*")))

    (after! smartparens-ml
      (sp-with-modes '(tuareg-mode fsharp-mode)
        (sp-local-pair "(*" "*)" :actions nil)
        (sp-local-pair "(*" "*"
                       :actions '(insert)
                       :post-handlers '(("| " "SPC") ("|[i]*)[d-2]" "RET")))))

    (after! smartparens-markdown
      (sp-with-modes '(markdown-mode gfm-mode)
        (sp-local-pair "```" "```" :post-handlers '(:add ("||\n[i]" "RET")))

        ;; The original rules for smartparens had an odd quirk: inserting two
        ;; asterixex would replace nearby quotes with asterixes. These two rules
        ;; set out to fix this.
        (sp-local-pair "**" nil :actions :rem)
        (sp-local-pair "*" "*"
                       :actions '(insert skip)
                       :unless '(:rem sp-point-at-bol-p)
                       ;; * then SPC will delete the second asterix and assume
                       ;; you wanted a bullet point. * followed by another *
                       ;; will produce an extra, assuming you wanted **|**.
                       :post-handlers '(("[d1]" "SPC") ("|*" "*"))))

      ;; This keybind allows * to skip over **.
      (map! :map markdown-mode-map
            :ig "*" (λ! (if (looking-at-p "\\*\\* *$")
                            (forward-char 2)
                          (call-interactively 'self-insert-command)))))

    ;; Highjacks backspace to:
    ;;  a) balance spaces inside brackets/parentheses ( | ) -> (|)
    ;;  b) delete up to nearest column multiple of `tab-width' at a time
    ;;  c) close empty multiline brace blocks in one step:
    ;;     {
    ;;     |
    ;;     }
    ;;     becomes {|}
    ;;  d) refresh smartparens' :post-handlers, so SPC and RET expansions work
    ;;     even after a backspace.
    ;;  e) properly delete smartparen pairs when they are encountered, without
    ;;     the need for strict mode.
    ;;  f) do none of this when inside a string
    (advice-add #'delete-backward-char :override #'+default--delete-backward-char-a))

  ;; Makes `newline-and-indent' continue comments (and more reliably)
  (advice-add #'newline-and-indent :override #'+default--newline-indent-and-continue-comments-a))

;;; Keybinding fixes
;; This section is dedicated to "fixing" certain keys so that they behave
;; sensibly (and consistently with similar contexts).

;; Consistently use q to quit windows
(after! tabulated-list
  (define-key tabulated-list-mode-map "q" #'quit-window))

(define-key! help-map
  "'"    #'describe-char
  "u"    #'doom/help-autodefs
  ;; "E"    #'doom/sandbox
  "M"    #'doom/describe-active-minor-mode
  "T"    #'doom/toggle-profiler
  "V"    #'set-variable

  ;; "C-l"  #'describe-language-environment
  ;; "C-k"  #'describe-key-briefly
  ;; "W"    #'+default/man-or-woman
  ;; "O"    #'+lookup/online
  ;; "C-m"  #'info-emacs-manual

  ;; Unbind `help-for-help'. Conflicts with which-key's help command for the
  "C-h"  nil

  ;; replacement keybinds
  ;; replaces `info-emacs-manual' b/c it's on C-m now
  "r"    nil
  "rr"   #'doom/reload
  "rt"   #'doom/reload-theme
  "rp"   #'doom/reload-packages
  "rf"   #'doom/reload-font
  "re"   #'doom/reload-env

  ;; make `describe-bindings' available under the b prefix which it previously
  ;; occupied. Add more binding related commands under that prefix as well
  "b"    nil
  "bb"   #'describe-bindings
  "bi"   #'which-key-show-minor-mode-keymap
  "bm"   #'which-key-show-major-mode
  "bt"   #'which-key-show-top-level
  "bf"   #'which-key-show-full-keymap
  "bk"   #'which-key-show-keymap

  ;; replaces `apropos-documentation' b/c `apropos' covers this
  "d"    nil
  "dd"   #'doom/toggle-debug-mode
  "dt"   #'doom/toggle-profiler

  ;; "dm"   #'doom/help-modules
  ;; "du"   #'doom/help-autodefs
  ;; "dv"   #'doom/version
  ;; "dx"   #'doom/sandbox
  ;; "db"   #'doom/report-bug
  ;; "dc"   #'doom/goto-private-config-file
  ;; "dC"   #'doom/goto-private-init-file
  ;; "df"   #'doom/help-faq
  ;; "dh"   #'doom/help
  ;; "dl"   #'doom/help-search-load-path
  ;; "dL"   #'doom/help-search-loaded-files
  ;; "dn"   #'doom/help-news
  ;; "dN"   #'doom/help-news-search
  ;; "dpc"  #'doom/help-package-config
  ;; "dpd"  #'doom/goto-private-packages-file
  ;; "dph"  #'doom/help-package-homepage
  ;; "dpp"  #'doom/help-packages
  ;; "ds"   #'doom/help-search-headings
  ;; "dS"   #'doom/help-search

  ;; replaces `apropos-command'
  "a"    #'apropos
  "A"    #'apropos-documentation

  ;; replaces `describe-copying' b/c not useful
  "C-c"  #'describe-coding-system

  ;; replaces `Info-got-emacs-command-node' b/c redundant w/ `Info-goto-node'
  "F"    #'describe-face

  ;; replaces `describe-package' b/c redundant w/ `doom/help-packages'
  "P"    #'find-library

  "i" #'package-install

  "'" nil
  "." nil
  "4" nil
  "?" nil
  "A" nil
  "C" nil
  "C-a" nil
  "C-c" nil
  "C-d" nil
  "C-e" nil
  "C-f" nil
  "C-n" nil
  "C-o" nil
  "C-p" nil
  "C-t" nil
  "C-w" nil
  "F" nil
  "I" nil
  "K" nil
  "L" nil
  "M" nil
  "P" nil
  "RET" nil
  "S" nil
  "T" nil
  "a" nil
  "c" nil
  "e" nil
  "g" nil
  "h" nil
  "help" nil
  "l" nil
  "m" nil
  "n" nil
  "o" nil
  "o" nil
  "p" nil
  "q" nil
  "s" nil
  "s" nil
  "s" nil
  "t" nil
  "u" nil
  "w" nil

  ;; "p"    #'doom/help-packages
  ;; replaces `view-emacs-news' b/c it's on C-n too
  ;; "n"    #'doom/help-news
  ;; replaces `help-with-tutorial', b/c it's less useful than `load-theme'
  ;; "t"    #'load-theme
  )

(after! which-key
  (let ((prefix-re (regexp-opt (list doom-leader-key doom-leader-alt-key))))
    (cl-pushnew `((,(format "\\`\\(?:<\\(?:\\(?:f1\\|help\\)>\\)\\|C-h\\|%s h\\) d\\'" prefix-re))
                  nil . "doom")
                which-key-replacement-alist)
    (cl-pushnew `((,(format "\\`\\(?:<\\(?:\\(?:f1\\|help\\)>\\)\\|C-h\\|%s h\\) r\\'" prefix-re))
                  nil . "reload")
                which-key-replacement-alist)
    (cl-pushnew `((,(format "\\`\\(?:<\\(?:\\(?:f1\\|help\\)>\\)\\|C-h\\|%s h\\) b\\'" prefix-re))
                  nil . "bindings")
                which-key-replacement-alist)))

(when (featurep! +bindings)
  ;; Make M-x harder to miss
  (define-key! 'override
    "M-x" #'execute-extended-command
    "A-x" #'execute-extended-command)

  ;; A Doom convention where C-s on popups and interactive searches will invoke
  ;; ivy/helm for their superior filtering.
  (define-key! :keymaps +default-minibuffer-maps
    "C-s" (if (featurep! :completion ivy)
              #'counsel-minibuffer-history
              #'helm-minibuffer-history
          )
  )


  ;; Smarter C-a/C-e for both Emacs and Evil. C-a will jump to indentation.
  ;; Pressing it again will send you to the true bol. Same goes for C-e, except
  ;; it will ignore comments+trailing whitespace before jumping to eol.
  (map!
    :gi "C-a" #'doom/backward-to-bol-or-indent
    :gi "C-e" #'doom/forward-to-last-non-comment-or-eol

    ;; Standardizes the behavior of modified RET to match the behavior of
    ;; other editors, particularly Atom, textedit, textmate, and vscode, in
    ;; which ctrl+RET will add a new "item" below the current one and
    ;; cmd+RET (Mac) / meta+RET (elsewhere) will add a new, blank line below
    ;; the current one.
    :gn [C-return]    #'+default/newline-below
    :gn [C-S-return]  #'+default/newline-above
  )
)

(load! "+evil")

(use-package! linum-off)

;;;###package tramp
;; (unless IS-WINDOWS (setq tramp-default-method "ssh")) ; faster than the default scp
