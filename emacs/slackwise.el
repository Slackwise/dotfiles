;;;;;;;;;; -*- lexical-binding:t -*- ;;;;;;;;;;


;;; slackwise --- Adam "Slackwise" Flanczewski's Emacs config


;; Author: Adam "Slackwise" Flanczewski
;; Package-Requires: ((emacs "24.1") (s "1.13.1"))
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

(defun concat-lines (&rest lines)
  "Concatenate strings &LINES into one newline-seperated string."
  (s-join "\n" lines))
  ;(apply 'string-join (cons lines "\n"))
  ;(seq-reduce (lambda (line s) (concat line s)) lines ""))

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
             '(font . "-GOOG-Roboto Mono-normal-normal-normal-*-17-*-*-*-m-0-iso10646-1"))

;; Make underscore a word character for Ruby and Python:
  (add-hook 'ruby-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
  (add-hook 'python-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))

;; Configure Evil mode:
(load "~/src/dotfiles/emacs/evil-mswin.el")
;; (load "~/src/dotfiles/emacs/evil-config.el") ; Do I really need to separate this?

(provide 'slackwise)
;;; slackwise.el ends here
