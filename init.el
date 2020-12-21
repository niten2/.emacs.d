(setq gc-cons-threshold most-positive-fixnum)
(setq load-prefer-newer noninteractive)

(let (file-name-handler-alist)
  (setq user-emacs-directory (file-name-directory load-file-name))
)

(load (concat user-emacs-directory "core/core") nil 'nomessage)

(doom-initialize)

(if noninteractive
  (doom-initialize-packages)
  (doom-initialize-core)
  (doom-initialize-modules)
)

(put 'projectile-ripgrep 'disabled nil)


(put 'scroll-left 'disabled nil)
