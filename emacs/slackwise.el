;;;;;;;;;; -*- lexical-binding:t -*- ;;;;;;;;;;


;;; slackwise --- Adam "Slackwise" Flanczewski's Emacs config

;;; Commentary:
;;; My personal config tweaks designed to be used as a stand-alone
;;; configuration or for Doom/Spacemacs.

;;; Code:
(package-initialize)

; (load-theme 'vscode-dark-plus)

(setq user-full-name "Adam Flanczewski"
      user-mail-address (concat "slackwise" "@" "slackwise.net"))

;; Let Emacs traverse symlinks
(setq find-file-visit-truename t)

;; Keep the customize system from borking up this file.
(setq-default
  custom-file (concat (or (getenv "XDG_CONFIG_HOME") "~/.config/emacs/") "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;; Disable toolbar
(tool-bar-mode -1)

;; Org/Roam
(setq org-directory (file-truename "~/notes"))
(after! org (setq
             org-roam-directory (file-truename "~/notes")
             org-roam-capture-templates '(("d" "default" plain "%?"
                                           :target (file+head "${slug}.org"
                                                              "#+title: ${title}\n")
                                           :unnarrowed t))))
; (org-roam-db-autosync-mode)

(setq display-line-numbers-type 'relative)

;; Set default font.
(add-to-list 'default-frame-alist
             '(font . "-GOOG-Roboto Mono-normal-normal-normal-*-17-*-*-*-m-0-iso10646-1"))

;; Make underscore a word character for Ruby and Python:
  (add-hook 'ruby-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
  (add-hook 'python-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))

;; Configure Evil mode.
(load "~/src/dotfiles/emacs/evil-mswin.el")
;; (load "~/src/dotfiles/emacs/evil-config.el") ; Do I really need to separate this?

(provide 'slackwise)
;;; slackwise.el ends here
