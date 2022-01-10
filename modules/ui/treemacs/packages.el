(package! treemacs :pin "b572bc78daa01264a1845dc8143f7d47152faefb")

(when (featurep! :editor evil +everywhere)
  (package! treemacs-evil :pin "4eb8eb8821")
  )

(package! treemacs-projectile :pin "4eb8eb8821")

(when (featurep! :tools magit)
  (package! treemacs-magit :pin "4eb8eb8821")
  )
