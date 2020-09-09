(use-package! google-translate)

(setq google-translate-translation-directions-alist '(("en" . "ru")))
(setq google-translate-default-source-language '"en")
(setq google-translate-default-target-language '"ru")

(global-set-key "\C-ct" 'google-translate-at-point)
