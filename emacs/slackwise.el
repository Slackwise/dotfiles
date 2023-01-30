;;;;;;;;;; -*- lexical-binding:t -*- ;;;;;;;;;;


;;; slackwise --- Adam "Slackwise" Flanczewski's Emacs config


;; Author: Adam "Slackwise" Flanczewski
;; Package-Requires: ((emacs "27.1") (s "1.13.1"))
;; URL: https://github.com/Slackwise/dotfiles/

;;; Commentary:
;; My personal config tweaks designed to be used as a stand-alone
;; configuration or for Doom/Spacemacs.

;;; Code:
(package-initialize)
(require 's)

; (load-theme 'vscode-dark-plus) ; loaded via doom's config

(setq user-full-name "Adam Flanczewski"
      user-mail-address (concat "slackwise" "@" "slackwise.net"))

;; Let Emacs traverse symlinks:
(setq find-file-visit-truename t)

;; Keep the customize system from borking up this file:
(setq-default
  custom-file (concat (or (getenv "XDG_CONFIG_HOME") "~/.config/emacs/") "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;; Disable toolbar:
(tool-bar-mode -1) ; still accessible via F10

;; Enable frame tab bar (not to be confused with "tab-line-mode" which is per window):
(tab-bar-mode 1)

(defvar concat-lines (apply-partially #'s-join "\n"))

;; TODO: Override org-roam--title-to-slug: https://github.com/org-roam/org-roam/issues/686

;; Org/Roam:
(setq org-directory (file-truename "~/notes"))
(after! org (setq
             org-roam-directory (file-truename "~/notes")
             org-roam-capture-templates '(("d" "default" plain "%?"
                                           :target (file+head "private/captures/${slug}.org"
                                                              (concat-lines "#+title: ${title}"
                                                                            "#+filetags: private captures"))
                                           :unnarrowed t)
                                          ("p" "private" plain "%?"
                                           :target (file+head "private/${slug}.org"
                                                              (concat-lines "#+title: ${title}"
                                                                            "#+filetags: private"))
                                           :unnarrowed t)
                                          ("w" "work" plain "%?"
                                           :target (file+head "private/work/${slug}.org"
                                                              (concat-lines "#+title: ${title}"
                                                                            "#+filetags: private work"))
                                           :unnarrowed t)
                                          ("n" "public" plain "%?"
                                           :target (file+head "${slug}.org"
                                                              "#+title: ${title}")
                                           :unnarrowed t))))
; (org-roam-db-autosync-mode) ; unnecessary?

(setq display-line-numbers-type 'relative)

;; Set default font:
(add-to-list 'default-frame-alist
             '(font . "-GOOG-Roboto Mono-normal-normal-normal-*-15-*-*-*-m-0-iso10646-1"))

;; Make underscore a word character for Ruby and Python:
  (add-hook 'ruby-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
  (add-hook 'python-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))

;; Configure Evil mode:
(load "~/src/dotfiles/emacs/mswin.vim.el")
;; (load "~/src/dotfiles/emacs/evil-config.el") ; Do I really need to separate this?

;; Smush Windows, Vim, and Emacs/readline bindings into a muscle-memory friendly mush for insert mode:

;; Find what a key is bound to using: https://www.gnu.org/software/emacs/manual/html_node/elisp/Functions-for-Key-Lookup.html
;; Example: `(lookup-key (current-global-map) "\C-x\C-f")`

;; Copy some VS and VS Code bindings:
(define-key evil-insert-state-map (kbd "C-/") 'comment-line)
(define-key evil-normal-state-map (kbd "C-/") 'comment-line)
(define-key evil-visual-state-map (kbd "C-/") 'comment-region)

(provide 'slackwise)
;;; slackwise.el ends here
