;; "Type of git integration for `treemacs-git-mode'.
;; There are 3 possible values:
;; 1) `simple', which highlights only files based on their git status, and is
;;     slightly faster,
;; 2) `extended', which highlights both files and directories, but requires
;;     python,
;; 3) `deferred', same as extended, but highlights asynchronously.
;; This must be set before `treemacs' has loaded."
(defvar +treemacs-git-mode 'simple)

(use-package! treemacs
  :defer t
  :init
  (setq
    treemacs-follow-after-init t
    treemacs-is-never-other-window t
    treemacs-sorting 'alphabetic-case-insensitive-asc
    treemacs-last-error-persist-file (concat doom-cache-dir "treemacs-last-error-persist")
    treemacs-persist-file (concat doom-cache-dir "treemacs-persist")
    treemacs-show-hidden-files nil
  )
  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode t)

  ;; (linum-mode -1)
  ;; (add-hook 'treemacs-mode (lambda () (linum-mode -1)))

  (after! ace-window (delq! 'treemacs-mode aw-ignored-buffers))

  (when +treemacs-git-mode
    (when (and (memq +treemacs-git-mode '(deferred extended))
               (not (executable-find "python3")))
      (setq +treemacs-git-mode 'simple))
    (treemacs-git-mode +treemacs-git-mode)
    (setq treemacs-collapse-dirs
          (if (memq treemacs-git-mode '(extended deferred))
              3
            0))
  )
)

(use-package! treemacs-evil
  :when (featurep! :editor evil +everywhere)
  :after treemacs
  :config
  (define-key! evil-treemacs-state-map
    [return] #'treemacs-RET-action
    [tab]    #'treemacs-TAB-action
    "TAB"    #'treemacs-TAB-action
    "o v"    #'treemacs-visit-node-horizontal-split
    "o s"    #'treemacs-visit-node-vertical-split
    "z m"    #'treemacs-collapse-all-projects
    "z a"    #'treemacs-toggle-show-dotfiles
    "t h"    nil
    "c a"    #'treemacs-add-project-to-workspace
    "c r"    #'treemacs-rename-project
    "i"      #'treemacs-visit-node-default
    "c d"    #'treemacs-create-dir
    "c r"    #'treemacs-remove-project-from-workspace
    "t k"    #'treemacs-move-project-up
    "t j"    #'treemacs-move-project-down
  )
)

(use-package! treemacs-projectile
  :after treemacs
)

(use-package! treemacs-magit
  :when (featurep! :tools magit)
  :after treemacs magit
)
