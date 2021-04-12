;;; slackwise --- Adam "Slackwise" Flanczewski's Emacs config

;;; Commentary:
;;; My personal config tweaks designed to be used as a stand-alone
;;; configuration or for Doom/Spacemacs.

;;; Code:
(package-initialize)

(setq user-full-name "Adam Flanczewski"
      user-mail-address (concat "slackwise" "@" "slackwise.net"))

;; Need proxy at work
(load "~/src/dotfiles/emacs/proxy.el")

;; Dynamic is dangerous. Lexical, please.
(setq lexical-binding t)

;; Keep the customize system from borking up this file.
(setq-default
  custom-file (concat (or (getenv "XDG_CONFIG_HOME") "~/.config/emacs/") "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;; Disable toolbar
(tool-bar-mode -1)

(setq org-directory "~/org/")

(setq display-line-numbers-type 'relative)

;; Set default font.
(add-to-list 'default-frame-alist
             '(font . "Consolas-11"))
;;
;; Make underscore a word character for Ruby and Python:
  (add-hook 'ruby-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
  (add-hook 'python-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
;; Configure Evil mode.
(load "~/src/dotfiles/emacs/evil-mswin.el")
;; (load "~/src/dotfiles/emacs/evil-config.el") ; Do I really need to separate this?

(provide 'slackwise)
;;; slackwise.el ends here
