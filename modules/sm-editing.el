;; Delete marked text on typing
(delete-selection-mode t)

;; Soft-wrap lines
(global-visual-line-mode t)

;; Require newline at end of file.
(setq require-final-newline t)

;; Revert buffers automatically when underlying files are changed externally.
(use-package autorevert
  :hook (after-init . global-auto-revert-mode)
  :delight auto-revert-mode)

(add-hook 'prog-mode-hook (lambda () (display-line-numbers-mode t)))

;; Don't use tabs for indent; replace tabs with two spaces.
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)

;; george is weird.  swap backspace and del at very low level
;; Need to work extra hard to have this work in emacsclient "frames"
;; too.  Otherwise, can just do the call to keyboard-translate...
;; https://stackoverflow.com/questions/5064390/run-command-on-new-frame-with-daemon-client-in-emacs
;; (keyboard-translate ?\C-h ?\C-?)
(defun make-keyboard-translations ()
  (keyboard-translate ?\C-? ?\C-h)
  (keyboard-translate ?\C-h ?\C-?))
(defun setup-frame-keyboard (frame)
  (with-selected-frame frame
    (make-keyboard-translations)))
(make-keyboard-translations)
(add-hook 'after-make-frame-functions #'setup-frame-keyboard)


;; General editing-related bindings.
(bind-key "\e \C-g" 'goto-line)
(bind-key "C-c C-k" 'kill-region)
(bind-key "<f5>" 'sort-lines)
(bind-key "C-c b" 'switch-to-previous-buffer)

;; Toggle map, from
;; http://endlessparentheses.com/the-toggle-map-and-wizardry.html
(define-prefix-command 'endless/toggle-map)
(define-key ctl-x-map "t" 'endless/toggle-map)
(define-key endless/toggle-map "f" #'auto-fill-mode)
(define-key endless/toggle-map "l" #'toggle-truncate-lines)
(define-key endless/toggle-map "n" #'display-line-numbers-mode)
(define-key endless/toggle-map "o" #'overwrite-mode)
;; (define-key endless/toggle-map "t" #'endless/toggle-theme)
;;; Generalized version of `read-only-mode'.
;; (define-key endless/toggle-map "r" #'dired-toggle-read-only)
;; (autoload 'dired-toggle-read-only "dired" nil t)

;; ctrl-x t v f -or- ctrl-x t v l
(define-prefix-command 'endless/visual-map)
(define-key endless/toggle-map "v" 'endless/visual-map)
(define-key endless/visual-map "f" #'visual-fill-column-mode)
(define-key endless/visual-map "l" #'visual-line-mode)

;; ctrl-x t w g -or- ctrl-x t w o
(define-prefix-command 'endless/whitespace-map)
(define-key endless/toggle-map "w" 'endless/whitespace-map)
;; (define-key endless/whitespace-map "g" #'global-whitespace-toggle-options)
(define-key endless/whitespace-map "o" #'whitespace-toggle-options)
(define-key endless/whitespace-map "w" #'whitespace-mode)

;; Cursor movement
(defun sm/next-line-fast ()
  "Faster `C-n'"
  (interactive)
  (ignore-errors (next-line 5)))

(defun sm/previous-line-fast ()
  "Faster `C-p'"
  (interactive)
  (ignore-errors (previous-line 5)))

(bind-key "C-S-n" 'sm/next-line-fast)
(bind-key "C-S-p" 'sm/previous-line-fast)

;; Crux (Collection of Ridiculously Useful eXtensions)
;; Replaces a lot of my old defuns and bindings.
(use-package crux
  :bind (("C-x C-r" . crux-recentf-find-file)
         ("C-a" . crux-move-beginning-of-line)
         ("<S-return>" . crux-smart-open-line)
         ("C-c R" . crux-rename-buffer-and-file)
         ("C-c D" . crux-delete-buffer-and-file)
         ("<f2>" . crux-visit-term-buffer)
         ("s-j" . crux-top-join-line))
  :config (recentf-mode t))

;; Use conf-mode where appropriate.
(use-package conf-mode
  :mode (("\\.editorconfig$" . conf-mode)
         ("\\.conf" . conf-mode)
         ("\\.cfg" . conf-mode)
         ("\\.ini" . conf-mode)))

;; multiple-cursors
(use-package multiple-cursors
  :init
  (define-prefix-command 'endless/mc-map)
  :hook
  (after-init .
              (lambda ()
                (require 'multiple-cursors)
                (set-face-attribute
                 'mc/cursor-bar-face nil
                 :background (face-attribute 'cursor :background)
                 :foreground (face-attribute 'cursor :background)
                 :height 0.2)
                (setq mc/list-file (sm/emacs.d "etc/.mc-lists.el"))
                ))
  :bind (()                             ; encourage emacs to indent pretty...
         :map ctl-x-map
         ("m" . endless/mc-map)
         :map endless/mc-map
         ("\C-a" . mc/edit-beginnings-of-lines)
         ("\C-e" . mc/edit-ends-of-lines)
         ("<" . mc/mark-previous-like-this)
         ("<" . mc/mark-previous-like-this)
         (">" . mc/mark-next-like-this)
         ("a" . mc/mark-all-like-this)
         ("h" . mc/hide-unmatched-lines-mode)
         ("i" . mc/insert-numbers)
         ("l" . mc/edit-lines)
         ))

;; expand-region
(use-package expand-region
  :bind ("C-=" . er/expand-region))

;; smartparens
(use-package smartparens
  :config
  (require 'smartparens-config)
  :hook
  (after-init . (lambda ()
                  (smartparens-global-mode t)
                  (show-smartparens-global-mode t)))
  :delight " ()"
  :bind
  ((:map sp-keymap)
   ("C-M-f" . sp-forward-sexp)
   ("C-M-b" . sp-backward-sexp)
   ("C-M-n" . sp-next-sexp)
   ("C-M-p" . sp-previous-sexp)
   ("C-M-k" . sp-kill-sexp)
   ("C-M-w" . sp-copy-sexp)))

;; browse-kill-ring
(use-package browse-kill-ring
  :chords (("yy" . browse-kill-ring)))

;; whitespace
;; handle markdown:
;;   (add-hook 'markdown-mode-hook
;;      (lambda () (setq-local whitespace-style (delq 'trailing whitespace-style))))
(use-package whitespace
  :config
  (setq whitespace-line-column 88)
  ;; (setq whitespace-style '(face tabs empty trailing lines-tail))
  (setq whitespace-style '(face lines-tail trailing indentation space-before-tab space-after-tab))
  :init
  (dolist (hook '(prog-mode-hook text-mode-hook))
    (add-hook hook #'whitespace-mode))
  )
;; whitespace cleanup
;; Automatically cleans whitespace on save.
(use-package whitespace-cleanup-mode
  :delight whitespace-cleanup-mode
  :commands whitespace-cleanup-mode
  :init
  (dolist (hook '(prog-mode-hook text-mode-hook))
    (add-hook hook #'whitespace-cleanup-mode)))

;; subword
(use-package subword
  :hook (prog-mode . subword-mode)
  :delight subword-mode)

;; undo-tree
;; Treat undo history as a tree.
(use-package undo-tree
  ;; :straight (undo-tree :type git :host github :repo "martinp26/undo-tree")
  :commands (undo-tree-visualize)       ; this isn't otherwise autoloaded
  :chords (("uu" . undo-tree-visualize))
  :delight undo-tree-mode
  :config
  (global-undo-tree-mode)
  (unbind-key "C-x u" undo-tree-map)    ; I still like old-skool undo too
  (setq undo-tree-visualizer-timestamps t)
  (setq undo-tree-visualizer-diff t)
  (setq undo-tree-auto-save-history nil)
  )

;; smart-comment
;; Better `comment-dwim' supporting uncommenting.
(use-package smart-comment
  :bind ("M-;" . smart-comment))

;; embrace
;; Add/Change/Delete pairs based on expand-region.
(use-package embrace
  :bind ("C-," . embrace-commander))

;; aggressive-indent
;; Keeps code correctly indented during editing.
(use-package aggressive-indent
  :commands aggressive-indent-mode
  :init
  (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
  (add-hook 'lisp-mode-hook #'aggressive-indent-mode))

;; encryption, the way that I'm used to doing it.
(use-package crypt++
  :straight nil
  :load-path "etc/extra"
  :demand t
  :config
  (progn
    (epa-file-disable)
    (setq crypt-encryption-type 'gpg)
    (setq crypt-encryption-file-extension "\\(\\.gpg\\)$")
    (modify-coding-system-alist 'file "\\.bz\\'" 'no-conversion)
    (modify-coding-system-alist 'file "\\.bz2\\'" 'no-conversion)
    (modify-coding-system-alist 'file "\\.gpg\\'" 'no-conversion)
    (modify-coding-system-alist 'file "\\.gz\\'" 'no-conversion)
    (modify-coding-system-alist 'file "\\.Z\\'" 'no-conversion)
    ))

;; allow me to use (outline-hide-body) in a file-local-variable,
;; e.g. in one of my encrypted gpg files...
(add-to-list
 'safe-local-eval-forms
 '(outline-hide-body))

(use-package writegood-mode)

(use-package boxquote
  :straight (:branch "main"))

(use-package ctrlf
  :init
  (ctrlf-mode +1)
  :config
  (add-to-list 'ctrlf-minibuffer-bindings '("C-r" . nil)))

(use-package volatile-highlights
  :demand
  :config
  (volatile-highlights-mode t)
  )

(use-package powerthesaurus
  :after hydra
  :chords (("pt" . powerthesaurus-hydra/body))
  )

(provide 'sm-editing)

