;;;  -*- lexical-binding: t; -*-
;;; Approximate mswin.vim behavior for Emacs evil-mode.
;; Ported the most relevant keybindings from https://github.com/vim/vim/blob/master/runtime/mswin.vim


;; Delete in visual mode
(define-key evil-visual-state-map (kbd "DEL") 'evil-delete)

;; Cut
(define-key evil-visual-state-map "\C-x" "\"+x")
(define-key evil-visual-state-map (kbd "S-DEL") "\"+x")

;; Copy
(let ((yank (lambda ()
              (interactive)
              (apply 'evil-yank (append (seq-take (evil-visual-range) 3) '(?+))))))
  (define-key evil-visual-state-map "\C-c" yank)
  (define-key evil-visual-state-map [C-insert] yank))

;; Paste
(let ((paste (lambda ()
               (interactive)
               (evil-paste-from-register ?+)))
      ;; (paste-before (lambda (count &optional register yank-handler)
      ;;                 (interactive "P<x>")
      (paste-before (lambda (count &optional register yank-handler)
                      (interactive "P<x>")
                      (call-interactively 'evil-paste-before)))
      (paste-after (lambda (count &optional register yank-handler)
                      (interactive "P<x>")
                      (call-interactively 'evil-paste-after))))
  (define-key evil-command-window-mode-map "\C-v" paste)
  (define-key evil-command-window-mode-map [S-insert] paste)
  (define-key evil-insert-state-map "\C-v" paste)
  (define-key evil-insert-state-map [S-insert] paste)
  (define-key evil-visual-state-map "\C-v" paste-before)
  (define-key evil-visual-state-map [S-insert] paste-after)
  (define-key evil-normal-state-map "\C-v" paste-before)
  (define-key evil-normal-state-map [S-insert] paste-after))
 
;; Save
(define-key evil-normal-state-map "\C-s" 'evil-write)
(define-key evil-visual-state-map "\C-s" 'evil-write)
(define-key evil-insert-state-map "\C-s" 'evil-write)

;; Undo
(define-key evil-normal-state-map "\C-z" 'undo-tree-undo)
(define-key evil-insert-state-map "\C-z" 'undo-tree-undo)

;; Select All
(let ((evil-select-all (lambda ()
                         (interactive)
                         (evil-visual-select 0 (point-max)))))
  (define-key evil-normal-state-map "\C-a" evil-select-all)
  (define-key evil-insert-state-map "\C-a" evil-select-all)
  (define-key evil-command-window-mode-map "\C-a" evil-select-all))

;; Visual block select
(define-key evil-normal-state-map "\C-q" 'evil-visual-block)
