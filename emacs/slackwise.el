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

(defun concat-lines (&rest lines)
  (seq-reduce (lambda (a c) (concat a "\n" c)) (cdr lines) (car lines)))

(setq display-line-numbers-type 'relative)

;; Set default font:
(add-to-list 'default-frame-alist
             '(font . "-GOOG-Roboto Mono-normal-normal-normal-*-15-*-*-*-m-0-iso10646-1"))

;; Make underscore a word character for Ruby and Python:
  (add-hook 'ruby-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
  (add-hook 'python-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))

;; Web mode settings:
(add-hook 'web-mode-hook
          (lambda ()
            (setq web-mode-markup-indent-offset 2)
            (setq web-mode-css-indent-offset 2)
            (setq web-mode-code-indent-offset 2)
            (setq web-mode-enable-auto-closing nil)))

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


;; Org/Roam:
(setq org-directory (file-truename "~/notes"))
(setq emacsql-sqlite-executable "~/.guix-profile/bin/emacsql-sqlite")
(after! org
  ;; Override how org-roam generates filenames/slugs, replacing its underscores with hyphens/dashes:
  ;; (Solution found on Reddit: https://www.reddit.com/r/emacs/comments/omxl6n/config_for_orgroam_v2/ )
  (cl-defmethod org-roam-node-slug ((node org-roam-node))
    "Return the slug of NODE."
    (let ((title (org-roam-node-title node))
          (slug-trim-chars '(;; Combining Diacritical Marks https://www.unicode.org/charts/PDF/U0300.pdf
                             768 ; U+0300 COMBINING GRAVE ACCENT
                             769 ; U+0301 COMBINING ACUTE ACCENT
                             770 ; U+0302 COMBINING CIRCUMFLEX ACCENT
                             771 ; U+0303 COMBINING TILDE
                             772 ; U+0304 COMBINING MACRON
                             774 ; U+0306 COMBINING BREVE
                             775 ; U+0307 COMBINING DOT ABOVE
                             776 ; U+0308 COMBINING DIAERESIS
                             777 ; U+0309 COMBINING HOOK ABOVE
                             778 ; U+030A COMBINING RING ABOVE
                             779 ; U+030B COMBINING DOUBLE ACUTE ACCENT
                             780 ; U+030C COMBINING CARON
                             795 ; U+031B COMBINING HORN
                             803 ; U+0323 COMBINING DOT BELOW
                             804 ; U+0324 COMBINING DIAERESIS BELOW
                             805 ; U+0325 COMBINING RING BELOW
                             807 ; U+0327 COMBINING CEDILLA
                             813 ; U+032D COMBINING CIRCUMFLEX ACCENT BELOW
                             814 ; U+032E COMBINING BREVE BELOW
                             816 ; U+0330 COMBINING TILDE BELOW
                             817 ; U+0331 COMBINING MACRON BELOW
                             )))
      (cl-flet* ((nonspacing-mark-p (char) (memq char slug-trim-chars))
                 (strip-nonspacing-marks (s) (string-glyph-compose
                                              (apply #'string
                                                     (seq-remove #'nonspacing-mark-p
                                                                 (string-glyph-decompose s)))))
                 (cl-replace (title pair) (replace-regexp-in-string (car pair) (cdr pair) title)))
        (let* ((pairs `(("[^[:alnum:][:digit:]]" . "-") ;; convert anything not alphanumeric
                        ("__*" . "-")                   ;; remove sequential dashes
                        ("^_" . "")                     ;; remove starting dash
                        ("_$" . "")))                   ;; remove ending dash
               (slug (-reduce-from #'cl-replace (strip-nonspacing-marks title) pairs)))
          (downcase slug)))))
  (setq org-roam-directory (file-truename "~/notes")
        org-roam-capture-templates `(("d" "default" plain "%?"
                                      :target (file+head "private/captures/${slug}.org"
                                                         ,(concat-lines "#+title: ${title}"
                                                                        "#+filetags: private captures"))
                                      :unnarrowed t)
                                     ("p" "private" plain "%?"
                                      :target (file+head "private/${slug}.org"
                                                         ,(concat-lines "#+title: ${title}"
                                                                        "#+filetags: private"))
                                      :unnarrowed t)
                                     ("w" "work" plain "%?"
                                      :target (file+head "private/work/${slug}.org"
                                                         ,(concat-lines "#+title: ${title}"
                                                                        "#+filetags: private work"))
                                      :unnarrowed t)
                                     ("n" "public" plain "%?"
                                      :target (file+head "${slug}.org"
                                                         ,(concat-lines "#+title: ${title}"
                                                                        "#+filetags: "))
                                      :unnarrowed t))))
                                        ; (org-roam-db-autosync-mode) ; unnecessary?


(provide 'slackwise)
;;; slackwise.el ends here
