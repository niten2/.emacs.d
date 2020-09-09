;;;###autoload
;; "Kill all `dired-mode' buffers."
(defun +dired/quit-all ()
  (interactive)
  (mapc #'kill-buffer (doom-buffers-in-mode 'dired-mode))
  (message "Killed all dired buffers"))

;;;###autoload
;; "Enable `dired-git-info-mode' in git repos."
(defun +dired-enable-git-info-h ()
  (and (not (file-remote-p default-directory))
       (locate-dominating-file "." ".git")
       (dired-git-info-mode 1)))
