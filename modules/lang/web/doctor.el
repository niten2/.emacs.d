;;; lang/web/doctor.el -*- lexical-binding: t; -*-

(assert! (or (not (featurep! +lsp)) (featurep! :tools lsp)) "This module requires (:tools lsp)")

(unless (executable-find "js-beautify")
  (warn! "Couldn't find js-beautify. Code formatting in JS/CSS/HTML modes will not work."))
