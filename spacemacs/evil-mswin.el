;;; Approximate mswin.vim behavior for Emacs evil-mode.
;; I will attempt to rewrite the relevant statements line-by-line from:
;; https://github.com/vim/vim/blob/master/runtime/mswin.vim

(setq lexical-binding t)

;; > " Bail out if this isn't wanted.
;; > if exists("g:skip_loading_mswin") && g:skip_loading_mswin
;; >   finish
;; > endif
;; #NOTE: No, we do want this.

;; > " set the 'cpoptions' to its Vim default
;; > if 1	" only do this when compiled with expression evaluation
;; >   let s:save_cpo = &cpoptions
;; > endif
;; > set cpo&vim
;; #NOTE: This backs up the options which get restored at the end of the script,
;; but there is no analog for this in evil-mode so it doesn't matter.

;; > " set 'selection', 'selectmode', 'mousemodel' and 'keymodel' for MS-Windows
;; > behave mswin
;; #TODO: Figure out what mouse options are even possible to port.

;; > " backspace and cursor keys wrap to previous/next line
;; > set backspace=indent,eol,start whichwrap+=<,>,[,]
;; #NOTE: Emacs already behaves this way by default! Nothing to do here.

;; > " backspace in Visual mode deletes selection
;; > vnoremap <BS> d
(define-key evil-visual-state-map (kbd "DEL") 'evil-delete)

;; > if has("clipboard")
;; >     " CTRL-X and SHIFT-Del are Cut
;; >     vnoremap <C-X> "+x
;; >     vnoremap <S-Del> "+x
(define-key evil-visual-state-map "\C-x" "\"*x")
(define-key evil-visual-state-map (kbd "S-DEL") "\"*x")

;; >     " CTRL-C and CTRL-Insert are Copy
;; >     vnoremap <C-C> "+y
;; >     vnoremap <C-Insert> "+y
(define-key evil-visual-state-map "\C-c" "\"*y")
(define-key evil-visual-state-map [C-insert] "\"*y")

;; >     " CTRL-V and SHIFT-Insert are Paste
;; >     map <C-V>		"+gP
;; >     map <S-Insert>		"+gP
(define-key evil-visual-state-map "\C-v" "\"*gP")
(define-key evil-visual-state-map [S-insert] "\"*y")

;; >     cmap <C-V>		<C-R>+
;; >     cmap <S-Insert>		<C-R>+
(define-key evil-command-window-mode-map "\C-v" (kbd "C-r *"))
(define-key evil-command-window-mode-map [S-insert] (kbd "C-r *"))
;; > endif
;; #TODO: Use evil-paste-from-register directly?
;; #NOTE: All the above commands use the * register because + apparently doesn't work. (Windows only...?)

;; > " Pasting blockwise and linewise selections is not possible in Insert and
;; > " Visual mode without the +virtualedit feature.  They are pasted as if they
;; > " were characterwise instead.
;; > " Uses the paste.vim autoload script.
;; > " Use CTRL-G u to have CTRL-Z only undo the paste.
;; > if 1
;; >     exe 'inoremap <script> <C-V> <C-G>u' . paste#paste_cmd['i']
;; >     exe 'vnoremap <script> <C-V> ' . paste#paste_cmd['v']
;; > endif
;; #NOTE: I don't know what this even does, but I presume evil does better out of the box.

;; >;; > imap <S-Insert>		<C-V>
;; > vmap <S-Insert>		<C-V>
(define-key evil-insert-state-map "\C-v" (kbd "C-r *"))
(define-key evil-insert-state-map [S-insert] (kbd "C-r *"))

;; > " Use CTRL-Q to do what CTRL-V used to do
;; > noremap <C-Q>		<C-V>
(define-key evil-normal-state-map "\C-q" 'evil-visual-block)

;; > " Use CTRL-S for saving, also in Insert mode (<C-O> doesn't work well when
;; > " using completions).
;; > noremap <C-S>		:update<CR>
;; > vnoremap <C-S>		<C-C>:update<CR>
;; > inoremap <C-S>		<Esc>:update<CR>gi
(define-key evil-normal-state-map "\C-s" 'evil-save)
(define-key evil-visual-state-map "\C-s" 'evil-save)
(define-key evil-insert-state-map "\C-s" 'evil-save)

;; > " For CTRL-V to work autoselect must be off.
;; > " On Unix we have two selections, autoselect can be used.
;; > if !has("unix")
;; >   set guioptions-=a
;; > endif
;; #NOTE: The + register doesn't even work so I doubt this is relevant.

;; > " CTRL-Z is Undo; not in cmdline though
;; > noremap <C-Z> u
;; > inoremap <C-Z> <C-O>u
(define-key evil-normal-state-map "\C-z" 'undo-tree-undo)
(define-key evil-insert-state-map "\C-z" 'undo-tree-undo)
;; #NOTE: Despite not having an evil- prefix, it looks like undo-tree- is by the evil devs?

;; > " CTRL-Y is Redo (although not repeat); not in cmdline though
;; > noremap <C-Y> <C-R>
;; > inoremap <C-Y> <C-O><C-R>
;; #NOTE: Since when is this a standard? I'm not going to bother with this.

;; > " Alt-Space is System menu
;; > if has("gui")
;; >   noremap <M-Space> :simalt ~<CR>
;; >   inoremap <M-Space> <C-O>:simalt ~<CR>
;; >   cnoremap <M-Space> <C-C>:simalt ~<CR>
;; > endif
;; #NOTE: Adding this would probably break some Emacs GUI stuff. I'm leaving it off.

;; > " CTRL-A is Select all
;; > noremap <C-A> gggH<C-O>G
;; > inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
;; > cnoremap <C-A> <C-C>gggH<C-O>G
;; > onoremap <C-A> <C-C>gggH<C-O>G
;; > snoremap <C-A> <C-C>gggH<C-O>G
;; > xnoremap <C-A> <C-C>ggVG
(defun evil-select-all ()
  (interactive)
  (evil-visual-select 0 (point-max)))
(define-key evil-normal-state-map "\C-a" 'evil-select-all)
(define-key evil-insert-state-map "\C-a" 'evil-select-all)
(define-key evil-command-window-mode-map "\C-a" 'evil-select-all)
;; #NOTE: The rest of the modes have no maps.

;; > " CTRL-Tab is Next window
;; > noremap <C-Tab> <C-W>w
;; > inoremap <C-Tab> <C-O><C-W>w
;; > cnoremap <C-Tab> <C-C><C-W>w
;; > onoremap <C-Tab> <C-C><C-W>w
;; #NOTE: This would probably just break people's workflow.

;; > " CTRL-F4 is Close window
;; > noremap <C-F4> <C-W>c
;; > inoremap <C-F4> <C-O><C-W>c
;; > cnoremap <C-F4> <C-C><C-W>c
;; > onoremap <C-F4> <C-C><C-W>c
;; #NOTE: Another UI related binding that might break workflow.

;; > if has("gui")
;; >   " CTRL-F is the search dialog
;; >   noremap  <expr> <C-F> has("gui_running") ? ":promptfind\<CR>" : "/"
;; >   inoremap <expr> <C-F> has("gui_running") ? "\<C-\>\<C-O>:promptfind\<CR>" : "\<C-\>\<C-O>/"
;; >   cnoremap <expr> <C-F> has("gui_running") ? "\<C-\>\<C-C>:promptfind\<CR>" : "\<C-\>\<C-O>/"

;; >   " CTRL-H is the replace dialog,
;; >   " but in console, it might be backspace, so don't map it there
;; >   nnoremap <expr> <C-H> has("gui_running") ? ":promptrepl\<CR>" : "\<C-H>"
;; >   inoremap <expr> <C-H> has("gui_running") ? "\<C-\>\<C-O>:promptrepl\<CR>" : "\<C-H>"
;; >   cnoremap <expr> <C-H> has("gui_running") ? "\<C-\>\<C-C>:promptrepl\<CR>" : "\<C-H>"
;; > endif
;; #TODO: Not sure yet what the analog for these would be in evil-mode.

;; > " restore 'cpoptions'
;; > set cpo&
;; > if 1
;; >   let &cpoptions = s:save_cpo
;; >   unlet s:save_cpo
;; > endif
;; #NOTE: Well we never touched these options at the top of the file,
;; so there's nothing to set back.
