;;; Adam "Slackwise" Flanczewski's Emacs config.

;; Dynamic is dangerous. Lexical, please.

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq lexical-binding t)

;; Keep the customize system from borking up this file.
(setq-default
  custom-file (concat (or (getenv "XDG_CONFIG_HOME") "~/.config/emacs/") "custom.el")
(when (file-exists-p custom-file) (load custom-file))

;; Disable toolbar
(tool-bar-mode -1)


;; Set default font.
;; #TODO
(add-to-list 'default-frame-alist
             '(font . "Consolas-16"))

;; Configure Evil mode.
(load "~/src/dotfiles/emacs/evil-mswin.el")
(load "~/src/dotfiles/emacs/evil-config.el")
