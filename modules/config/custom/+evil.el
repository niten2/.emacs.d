(defun +default-disable-delete-selection-mode-h ()
  (delete-selection-mode -1)
)

(add-hook 'evil-insert-state-entry-hook #'delete-selection-mode)
(add-hook 'evil-insert-state-exit-hook  #'+default-disable-delete-selection-mode-h)

;; Make SPC u SPC u [...] possible (#747)
(map! :map universal-argument-map
    :prefix doom-leader-key     "u" #'universal-argument-more
    :prefix doom-leader-alt-key "u" #'universal-argument-more
)

(when (featurep! +bindings) (load! "+evil-bindings"))
