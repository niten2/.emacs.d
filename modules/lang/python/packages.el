;; (package! pip-requirements :pin "216cd1690f")

;; (when (featurep! +cython)
;;   (package! cython-mode :pin "f6bf6aa9c7")
;;   (when (featurep! :checkers syntax)
;;     (package! flycheck-cython :pin "ecc4454d35")))

;; (when (featurep! +lsp)
;;   (package! lsp-python-ms :pin "5d0c799099"))

;; (package! anaconda-mode :pin "10299bd9ff")
;; (when (featurep! :completion company)
;;   (package! company-anaconda :pin "a31354ca8e"))

;; (package! pipenv :pin "b730bb509e")

;; (package! pyvenv :pin "861998b6d1")

;; (when (featurep! +pyenv)
;;   (package! pyenv-mode :pin "aec6f2aa28"))

;; (when (featurep! +conda)
;;   (package! conda :pin "814439dffa"))

;; (package! nose :pin "f852829751")
;; (package! python-pytest :pin "09ad688df2")

;; (package! pyimport :pin "a6f63cf7ed")
;; (package! py-isort :pin "e67306f459")

;; NOTE notebooks
(package! ein)

;; NOTE format code
(package! py-yapf)
