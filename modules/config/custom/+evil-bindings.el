(when (featurep! :editor evil +everywhere)
  ;; Minibuffer
  (define-key! evil-ex-completion-map
    "C-a" #'evil-beginning-of-line

    "C-b" #'evil-backward-char
    ;; "C-s" (if (featurep! :completion ivy)
    ;;         #'counsel-minibuffer-history
    ;;         #'helm-minibuffer-history
    ;;       )
    )

  (define-key! :keymaps +default-minibuffer-maps
    "C-a" #'move-beginning-of-line
    "C-u" #'evil-delete-back-to-indentation
    "C-v" #'yank
    "C-w" #'doom/delete-backward-word
    "C-z" (λ! (ignore-errors (call-interactively #'undo)))
    "C-j"  #'next-line
    "C-k"  #'previous-line
    "C-d"  #'scroll-up-command
    "C-p"  #'scroll-down-command
    [escape] #'abort-recursive-edit
    ;; "C-r" #'evil-paste-from-register
    )

  (define-key! read-expression-map
    "C-j" #'next-line-or-history-element
    "C-k" #'previous-line-or-history-element
    )
  )

(define-key global-map (kbd "C-n") nil)
;; (define-key global-map (kbd "K") nil)

;; Smart tab, these will only work in GUI Emacs
(map!
 :i [tab] (general-predicate-dispatch nil ; fall back to nearest keymap
            (and (featurep! :editor snippets)
                 (bound-and-true-p yas-minor-mode)
                 (yas-maybe-expand-abbrev-key-filter 'yas-expand)
                 )
            #'yas-expand
            (and (featurep! :completion company +tng) (+company-has-completion-p)) #'+company/complete
            )

 :n [tab] (general-predicate-dispatch nil
            (and (featurep! :editor fold)
                 (save-excursion (end-of-line) (invisible-p (point))))
            #'+fold/toggle
            (fboundp 'evil-jump-item)
            #'evil-jump-item
            )

 :v [tab] (general-predicate-dispatch nil
            (and (bound-and-true-p yas-minor-mode)
                 (or (eq evil-visual-selection 'line)
                     (not (memq (char-after) (list ?\( ?\[ ?\{ ?\} ?\] ?\))))))
            #'yas-insert-snippet
            (fboundp 'evil-jump-item)
            #'evil-jump-item
            )

 :n "C-j" #'newline-and-indent

 (:after help :map help-mode-map
   :n "o"       #'link-hint-open-link
   )

 (:after helpful :map helpful-mode-map
   :n "o"       #'link-hint-open-link
   )

 (:after info :map Info-mode-map
   :n "o"       #'link-hint-open-link
   )

 (:after apropos :map apropos-mode-map
   :n "o"       #'link-hint-open-link
   :n "TAB"     #'forward-button
   :n [tab]     #'forward-button
   :n [backtab] #'backward-button
   )

 (:after view :map view-mode-map
   [escape]  #'View-quit-all
   )

 ;; (:after man :map Man-mode-map
 ;;   :n "q"    #'kill-current-buffer
 ;; )

 ;; (:after evil-org
 ;;   :map evil-org-mode-map
 ;;   :m "gsh" #'+org/goto-visible
 ;; )

 ;; TODO multiple-cursors
 (:when (featurep! :editor multiple-cursors)
   :prefix "gz"
   :nv "d" #'evil-mc-make-and-goto-next-match
   :nv "D" #'evil-mc-make-and-goto-prev-match

   :nv "j" #'evil-mc-make-cursor-move-next-line
   :nv "k" #'evil-mc-make-cursor-move-prev-line

   :nv "m" #'evil-mc-make-all-cursors

   :nv "n" #'evil-mc-make-and-goto-next-cursor
   :nv "N" #'evil-mc-make-and-goto-last-cursor
   :nv "p" #'evil-mc-make-and-goto-prev-cursor
   :nv "P" #'evil-mc-make-and-goto-first-cursor

   :nv "q" #'evil-mc-undo-all-cursors

   :nv "t" #'+multiple-cursors/evil-mc-toggle-cursors
   :nv "u" #'evil-mc-undo-last-added-cursor
   :nv "z" #'+multiple-cursors/evil-mc-make-cursor-here

   ;; :v  "I" #'evil-mc-make-cursor-in-visual-selection-beg
   ;; :v  "A" #'evil-mc-make-cursor-in-visual-selection-end
   )

 :m "gs"     #'+evil/easymotion  ; lazy-load `evil-easymotion'

 ;; misc
 ;; :n "C-S-f"  #'toggle-frame-fullscreen
 :n "C-+"    #'doom/reset-font-size

 ;; Buffer-local font resizing
 :n "C-="    #'text-scale-increase
 :n "C--"    #'text-scale-decrease

 ;; Frame-local font resizing
 ;; :n "M-C-="  #'doom/increase-font-size
 ;; :n "M-C--"  #'doom/decrease-font-size
 )

;; company
(map!
 (:when (featurep! :completion company)
   :i "C-SPC"    #'+company/complete
   ;; :i "C-@"      #'+company/complete

   (:after company
     (:map company-active-map
       "C-w"     nil  ; don't interfere with `evil-delete-backward-word'
       "TAB"     #'company-complete-common-or-cycle
       [tab]     #'company-complete-common-or-cycle
       [backtab] #'company-select-previous
       [f1]      nil

       "C-j"     #'company-select-next
       "C-k"     #'company-select-previous

       ;; "C-n"     #'company-select-next
       ;; "C-p"     #'company-select-previous
       ;; "C-h"     #'company-show-doc-buffer
       ;; "C-u"     #'company-previous-page
       ;; "C-d"     #'company-next-page
       ;; "C-s"     #'company-filter-candidates
       ;; "C-S-s"   (cond ((featurep! :completion helm) #'helm-company)
       ;;                 ((featurep! :completion ivy)  #'counsel-company)
       ;;           )
       ;; "C-SPC"   #'company-complete-common
       )
     (:map company-search-map  ; applies to `company-filter-map' too
       ;; "C-n"     #'company-select-next-or-abort
       ;; "C-p"     #'company-select-previous-or-abort

       "C-j"     #'company-select-next-or-abort
       "C-k"     #'company-select-previous-or-abort
       "C-s"     (λ! (company-search-abort) (company-filter-candidates))
       [escape]  #'company-search-abort
       )
     )

   ;; TAB auto-completion in term buffers
   (:after comint :map comint-mode-map
     "TAB" #'company-complete
     [tab] #'company-complete
     )
   )

 (:when (featurep! :completion ivy)
   (:after ivy
     :map ivy-minibuffer-map
     "C-SPC" #'ivy-call-and-recenter
     "C-l"   #'ivy-alt-done
     "C-v"   #'yank
     )
   (:after counsel
     :map counsel-ag-map
     "C-SPC"    #'ivy-call-and-recenter
     "C-l"      #'ivy-done
     [C-return] #'+ivy/git-grep-other-window-action
     )
   )

 ;; (:when (featurep! :completion helm)
 ;;   (:after helm :map helm-map
 ;;     [left]     #'left-char
 ;;     [right]    #'right-char
 ;;     "C-S-f"    #'helm-previous-page
 ;;     "C-S-n"    #'helm-next-source
 ;;     "C-S-p"    #'helm-previous-source
 ;;     "C-S-j"    #'helm-next-source
 ;;     "C-S-k"    #'helm-previous-source
 ;;     "C-j"      #'helm-next-line
 ;;     "C-k"      #'helm-previous-line
 ;;     "C-u"      #'helm-delete-minibuffer-contents
 ;;     "C-s"      #'helm-minibuffer-history

 ;;     ;; Swap TAB and C-z
 ;;     "TAB"      #'helm-execute-persistent-action
 ;;     [tab]      #'helm-execute-persistent-action
 ;;     "C-z"      #'helm-select-action)
 ;;   (:after helm-ag :map helm-ag-map
 ;;     "C--"      #'+helm-do-ag-decrease-context
 ;;     "C-="      #'+helm-do-ag-increase-context
 ;;     [left]     nil
 ;;     [right]    nil)
 ;;   (:after helm-files :map (helm-find-files-map helm-read-file-map)
 ;;     [C-return] #'helm-ff-run-switch-other-window
 ;;     "C-w"      #'helm-find-files-up-one-level)
 ;;   (:after helm-locate :map helm-generic-files-map
 ;;     [C-return] #'helm-ff-run-switch-other-window)
 ;;   (:after helm-buffers :map helm-buffer-map
 ;;     [C-return] #'helm-buffer-switch-other-window)
 ;;   (:after helm-occur :map helm-occur-map
 ;;     [C-return] #'helm-occur-run-goto-line-ow)
 ;;   (:after helm-grep :map helm-grep-map
 ;;     [C-return] #'helm-grep-run-other-window-action)
 ;; )
 )

;;; <leader>
(map! :leader
      :desc "help" "h" help-map
      :desc "window" "w" evil-window-map
      :desc "M-x" "SPC" #'execute-extended-command
      :desc "bookmark-jump" "RET"  #'bookmark-jump

      :desc "+workspace/switch-right" "]" #'+workspace/switch-right
      :desc "+workspace/switch-left" "[" #'+workspace/switch-left

      :desc "+workspace/switch-right" "9" #'+workspace/swap-left
      :desc "+workspace/switch-left" "0" #'+workspace/swap-right

      :desc "search-project" "/" #'+default/search-project
      :desc "search-project-for-symbol-at-point" "." #'+default/search-project-for-symbol-at-point

      ;; :desc "Switch to last buffer" "`" #'evil-switch-to-windows-last-buffer
      ;; :desc "Eval expression" ";"    #'pp-eval-expression
      ;; :desc "Universal argument" "u" #'universal-argument
      ;; :desc "Find file" "."    #'find-file
      ;; :desc "Find file in project"  "SPC"  #'projectile-find-file
      ;; :desc "M-x"                   ":"    #'execute-extended-command
      ;; :desc "Pop up scratch buffer" "x"    #'doom/open-scratch-buffer
      ;; :desc "Org Capture"           "X"    #'org-capture
      ;; :desc "Switch buffer"         ","    #'switch-to-buffer
      ;; :desc "Resume last search"    "'"

      (:when (featurep! :ui workspaces)
        (:prefix-map ("l" . "workspace")
          :desc "Switch to 1st workspace" "1"   #'+workspace/switch-to-0
          :desc "Switch to 2nd workspace" "2"   #'+workspace/switch-to-1
          :desc "Switch to 3rd workspace" "3"   #'+workspace/switch-to-2
          :desc "Switch to 4th workspace" "4"   #'+workspace/switch-to-3
          :desc "Switch to 5th workspace" "5"   #'+workspace/switch-to-4
          :desc "Switch to 6th workspace" "6"   #'+workspace/switch-to-5
          :desc "Switch to 7th workspace" "7"   #'+workspace/switch-to-6
          :desc "Switch to 8th workspace" "8"   #'+workspace/switch-to-7
          :desc "Switch to 9th workspace" "9"   #'+workspace/switch-to-8
          :desc "Switch to final workspace" "0"   #'+workspace/switch-to-final

          :desc "+workspace/display"           "g" #'+workspace/display

          :desc "+workspace/new" "n"   #'+workspace/new-c

          :desc "+workspace/rename" "r"   #'+workspace/rename
          :desc "+workspace/delete"     "d"   #'+workspace/delete
          :desc "+workspace/swap-left" "<" #'+workspace/swap-left
          :desc "+workspace/swap-right" ">" #'+workspace/swap-right


          ;; :desc "Next workspace"            "]"   #'+workspace/switch-right
          ;; :desc "Previous workspace"        "["   #'+workspace/switch-left
          ;; :desc "Delete session"            "x"   #'+workspace/kill-session
          ;; :desc "Restore last session"      "R"   #'+workspace/restore-last-session
          ;; :desc "Load workspace from file"  "l"   #'+workspace/load
          ;; :desc "Save workspace to file"    "s"   #'+workspace/save
          ;; :desc "Switch workspace"          "."   #'+workspace/switch-to
          ;; :desc "Switch to last workspace"  "`"   #'+workspace/other
          )
        )

      (:prefix-map ("b" . "buffer")
        :desc "Revert buffer" "r" #'revert-buffer
        :desc "Switch workspace buffer" "B" #'persp-switch-to-buffer
        :desc "Switch buffer" "b" #'switch-to-buffer
        :desc "Next buffer" "l" #'next-buffer
        :desc "Previous buffer" "h" #'previous-buffer
        :desc "doom/open-scratch-buffer" "s" #'doom/open-scratch-buffer
        :desc "bookmark-set" "m" #'bookmark-set
        :desc "bookmark-delete" "M" #'bookmark-delete
        :desc "Save all buffers" "S" #'evil-write-all
        :desc "Save buffer as root" "u" #'doom/sudo-save-buffer
        :desc "ibuffer" "i" #'ibuffer
        :desc "kill-current-buffer" "d" #'kill-current-buffer
        :desc "doom/kill-all-buffers" "D" #'doom/kill-all-buffers
        :desc "format-all-buffer" "f" #'format-all-buffer

        ;; :desc "New empty buffer" "N"   #'evil-buffer-new
        ;; :desc "Switch to last buffer"       "l"   #'evil-switch-to-windows-last-buffer
        ;; :desc "Kill all buffers"            "D"   #'doom/kill-all-buffers
        ;; :desc "Kill other buffers"          "O"   #'doom/kill-other-buffers
        ;; :desc "Toggle narrowing" "-" #'doom/toggle-narrow-buffer
        ;; :desc "Previous buffer"             "["   #'previous-buffer
        ;; :desc "Next buffer"                 "]"   #'next-buffer
        ;; :desc "Kill buffer"                 "k"   #'kill-current-buffer
        ;; :desc "Save buffer"                 "s"   #'basic-save-buffer
        ;; :desc "Pop up scratch buffer"       "x"   #'doom/open-scratch-buffer
        ;; :desc "Switch to scratch buffer"    "X"   #'doom/switch-to-scratch-buffer
        ;; :desc "Bury buffer"                 "z"   #'bury-buffer
        ;; :desc "Kill buried buffers"         "Z"   #'doom/kill-buried-buffers
        )

      (:prefix-map ("c" . "code")
        :desc "List errors" "x" #'flycheck-list-errors
        :desc "docker" "d" #'docker
        :desc "docker-compose" "c" #'docker-compose

        ;; :desc "LSP Execute code action"               "a"   #'lsp-execute-code-action
        ;; :desc "Jump to definition"                    "d"   #'+lookup/definition
        ;; :desc "Jump to references"                    "D"   #'+lookup/references

        ;; :desc "Evaluate buffer/region"                "e"   #'+eval/buffer-or-region
        ;; :desc "Evaluate & replace region"             "E"   #'+eval:replace-region
        ;; :desc "Format buffer/region"                  "f"   #'+format/region-or-buffer
        ;; :desc "LSP Format buffer/region"              "F"   #'+default/lsp-format-region-or-buffer
        ;; :desc "LSP Organize imports"                  "i"   #'lsp-organize-imports

        ;; (:when (featurep! :completion ivy)
        ;;   :desc "Jump to symbol in current workspace" "j"   #'lsp-ivy-workspace-symbol
        ;;   :desc "Jump to symbol in any workspace"     "J"   #'lsp-ivy-global-workspace-symbol
        ;; )


        ;; (:when (featurep! :completion helm)
        ;;   :desc "Jump to symbol in current workspace" "j"   #'helm-lsp-workspace-symbol
        ;;   :desc "Jump to symbol in any workspace"     "J"   #'helm-lsp-global-workspace-symbol
        ;; )

        ;; :desc "Compile"                               "c"   #'compile
        ;; :desc "Recompile"                             "C"   #'recompile
        ;; :desc "Jump to documentation"                 "k"   #'+lookup/documentation
        ;; :desc "LSP Rename"                            "r"   #'lsp-rename
        ;; :desc "Send to repl"                          "s"   #'+eval/send-region-to-repl
        ;; :desc "Delete trailing whitespace"            "w"   #'delete-trailing-whitespace
        ;; :desc "Delete trailing newlines"              "W"   #'doom/delete-trailing-newlines
        ;; :desc "List errors"                           "x"   #'flymake-show-diagnostics-buffer
        )

      (:prefix-map ("f" . "file")
        :desc "Recent files" "r"   #'recentf-open-files
        :desc "Yank filename" "y"   #'+default/yank-buffer-filename

        ;; :desc "Locate file" "l"   #'locate
        ;; :desc "Find directory"              "d"   #'dired
        ;; :desc "Open project editorconfig"   "c"   #'editorconfig-find-current-editorconfig
        ;; :desc "Sudo find file"              "u"   #'doom/sudo-find-file
        ;; :desc "Sudo this file"              "U"   #'doom/sudo-this-file
        ;; :desc "Jump to bookmark" "b"  #'bookmark-jump
        ;; :desc "Find file"                   "f"   #'find-file
        ;; :desc "Rename/move file"            "R"   #'doom/move-this-file
        ;; :desc "Copy this file"              "C"   #'doom/copy-this-file
        ;; :desc "Delete this file"            "D"   #'doom/delete-this-file
        ;; :desc "Find file in emacs.d"        "e"   #'+default/find-in-emacsd
        ;; :desc "Find file from here"         "F"   #'+default/find-file-under-here
        ;; :desc "Find file in private config" "p"   #'doom/find-file-in-private-config
        ;; :desc "Browse private config"       "P"   #'doom/open-private-config
        ;; :desc "Browse emacs.d"              "E"   #'+default/browse-emacsd
        ;; :desc "Save file"                   "s"   #'save-buffer
        ;; :desc "Save file as..."             "S"   #'write-file
        )

      (:prefix-map ("g" . "git")
        :desc "Revert file" "r"   #'vc-revert
        :desc "Magit status" "s" #'magit-status
        :desc "Magit switch branch" "c" #'magit-branch-checkout
        :desc "Magit fetch" "f" #'magit-fetch
        :desc "Copy link to remote" "y"   #'+vc/browse-at-remote-kill-file-or-region
        :desc "Magit dispatch" "/"   #'magit-dispatch

        (:prefix-map ("b" . "blame")
          :desc "magit-blame-addition" "b" #'magit-blame-addition
          :desc "magit-blame-quit" "q" #'magit-blame-quit
          )

        (:prefix ("o" . "open in browser")
          :desc "Browse file or region"     "o"   #'browse-at-remote
          :desc "Browse commit"             "c"   #'forge-browse-commit
          ;; :desc "Browse homepage"           "h"   #'+vc/browse-at-remote-homepage
          ;; :desc "Browse remote"             "r"   #'forge-browse-remote
          ;; :desc "Browse an issue"           "i"   #'forge-browse-issue
          ;; :desc "Browse a pull request"     "p"   #'forge-browse-pullreq
          ;; :desc "Browse issues"             "I"   #'forge-browse-issues
          ;; :desc "Browse pull requests"      "P"   #'forge-browse-pullreqs
          )

        ;; :desc "Copy link to homepage" "Y"   #'+vc/browse-at-remote-kill-homepage
        ;; :desc "Forge dispatch"            "'"   #'forge-dispatch
        ;; :desc "Magit file delete"         "D"   #'magit-file-delete
        ;; :desc "Magit clone"               "C"   #'magit-clone
        ;; :desc "Magit buffer log"          "L"   #'magit-log
        ;; :desc "Git stage file"            "S"   #'magit-stage-file
        ;; :desc "Git unstage file"          "U"   #'magit-unstage-file

        ;; (:prefix ("f" . "find")
        ;;   :desc "Find file"                 "f"   #'magit-find-file
        ;;   :desc "Find gitconfig file"       "g"   #'magit-find-git-config-file
        ;;   :desc "Find commit"               "c"   #'magit-show-commit
        ;;   :desc "Find issue"                "i"   #'forge-visit-issue
        ;;   :desc "Find pull request"         "p"   #'forge-visit-pullreq
        ;; )

        ;; (:prefix ("l" . "list")
        ;;   (:when (featurep! :tools gist)
        ;;     :desc "List gists"              "g"   #'+gist:list
        ;;   )
        ;;   :desc "List repositories"         "r"   #'magit-list-repositories
        ;;   :desc "List submodules"           "s"   #'magit-list-submodules
        ;;   :desc "List issues"               "i"   #'forge-list-issues
        ;;   :desc "List pull requests"        "p"   #'forge-list-pullreqs
        ;;   :desc "List notifications"        "n"   #'forge-list-notifications
        ;; )

        ;; (:prefix ("c" . "create")
        ;;   :desc "Initialize repo"           "r"   #'magit-init
        ;;   :desc "Clone repo"                "R"   #'magit-clone
        ;;   :desc "Commit"                    "c"   #'magit-commit-create
        ;;   :desc "Fixup"                     "f"   #'magit-commit-fixup
        ;;   :desc "Branch"                    "b"   #'magit-branch-and-checkout
        ;;   :desc "Issue"                     "i"   #'forge-create-issue
        ;;   :desc "Pull request"              "p"   #'forge-create-pullreq)
        ;; )

        ;; (:when (featurep! :ui hydra)
        ;;   :desc "SMerge"                    "m"   #'+vc/smerge-hydra/body
        ;; )

        ;; (:when (featurep! :ui vc-gutter)
        ;;   (:when (featurep! :ui hydra)
        ;;     :desc "VCGutter"                "."   #'+vc/gutter-hydra/body
        ;;   )
        ;;   :desc "Revert hunk"               "r"   #'git-gutter:revert-hunk
        ;;   :desc "Git stage hunk"            "s"   #'git-gutter:stage-hunk
        ;;   :desc "Git time machine"          "t"   #'git-timemachine-toggle
        ;;   :desc "Jump to next hunk"         "]"   #'git-gutter:next-hunk
        ;;   :desc "Jump to previous hunk"     "["   #'git-gutter:previous-hunk
        ;; )
        )

      (:prefix-map ("p" . "project")
        :desc "projectile-dired" "d" #'projectile-dired
        :desc "projectile-ibuffer" "i" #'projectile-ibuffer
        :desc "projectile-find-file" "f" #'projectile-find-file
        :desc "projectile-replace-regexp" "r" #'projectile-replace-regexp
        :desc "doom/kill-other-buffers" "k" #'doom/kill-other-buffers
        :desc "projectile-invalidate-cache" "c" #'projectile-invalidate-cache

        ;; :desc "projectile-switch-to-buffer" "b" #'projectile-switch-to-buffer
        ;; :desc "projectile-switch-project" "p" #'projectile-switch-project
        ;; :desc "Find file in project" "k" #'projectile-kill-buffers

        (:when (featurep! :ui treemacs)
          :desc "Treemacs" "t" #'treemacs
          ;; :desc "Treemacs" "t" #'+treemacs/toggle
          ;; :desc "Find file in project sidebar" "g" #'+treemacs/find-file
          )

        ;; :desc "package-install"     "g" #'centaur-tabs-counsel-group
        ;; :desc "Browse project"               "." #'+default/browse-project
        ;; :desc "Browse other project"         ">" #'doom/browse-in-other-project
        ;; :desc "Run cmd in project root"      "!" #'projectile-run-shell-command-in-root
        ;; :desc "Add new project"              "a" #'projectile-add-known-project
        ;; :desc "Compile in project"           "c" #'projectile-compile-project
        ;; :desc "Repeat last command"          "C" #'projectile-repeat-last-command
        ;; :desc "Remove known project"         "d" #'projectile-remove-known-project
        ;; :desc "Discover projects in folder"  "D" #'+default/discover-projects
        ;; :desc "Edit project .dir-locals"     "e" #'projectile-edit-dir-locals
        ;; :desc "Find file in other project"   "F" #'doom/find-file-in-other-project
        ;; :desc "Configure project"            "g" #'projectile-configure-project
        ;; :desc "Invalidate project cache"     "i" #'projectile-invalidate-cache
        ;; :desc "Kill project buffers"         "k" #'projectile-kill-buffers
        ;; :desc "Find other file"              "o" #'projectile-find-other-file
        ;; :desc "Find recent project files"    "r" #'projectile-recentf
        ;; :desc "Run project"                  "R" #'projectile-run-project
        ;; :desc "Save project files"           "s" #'projectile-save-project-buffers
        ;; :desc "Pop up scratch buffer"        "x" #'doom/open-project-scratch-buffer
        ;; :desc "Switch to scratch buffer"     "X" #'doom/switch-to-project-scratch-buffer
        ;; :desc "List project tasks"           "t" #'magit-todos-list
        ;; :desc "Test project"                 "T" #'projectile-test-project
        )

      (:prefix-map ("q" . "quit/session")
        :desc "Quit Emacs" "q" #'save-buffers-kill-terminal
        :desc "doom/save-session" "s" #'doom/save-session
        :desc "doom/load-session" "l" #'doom/load-session
        :desc "doom/restart" "r" #'doom/restart
        ;; :desc "doom/kill-all-buffers" "F" #'doom/kill-all-buffers
        ;; :desc "Kill Emacs (and daemon)"      "k" #'save-buffers-kill-emacs
        ;; :desc "Delete frame"                 "f" #'delete-frame
        ;; :desc "Restart emacs server"         "d" #'+default/restart-server
        ;; :desc "Restart & restore Emacs"      "r" #'doom/restart-and-restore
        ;; :desc "Quit Emacs without saving"    "Q" #'evil-quit-all-with-error-code
        ;; :desc "Quick save current session"   "s" #'doom/quicksave-session
        ;; :desc "Restore last session"         "l" #'doom/quickload-session

        )

      (:prefix-map ("s" . "search")
        :desc "Clear search" "c" #'evil-ex-nohighlight
        :desc "projectile-ripgrep" "p" #'projectile-ripgrep
        :desc "projectile-ripgrep" "s" #'projectile-find-file
        :desc "projectile-ripgrep" "r" #'projectile-replace-regexp

        ;; TODO
        ;; :desc "Search buffer"                "b" #'swiper
        ;; :desc "Search current directory"     "d" #'+default/search-cwd
        ;; :desc "Search other directory"       "D" #'+default/search-other-cwd
        ;; :desc "Jump to symbol"               "i" #'imenu
        ;; :desc "Jump to visible link"         "l" #'link-hint-open-link
        ;; :desc "Jump to link"                 "L" #'ffap-menu
        ;; :desc "Jump list"                    "j" #'evil-show-jumps
        ;; :desc "Search other project"         "P" #'+default/search-other-project
        ;; :desc "Jump to mark"                 "r" #'evil-show-marks
        ;; :desc "Search buffer"                "s" #'swiper-isearch
        ;; :desc "Search buffer for thing at point" "S" #'swiper-isearch-thing-at-point

        ;; :desc "Search project"               "p" #'+default/search-project
        ;; :desc "Jump to bookmark"             "m" #'bookmark-jump
        ;; :desc "Locate file"                  "f" #'locate
        ;; :desc "Look up online"               "o" #'+lookup/online
        ;; :desc "Look up online (w/ prompt)"   "O" #'+lookup/online-select
        ;; :desc "Look up in local docsets"     "k" #'+lookup/in-docsets
        ;; :desc "Look up in all docsets"       "K" #'+lookup/in-all-docsets
        ;; :desc "Dictionary"                   "t" #'+lookup/dictionary-definition
        ;; :desc "Thesaurus"                    "T" #'+lookup/synonyms
        )

      (:prefix-map ("t" . "toggle")
        :desc "Big mode"                     "b" #'doom-big-font-mode
        :desc "Flymake"                      "f" #'flymake-mode
        :desc "Indent style"                 "I" #'doom/toggle-indent-style
        :desc "Soft line wrapping"           "w" #'visual-line-mode
        :desc "ispell-change-dictionary"           "d" #'ispell-change-dictionary
        :desc "Line numbers" "l" #'linum-mode
        :desc "load-theme" "t" #'load-theme

        (:when (featurep! :checkers syntax)
          :desc "Flycheck"                   "f" #'flycheck-mode
          )
        (:when (featurep! :ui indent-guides)
          :desc "Indent guides"              "i" #'highlight-indent-guides-mode
          )
        (:when (featurep! :checkers spell)
          :desc "Flyspell"                   "s" #'flyspell-mode
          )
        (:when (featurep! :ui word-wrap)
          :desc "Soft line wrapping"         "w" #'+word-wrap-mode
          )
        (:prefix-map ("h" . "hs-hide-level")
          :desc "hs-hide-level 1" "1" (lambda () (interactive) (hs-hide-level 1) (forward-sexp 1))
          :desc "hs-hide-level 2" "2" (lambda () (interactive) (hs-hide-level 2) (forward-sexp 2))
          :desc "hs-hide-level 3" "3" (lambda () (interactive) (hs-hide-level 3) (forward-sexp 3))
          :desc "hs-hide-level 4" "4" (lambda () (interactive) (hs-hide-level 4) (forward-sexp 4))
          )

        ;; :desc "Evil goggles"                 "g" #'evil-goggles-mode
        ;; (:when (featurep! :lang org +present)
        ;;   :desc "org-tree-slide mode"        "p" #'org-tree-slide-mode
        ;; )
        ;; (:when (featurep! :lang org +pomodoro)
        ;;   :desc "Pomodoro timer"             "t" #'org-pomodoro
        ;; )
        ;; :desc "Zen mode"                     "z" #'writeroom-mode
        ;; :desc "Frame fullscreen"             "F" #'toggle-frame-fullscreen
        ;; :desc "Read-only mode"               "r" #'read-only-mode
        ;; :desc "Line numbers"                 "l" #'doom/toggle-line-numbers
        )

      ;; (:when (featurep! :tools upload)
      ;;   (:prefix-map ("r" . "remote")
      ;;     :desc "Upload local"               "u" #'ssh-deploy-upload-handler
      ;;     :desc "Upload local (force)"       "U" #'ssh-deploy-upload-handler-forced
      ;;     :desc "Download remote"            "d" #'ssh-deploy-download-handler
      ;;     :desc "Diff local & remote"        "D" #'ssh-deploy-diff-handler
      ;;     :desc "Browse remote files"        "." #'ssh-deploy-browse-remote-handler
      ;;     :desc "Detect remote changes"      ">" #'ssh-deploy-remote-changes-handler
      ;;   )
      ;; )

      ;; (:prefix-map ("n" . "notes")
      ;; :desc "Search notes for symbol"      "*" #'+default/search-notes-for-symbol-at-point
      ;; :desc "Org agenda"                   "a" #'org-agenda
      ;; :desc "Toggle org-clock"             "c" #'+org/toggle-clock
      ;; :desc "Cancel org-clock"             "C" #'org-clock-cancel
      ;; :desc "Open deft"                    "d" #'deft
      ;; :desc "Find file in notes"           "f" #'+default/find-in-notes
      ;; :desc "Browse notes"                 "F" #'+default/browse-notes
      ;; :desc "Org store link"               "l" #'org-store-link
      ;; :desc "Tags search"                  "m" #'org-tags-view
      ;; :desc "Org capture"                  "n" #'org-capture
      ;; :desc "Active org-clock"             "o" #'org-clock-goto
      ;; :desc "Todo list"                    "t" #'org-todo-list
      ;; :desc "Search notes"                 "s" #'+default/org-notes-search
      ;; :desc "Search org agenda headlines"  "S" #'+default/org-notes-headlines
      ;; :desc "View search"                  "v" #'org-search-view
      ;; :desc "Org export to clipboard"        "y" #'+org/export-to-clipboard
      ;; :desc "Org export to clipboard as RTF" "Y" #'+org/export-to-clipboard-as-rich-text

      ;; (:when (featurep! :lang org +journal)
      ;;   (:prefix ("j" . "journal")
      ;;     :desc "New Entry"      "j" #'org-journal-new-entry
      ;;     :desc "Search Forever" "s" #'org-journal-search-forever)))

      ;; (:prefix-map ("o" . "open")
      ;;   :desc "Start debugger"     "d"  #'+debugger/start
      ;;   :desc "REPL"               "r"  #'+eval/open-repl-other-window
      ;;   :desc "REPL (same window)" "R"  #'+eval/open-repl-same-window

      ;;   :desc "Org agenda"       "A"  #'org-agenda
      ;;   (:prefix ("a" . "org agenda")
      ;;     :desc "Agenda"         "a"  #'org-agenda
      ;;     :desc "Todo list"      "t"  #'org-todo-list
      ;;     :desc "Tags search"    "m"  #'org-tags-view
      ;;     :desc "View search"    "v"  #'org-search-view
      ;;   )

      ;;   :desc "Default browser"    "b"  #'browse-url-of-file
      ;;   :desc "New frame"          "f"  #'make-frame
      ;;   :desc "Dired"              "-"  #'dired-jump
      ;; )

      ;; (:when (featurep! :ui neotree)
      ;;   :desc "Project sidebar"              "p" #'+neotree/open
      ;;   :desc "Find file in project sidebar" "P" #'+neotree/find-this-file)

      ;; (:when (featurep! :ui treemacs)
      ;;   :desc "Project sidebar" "p" #'+treemacs/toggle
      ;;   :desc "Find file in project sidebar" "P" #'+treemacs/find-file
      ;;   )

      ;; (:when (featurep! :term shell)
      ;;   :desc "Toggle shell popup"    "t" #'+shell/toggle
      ;;   :desc "Open shell here"       "T" #'+shell/here)

      ;; (:when (featurep! :term term)
      ;;   :desc "Toggle terminal popup" "t" #'+term/toggle
      ;;   :desc "Open terminal here"    "T" #'+term/here)

      ;; (:when (featurep! :term vterm)
      ;;   :desc "Toggle vterm popup"    "t" #'+vterm/toggle
      ;;   :desc "Open vterm here"       "T" #'+vterm/here)

      ;; (:when (featurep! :term eshell)
      ;;   :desc "Toggle eshell popup"   "e" #'+eshell/toggle
      ;;   :desc "Open eshell here"      "E" #'+eshell/here)

      ;; (:when (featurep! :tools macos)
      ;;   :desc "Reveal in Finder"           "o" #'+macos/reveal-in-finder
      ;;   :desc "Reveal project in Finder"   "O" #'+macos/reveal-project-in-finder
      ;;   :desc "Send to Transmit"           "u" #'+macos/send-to-transmit
      ;;   :desc "Send project to Transmit"   "U" #'+macos/send-project-to-transmit
      ;;   :desc "Send to Launchbar"          "l" #'+macos/send-to-launchbar
      ;;   :desc "Send project to Launchbar"  "L" #'+macos/send-project-to-launchbar)

      ;; (:when (featurep! :tools docker)
      ;;   :desc "Docker" "D" #'docker))
      ;; (:when (featurep! :ui popup)
      ;;   :desc "Toggle last popup"     "~"    #'+popup/toggle
      ;; )

      ;; (:when (featurep! :ui workspaces)
      ;;   :desc "Switch workspace buffer" "," #'persp-switch-to-buffer
      ;;   :desc "Switch buffer"           "<" #'switch-to-buffer
      ;; )

                                        ; (cond
                                        ;   ((featurep! :completion ivy) #'ivy-resume)
                                        ;   ((featurep! :completion helm)  #'helm-resume)
                                        ; )

      ;; (:prefix-map ("i" . "insert")
      ;;   :desc "Current file name"             "f"   #'+default/insert-file-path
      ;;   :desc "Current file path"             "F"   (λ!! #'+default/insert-file-path t)
      ;;   :desc "Evil ex path"                  "p"   (λ! (evil-ex "R!echo "))
      ;;   :desc "From evil register"            "r"   #'evil-ex-registers
      ;;   :desc "Snippet"                       "s"   #'yas-insert-snippet
      ;;   :desc "Unicode"                       "u"   #'unicode-chars-list-chars
      ;;   :desc "From clipboard"                "y"   #'+default/yank-pop
      ;; )

      )

(after! which-key
  (let ((prefix-re (regexp-opt (list doom-leader-key doom-leader-alt-key))))
    (cl-pushnew `((,(format "\\`\\(?:C-w\\|%s w\\) m\\'" prefix-re))
                  nil . "maximize")
                which-key-replacement-alist)))

;; (map!
;;   (:when (featurep! :ui popup)
;;     :n "C-`"   #'+popup/toggle
;;     :n "C-~"   #'+popup/raise
;;     :g "C-x p" #'+popup/other
;;   )
;; )

;; (map!
;; (:when (featurep! :editor format)
;;   :n "gQ" #'+format:region
;; )

;; (:when (featurep! :editor snippets)
;;   ;; auto-yasnippet
;;   :i  [C-tab] #'aya-expand
;;   :nv [C-tab] #'aya-create
;; )

;; (:when (featurep! :editor rotate-text)
;;   :n "!"  #'rotate-text
;; )

;; (:when (featurep! :editor multiple-cursors)
;;   ;; evil-multiedit
;;   :v  "R"     #'evil-multiedit-match-all
;;   :n  "M-d"   #'evil-multiedit-match-symbol-and-next
;;   :n  "M-D"   #'evil-multiedit-match-symbol-and-prev
;;   :v  "M-d"   #'evil-multiedit-match-and-next
;;   :v  "M-D"   #'evil-multiedit-match-and-prev
;;   :nv "C-M-d" #'evil-multiedit-restore
;;   (:after evil-multiedit

;;     (:map evil-multiedit-state-map
;;       "M-d"    #'evil-multiedit-match-and-next
;;       "M-D"    #'evil-multiedit-match-and-prev
;;       "RET"    #'evil-multiedit-toggle-or-restrict-region
;;       [return] #'evil-multiedit-toggle-or-restrict-region
;;     )
;;   )
;; )
;; )

;; (when (featurep! :tools eval) (map! "M-r" #'+eval/buffer))

;; NOTE custom commands
(global-set-key (kbd "C-a") 'mark-whole-buffer)
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-l") 'evil-window-mru)
(global-set-key (kbd "M-b") 'other-window)

(defun evil-next-line-c () (interactive) (evil-next-line) (+workspace/display))
(defun evil-previous-line-c () (interactive) (evil-previous-line) (+workspace/display))
(defun +workspace/new-c () (interactive) (+workspace/new) (treemacs))

(evil-define-key 'normal 'global (kbd "j") 'evil-next-line-c)
(evil-define-key 'normal 'global (kbd "k") 'evil-previous-line-c)
