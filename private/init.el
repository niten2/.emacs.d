(doom!
  :completion
  company
  ivy
  ;; ido
  ;; helm

  :ui
  doom ; themes
  hl-todo ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
  workspaces
  treemacs
  tabs ; an tab bar for Emacs
  (popup +defaults)   ; tame sudden yet inevitable temporary windows
  window-select

  ;; hydra
  ;; modeline          ; snazzy, Atom-inspired modeline, plus API
  ;; nav-flash         ; blink the current line after jumping
  ;; ophints           ; highlight the region an operation acts on
  ;; vc-gutter         ; vcs diff in the fringe
  ;; vi-tilde-fringe   ; fringe tildes to mark beyond EOB
  ;; window-select     ; visually switch windows
  ;; deft              ; notational velocity for Emacs
  ;; fill-column       ; a `fill-column' indicator
  ;; indent-guides     ; highlighted indent columns
  ;; pretty-code       ; replace bits of code with pretty symbols
  ;; unicode           ; extended unicode support for various languages
  ;; zen               ; distraction-free coding or writing

  :editor
  (evil +everywhere)
  fold
  snippets
  multiple-cursors
  format

  ;; file-templates
  ;; word-wrap         ; soft wrapping with language-aware indent
  ;; lispy             ; vim for lisp, for people who don't like vim
  ;; god               ; run Emacs commands without modifier keys
  ;; objed             ; text object editing for the innocent
  ;; parinfer          ; turn lisp into python, sort of
  ;; rotate-text       ; cycle region at point between text candidates

  :emacs
  dired
  electric          ; smarter, keyword-based electric-indent
  vc                ; version-control and Emacs, sitting in a tree

  ;; :term
  ;; eshell            ; a consistent, cross-platform shell (WIP)
  ;; shell             ; a terminal REPL for Emacs
  ;; term              ; terminals in Emacs
  ;; vterm             ; another terminals in Emacs

  :checkers
  syntax
  (spell +aspell)
  translate
  ;; grammar

  :tools
  (eval +overlay)
  lookup
  magit
  docker
  lsp
  ;; debugger
  ;; ansible
  ;; direnv
  ;; editorconfig      ; let someone else argue about tabs vs spaces
  ;; gist              ; interacting with github gists
  ;; make              ; run make tasks from Emacs
  ;; pass              ; password manager for nerds
  ;; pdf               ; pdf enhancements
  ;; prodigy           ; FIXME managing external services & code builders
  ;; rgb               ; creating color strings
  ;; terraform         ; infrastructure as code
  ;; tmux              ; an API for interacting with tmux
  ;; upload            ; map local to remote projects via ssh/ftp

  :lang
  data
  emacs-lisp
  markdown
  sh
  python
  vim
  web
  (javascript +lsp)
  go
  lua
  (haskell +dante)  ; a language that's lazier than I am

  (org
    +brain
    +dragndrop ; drag & drop files/images into org buffers
    +hugo ; use Emacs for hugo blogging
    +jupyter ; ipython/jupyter support for babel
    +pandoc ; export-with-pandoc support
    +pomodoro ; be fruitful with the tomato technique
    +present ; presentation
  )

  ;; purescript
  ;; agda              ; types of types of types of types...
  ;; assembly          ; assembly for fun or debugging
  ;; cc                ; C/C++/Obj-C madness
  ;; clojure           ; java with a lisp
  ;; common-lisp       ; if you've seen one lisp, you've seen them all
  ;; coq               ; proofs-as-programs
  ;; crystal           ; ruby at the speed of c
  ;; csharp            ; unity, .NET, and mono shenanigans
  ;; elixir            ; erlang done right
  ;; elm               ; care for a cup of TEA?
  ;; erlang            ; an elegant language for a more civilized age
  ;; ess               ; emacs speaks statistics
  ;; faust             ; dsp, but you get to keep your soul
  ;; fsharp            ; ML stands for Microsoft's Language
  ;; fstar             ; (dependent) types and (monadic) effects and Z3
  ;; hy                ; readability of scheme w/ speed of python
  ;; idris
  ;; (java +meghanada) ; the poster child for carpal tunnel syndrome
  ;; julia             ; a better, faster MATLAB
  ;; kotlin            ; a better, slicker Java(Script)
  ;; latex             ; writing papers in Emacs has never been so fun
  ;; lean
  ;; factor
  ;; ledger            ; an accounting system in Emacs
  ;; nim               ; python + lisp at the speed of c
  ;; nix               ; I hereby declare "nix geht mehr!"
  ;; ocaml             ; an objective camel
  ;; perl
  ;; php
  ;; plantuml          ; diagrams for confusing people more
  ;; qt                ; the 'cutest' gui framework ever
  ;; racket            ; a DSL for DSLs
  ;; rest              ; Emacs as a REST client
  ;; rst               ; ReST in peace
  ;; rust              ; Fe2O3.unwrap().unwrap().unwrap().unwrap()
  ;; scala             ; java, but good
  ;; scheme            ; a fully conniving family of lisps
  ;; solidity          ; do you need a blockchain? No.
  ;; swift             ; who asked for emoji variables?
  ;; terra             ; Earth and Moon in alignment for performance.
  ;; (ruby +rails)

  ;; don't change, evil something wrong in workspases
  :config (custom +bindings +smartparens)
)
