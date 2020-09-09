<!-- %s/[0-9]\.[0-9]\/[0-9]\.[0-9]\s-point[s]*\s-(graded)// -->
<!-- $$|\vec{A}|=\sqrt{A_x^2 + A_y^2 + A_z^2}.$$(1) -->

<!-- ;; NOTE -->
<!-- ;; python engine -->
<!-- ;;https://github.com/jorgenschaefer/elpy -->

# hotkeys

  gs<sp>
  S'

  menu-bar-mode

  C-x C-c - exit
  C-x 5 - 2 - create new frame
  С-x - RET - C-\ - set input method

  sp - sp - run commands

  <!-- macros -->
  F3 - start, F4 - end, F4 - exec

  S-Space
  Очень умное автодополнение.
  Иногда достаточно просто раз пять нажать эту комбинацию и программа чудесным образом напишется сама.

  C-s, C-r
  Эти клавиши привязаны к поиску по регэкспу вперёд и назад.

  sp - h - T (tutorial)
  sp - b - h (home)
  sp - h - i (search)
  sp - h - sp (search by help)

  sp - f - f

  sp - w - n
  sp - w - v
  sp - w - s
  sp - w - f

  alt - 1 TODO
  shift - super - down

  sp - f - t (nerd tree)
  sp - z - f (zoom)
  sp - t - n (nubmers)

  C-x - C-s - save file

  sp - f - s (save)
  sp - f - S (save all)

  ~SPC SPC org-reload C-u RET~

  sp - T - m (menu bar)
  sp - t -
  sp - t - m - _ (mode line)

  sp - l - _ (layouts)
  sp - l - w - 2 (workspaces)
  sp - l - w - 2 (workspaces)
  sp - l - w - R (set tag)

  alt - j/k - move text

  ctrl - w - o (maximum)

# utils
## snippets
  SPC i s - List all current yasnippets for inserting
  M-/ - in insert mode

  M-/	Expand a snippet if text before point is a prefix of a snippet
  | ~SPC t y~   | =ⓨ=     | y     | [[https://github.com/capitaomorte/yasnippet][yasnippet]] mode                                                       |

## Auto-yasnippet
  Key Binding	Description
  SPC i S c	create a snippet from an active region
  SPC i S e	Expand the snippet just created with SPC i y
  SPC i S w	Write the snippet inside private/snippets directory for future sessions

## surround
	ysiw"
	visual - s'

	// surround
	(evil-define-key 'visual evil-surround-mode-map "s" 'evil-substitute)
	(evil-define-key 'visual evil-surround-mode-map "S" 'evil-surround-region)


## python
 C-c C-c run the content of the buffer in the opened python shell

 C-c C-p (run scripts)
 C-c C-z open a python shell

 C-c C-r run the selected region in the python shell

## tabnine
 company-tabnine-install-binary

## config
	line-number-mode
	display-line-numbers-mode []
	(global-display-line-numbers-mode)

	how get buffer messages

## ranger
  gh - go home

| Key Binding | Description                                       |
|-------------|---------------------------------------------------|
| ~SPC a r~   | launch ranger                                     |
| ~SPC a d~   | deer (minimal ranger window in current directory) |
| ~C-p~       | (ranger) toggle ranger in dired buffer            |

| Key binding     | Description                                          |
|-----------------|------------------------------------------------------|
| ~SPC a r~       | launch ranger                                        |
| ~SPC a d~       | deer (minimal ranger window in current directory)    |
| ~C-p~           | (ranger) toggle ranger in dired buffer               |
| ~j~             | (ranger) navigate down                               |
| ~k~             | (ranger) navigate up                                 |
| ~yy~            | (ranger) copy                                        |
| ~pp~            | (ranger) paste                                       |
| ~R~             | (ranger) rename                                      |
| ~D~             | (ranger) delete                                      |
| ~C-j~           | (ranger) scroll preview window down                  |
| ~C-k~           | (ranger) scroll preview window up                    |
| ~f~             | (ranger) search for file names                       |
| ~i~             | (ranger) show preview of current file                |
| ~zi~            | (ranger) toggle showing literal / full-text previews |
| ~zh~            | (ranger) toggle showing dotfiles                     |
| ~o~             | (ranger) sort options                                |
| ~H~             | (ranger) search through history                      |
| ~h~             | (ranger) go up directory                             |
| ~l~             | (ranger) find file / enter directory                 |
| ~RET~           | (ranger) find file / enter directory                 |
| ~q~             | (ranger) quit                                        |
| ~;g~            | (ranger) revert buffer                               |
| ~z-~            | (ranger) reduce number of parents                    |
| ~z+~            | (ranger) increment number of parents                 |
| ~C-SPC~ / ~TAB~ | (ranger) mark current file                           |
| ~v~             | (ranger) toggle all marks                            |
| ~t~             | (ranger) toggle mark current file                    |
| ~S~             | (ranger) enter shell                                 |
| ~;C~            | (ranger) copy directory / copy and move directory    |
| ~;+~            | (ranger) create directory                            |

## language translate
  change keyboard layout - C-\
  SPC x w d	Show definition of word at point
  SPC x g l	Set the source and target languages for google translate
  SPC x g Q	Send marked area to google translate as reverse query
  SPC x g q	Send marked area to google translate as forward query
  SPC x g T	Send word at point to google translate as reverse query
  SPC x g t	Send word at point to google translate as forward query

## spell check language
  SPC S a b	Add word to dict (buffer)
  SPC S a g	Add word to dict (global)
  SPC S a s	Add word to dict (session)
  SPC S b	Flyspell whole buffer
  SPC S c	Flyspell correct word before point
  SPC S s	Flyspell correct word at point
  SPC u SPC S c	Flyspell correct all errors one by one
  SPC S d	Change dictionary
  SPC S n	Flyspell goto next error
  SPC t S	Toggle flyspell

## js
  TODO check not found?
  sp m = = - js beatufy,

  https://github.com/syl20bnr/spacemacs/tree/develop/layers/+lang/javascript

  javascript-mode
  sp - m - w (linter js errors)
  sp - m -

### Repl
  sm - m - s

  | Key     | Description                                                  |
  |---------|--------------------------------------------------------------|
  | ~m s b~ | send buffer                                                  |
  | ~m s B~ | send buffer and switch to REPL                               |
  |         |                                                              |
  | ~m s d~ | first key to send buffer and switch to REPL to debug (step)  |
  | ~m s D~ | second key to send buffer and switch to REPL to debug (step) |
  | ~m s f~ | send function                                                |
  | ~m s F~ | send function and switch to REPL                             |
  | ~m s i~ | start/switch to REPL inferior process                        |
  | ~m s l~ | send line                                                    |
  | ~m s L~ | send line and switch to REPL                                 |
  | ~m s r~ | send region                                                  |
  | ~m s R~ | send region and switch to REPL                               |

  | Key   | Description                |
  |-------|----------------------------|
  | ~C-j~ | next item in history       |
  | ~C-k~ | previous item in  history  |
  | ~C-l~ | clear screen               |
  | ~C-r~ | search backward in history |

## markdown
  | ~SPC m c ]~ | complete buffer                                                                      |
  | ~SPC m c m~ | other window                                                                         |
  | ~SPC m c p~ | preview                                                                              |
  | ~SPC m c P~ | live preview using engine defined with layer variable =markdown-live-preview-engine= |
  | ~SPC m c e~ | export                                                                               |
  | ~SPC m c v~ | export and preview                                                                   |
  | ~SPC m c o~ | open                                                                                 |
  | ~SPC m c w~ | kill ring save                                                                       |
  | ~SPC m c c~ | check refs                                                                           |
  | ~SPC m c n~ | cleanup list numbers                                                                 |
  | ~SPC m c r~ | render buffer                                                                        |

  Key bindings | Element insertion | Key binding	Description
  SPC m -	insert horizontal line
  SPC m h i	insert header dwim
  SPC m h I	insert header setext dwim
  SPC m h 1	insert header atx 1
  SPC m h 2	insert header atx 2
  SPC m h 3	insert header atx 3
  SPC m h 4	insert header atx 4
  SPC m h 5	insert header atx 5
  SPC m h 6	insert header atx 6
  SPC m h !	insert header setext 1
  SPC m h @	insert header setext 2
  SPC m i l	insert link
  SPC m i u	insert uri
  SPC m i f	insert footnote
  SPC m i w	insert wiki link
  SPC m i i	insert image
  SPC m i t	insert Table of Contents (toc)
  SPC m x b	make region bold or insert bold
  SPC m x B	insert gfm checkbox
  SPC m x i	make region italic or insert italic
  SPC m x c	make region code or insert code
  SPC m x C	make region code or insert code (Github Flavored Markdown format)
  SPC m x q	make region blockquote or insert blockquote
  SPC m x Q	blockquote region
  SPC m x p	make region or insert pre
  SPC m x P	pre region
  SPC m x s	make region striked through or insert strikethrough

  Element removal | Key binding	Description
  SPC m k	kill thing at point

  Table manipulation | Key binding	Description

  SPC m t p	move row up
  SPC m t n	move row down
  SPC m t f	move column right
  SPC m t b	move column left
  SPC m t r	insert row
  SPC m t R	delete row
  SPC m t c	insert column
  SPC m t C	delete column
  SPC m t s	sort lines
  SPC m t t	transpose table
  SPC m t d	convert region to table

  Completion | Key binding	Description

  SPC m ]	complete

  Following and Jumping | Key binding	Description
  SPC m o	follow thing at point
  RET	jump (markdown-do)

  Indentation | Key binding	Description

  SPC m >	indent region
  SPC m <	outdent region

  Header navigation | Key binding	Description
  gj	outline forward same level
  gk	outline backward same level
  gh	outline up one level
  gl	outline next visible heading

  List editing
  SPC m l i	insert list item

  Movement
  SPC m {	backward paragraph
  SPC m }	forward paragraph
  SPC m N	next link
  SPC m P	previous link

  Promotion, Demotion
  M-k or M-up	markdown-move-up
  M-j or M-down	markdown-move-down
  M-h or M-left	markdown-promote
  M-l or M-right	markdown-demote

  Toggles
  SPC m T i	toggle inline images
  SPC m T l	toggle hidden urls
  SPC m T m	toggle markup hiding
  SPC m T t	toggle checkbox
  SPC m T w	toggle wiki links

# modes
  tabbar
  tabbar-mode
  tern-mode
  org-mode
  conf-mode

  (message "%s" major-mode)

# tags
  ~SPC m g C~ create

  gd - move to

# helm
## hotkey

  | Key binding | Description                                               |
  |-------------|-----------------------------------------------------------|
  | ~SPC m g C~ | create a tag database                                     |
  | ~SPC m g f~ | jump to a file in tag database                            |
  | ~SPC m g g~ | jump to a location based on context                       |
  | ~SPC m g G~ | jump to a location based on context (open another window) |
  | ~SPC m g d~ | find definitions                                          |
  | ~SPC m g i~ | present tags in current function only                     |
  | ~SPC m g l~ | jump to definitions in file                               |
  | ~SPC m g n~ | jump to next location in context stack                    |
  | ~SPC m g p~ | jump to previous location in context stack                |
  | ~SPC m g r~ | find references                                           |
  | ~SPC m g R~ | resume previous helm-gtags session                        |
  | ~SPC m g s~ | select any tag in a project retrieved by gtags            |
  | ~SPC m g S~ | show stack of visited locations                           |
  | ~SPC m g y~ | find symbols                                              |
  | ~SPC m g u~ | manually update tag database                              |

  - From within Emacs, run either =counsel-gtags-create-tags= or
    =helm-gtags-create-tags=, which are bound to ~SPC m g C~. If the language is
    not directly supported by GNU Global, you can choose =ctags= or =pygments= as
    a backend to generate the database.
  - From inside a terminal:

  #+BEGIN_SRC sh
    cd /path/to/project/root

    # If the language is not directly supported and GTAGSLABEL is not set
    gtags --gtagslabel=pygments

    # Otherwise
    gtags
  #+END_SRC


sp - / - search in projecs
after C - c - C - e

sp - r - l - resume last session




  | Key binding | Description                  |
  |-------------|------------------------------|
  | ~C-h~       | go to next source            |
  | ~C-H~       | describe key (replace ~C-h~) |
  | ~C-j~       | go to previous candidate     |
  | ~C-k~       | go to next candidate         |
  | ~C-l~       | same as ~return~             |

## helm swoop
| Key binding | Description                    |
|-------------|--------------------------------|
| ~SPC s C~   | clear =helm-swoop= own cache   |
| ~SPC s s~   | execute =helm-swoop=           |
| ~SPC s S~   | execute =helm-multi-swoop=     |
| ~SPC s C-s~ | execute =helm-multi-swoop-all= |





# lines
  C-j - new line and intend
  ?? delete-intendation
  C-M-o - split string

  M-d - delete word
  M-t - transpose word

  M-a, M-e - move start, end sectense
  M-x customize

# layers #
## go ##
** Guru
If you would like to use the =Go Guru= bindings in your work, in your project you
will need to set the scope with ~SPC m f o~. The scope is a comma separated set
of packages, and Go's recursive operator is supported. In addition, you can
prefix it with =-= to exclude a package from searching.

=go-coverage-display-buffer-func= controls how =go-coverage= should display
the coverage buffer.
See [[https://www.gnu.org/software/emacs/manual/html_node/elisp/Choosing-Window.html][display-buffer]]
for a list of possible functions.
The default value is =display-buffer-reuse-window=.
