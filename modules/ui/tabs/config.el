;; user for group - awesome-tab-buffer-groups
(use-package awesome-tab
  :load-path "/home/q/.emacs.d/modules/ui/tabs/awesome-tab"
  :config
  (awesome-tab-mode t)
)

;; (use-package! centaur-tabs
;;   :after-call after-find-file dired-initial-position-hook
;;   :init
;;   (setq
;;       ;; centaur-tabs-cycle-scope "tabs"
;;       ;; centaur-tabs-gray-out-icons "buffer"
;;       ;; centaur-tabs-set-modified-marker t
;;       ;; centaur-tabs-set-bar "left"
;;       ;; centaur-tabs-close-button "✕"

;;       centaur-tabs-set-close-button nil
;;       centaur-tabs-set-icons t
;;       centaur-tabs-modified-marker "⬤"
;;       centaur-tabs-cycle-scope 'tabs
;;   )
;;   :config
;;   (add-hook '+doom-dashboard-mode-hook #'centaur-tabs-local-mode)
;;   (add-hook '+popup-buffer-mode-hook #'centaur-tabs-local-mode)
;;   (centaur-tabs-mode t)
;;   (centaur-tabs-group-by-projectile-project)
;;   (define-key evil-normal-state-map (kbd "M-g") 'centaur-tabs-swith-group)
;;   (define-key evil-normal-state-map (kbd "t k") 'centaur-tabs-forward)
;;   (define-key evil-normal-state-map (kbd "t j") 'centaur-tabs-backward)
;;   (define-key evil-normal-state-map (kbd "t h") 'centaur-tabs-select-beg-tab)
;;   (define-key evil-normal-state-map (kbd "t l") 'centaur-tabs-select-end-tab)
;;   (define-key evil-normal-state-map (kbd "t m j") 'centaur-tabs-move-current-tab-to-left)
;;   (define-key evil-normal-state-map (kbd "t m k") 'centaur-tabs-move-current-tab-to-right)
;;   (defun centaur-tabs-hide-tab (x)
;;     (let ((name (format "%s" x)))
;;       (or
;;       (string-prefix-p "*Messages" name)
;;       (string-prefix-p "*Quail" name)
;;       (string-prefix-p "*epc" name)
;;       (string-prefix-p "*helm" name)
;;       (string-prefix-p "*Compile-Log*" name)
;;       (string-prefix-p "*lsp" name)
;;       (and (string-prefix-p "magit" name)
;;             (not (file-name-extension name)))
;;       )
;;     )
;;   )
;; )

;; (use-package tabbar :ensure t
;;   :after projectile
;;   :config
;;   (defun tabbar-buffer-groups ()
;;     "Return the list of group names the current buffer belongs to.
;; Return a list of one element based on major mode."
;;     (list
;;      (cond
;;       ((or (get-buffer-process (current-buffer))
;;            ;; Check if the major mode derives from `comint-mode' or
;;            ;; `compilation-mode'.
;;            (tabbar-buffer-mode-derived-p
;;             major-mode '(comint-mode compilation-mode)))
;;        "Process"
;;        )
;;       ((member (buffer-name)
;;         '("*scratch*" "*Messages*" "*dashboard*" "TAGS")) "Common"
;;        )
;;       ((eq major-mode 'dired-mode)
;;        "Dired"
;;        )
;;       ((memq major-mode
;;              '(help-mode apropos-mode Info-mode Man-mode))
;;        "Help"
;;        )
;;       ((memq major-mode
;;              '(rmail-mode
;;                rmail-edit-mode vm-summary-mode vm-mode mail-mode
;;                mh-letter-mode mh-show-mode mh-folder-mode
;;                gnus-summary-mode message-mode gnus-group-mode
;;                gnus-article-mode score-mode gnus-browse-killed-mode))
;;        "Mail"
;;        )
;;     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;     ;;; Group tabs by projectile projects
;;       ((memq (current-buffer)
;;              (condition-case nil
;;                  (projectile-buffers-with-file-or-process (projectile-project-buffers))
;;                (error nil)))
;;        (projectile-project-name)
;;        )
;;     ;;; end of hacking
;;     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;       (t
;;        ;; Return `mode-name' if not blank, `major-mode' otherwise.
;;        (if (and (stringp mode-name)
;;                 ;; Take care of preserving the match-data because this
;;                 ;; function is called when updating the header line.
;;                 (save-match-data (string-match "[^ ]" mode-name)))
;;            mode-name
;;          (symbol-name major-mode))
;;        ))))

;;   (tabbar-mode )
;;   (define-key evil-normal-state-map (kbd "t k") 'tabbar-forward)
;;   (define-key evil-normal-state-map (kbd "t j") 'tabbar-backward)
;; )
