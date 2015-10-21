;;; Adam "Slackwise" Flanczewski's Emacs config.

;; Dynamic is dangerous. Lexical, please.
(setq lexical-binding t)

;; Keep the customize system from borking up this file.
(setq-default
  custom-file "~/.emacs.custom.el")
(when (file-exists-p custom-file) (load custom-file))

;; Disable toolbar
(tool-bar-mode -1)


;; Set default font.
;; #TODO

;; Configure Evil mode.
;; #TODO
