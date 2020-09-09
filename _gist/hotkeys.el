https://www.gnu.org/software/emacs/manual/html_node/elisp/index.html
https://learnxinyminutes.com/docs/elisp/

;; ;; (use-package centaur-tabs :demand :config (centaur-tabs-mode t))
;; (setq centaur-tabs-cycle-scope 'tabs)
;; (setq centaur-tabs-set-icons t)
;; (setq centaur-tabs-set-close-button nil)
;; (setq centaur-tabs-set-modified-marker t)
;; (setq centaur-tabs-group-by-projectile-project t)
;; (defun centaur-tabs-hide-tab (x)
;;   (let ((name (format "%s" x)))
;;     (or
;;      (string-prefix-p "*Messages" name)
;;      (string-prefix-p "*Quail" name)
;;      (string-prefix-p "*epc" name)
;;      (string-prefix-p "*helm" name)
;;      (string-prefix-p "*Compile-Log*" name)
;;      (string-prefix-p "*lsp" name)
;;      (and (string-prefix-p "magit" name)
;;           (not (file-name-extension name)))
;;      )
;;   )
;; )


; (kill-buffer "*scratch*")
; (global-company-mode t)

;; (setq org-directory "~/org/")

;; Here are some additional functions/macros that could help you configure Doom:
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;;
; (spacemacs/set-leader-keys "SPC" 'helm-M-x)
; (global-set-key (kbd "S-h") 'evil-window-left)
; (setq markdown-fontify-code-blocks-natively t) ;; syntax markdown mode
; (setq vc-follow-symlinks t)
; (setq global-display-line-numbers-mode t)
; (setq projectile-completion-system 'helm)
; (setq tab-width 2)
; (setq c-basic-offset 2)

; TODO
; (with-eval-after-load "treemacs-projectile" (
;   (treemacs-do-add-project-to-workspace "~/_link/dotfiles" "dotfiles")
;   (treemacs-do-add-project-to-workspace "~/_link/data_science" "data_science")
;   (treemacs-do-add-project-to-workspace "~/.emacs.d" "emacs.d")
; ))


;; (desktop-save-mode 1)
;; (savehist-mode 1)
;; (add-to-list 'savehist-additional-variables 'kill-ring)
;;
;; (dired "/home/thomp/acad")



;; (modify-syntax-entry ?_ "w")

; (defun module/misc/yasnippet ()
;   "Yassnippet bindings and config."
;   (use-package yasnippet-snippet
;     :defer t
;     :config
;     (push 'yas-installed-snippets-dir yas-snippet-dirs)
;   )
; )



(add-hook 'emacs-startup-hook
  (lambda ()
    (setq gc-cons-threshold 16777216 ; 16mb
          gc-cons-percentage 0.1)))


~map!~
~define-key~,
~global-set-key~,
~local-set-key~
~evil-define-key~


git pull
doom sync
doom update

(package! example)


(setq-hook! 'python-mode-hook python-indent-offset 2)
(setq-hook! python-mode python-indent-offset 2)


checkout default conf


describe-variable (SPC h v)
describe-function (SPC h f)
describe-face (SPC h F)
describe-bindings (SPC h b)
describe-key (SPC h k)
describe-char (=SPC h ‘=)
find-library (SPC h P)

define-key
global-set-key
map!
unmap!
define-key!



;;; ui/doom-quit/config.el -*- lexical-binding: t; -*-

(defvar +doom-quit-messages
  '(;; from Doom 1
    "You are *not* prepared!")
  "A list of quit messages, picked randomly by `+doom-quit'. Taken from
http://doom.wikia.com/wiki/Quit_messages and elsewhere.")

(defun +doom-quit-fn (&rest _)
  (doom-quit-p
   (format "%s  Quit?"
           (nth (random (length +doom-quit-messages))
                +doom-quit-messages))))

;;
(setq confirm-kill-emacs #'+doom-quit-fn)

(setq my-name "Bastien")
(insert "Hello!")


Uses company-quickhelp for documentation tooltips
Uses company-statistics to order results by usage frequency
