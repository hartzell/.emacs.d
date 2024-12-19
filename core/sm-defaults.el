;; Sane defaults.
(require 'sm-defuns)

;; Ignore customisation by putting it in the cache dir.
(setq custom-file (sm/cache-for "custom.el"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(warning-suppress-log-types '((comp)))
 '(native-comp-deferred-compilation-deny-list '("vm-*.el"))
 )

;; Fix mac-port defaults.
(when (equal system-type 'darwin)
  ;; https://apple.stackexchange.com/questions/467216/emacs-starts-up-without-window-focus-in-macos-sonoma
  ;; (select-frame-set-input-focus (selected-frame))
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'super)
  (global-set-key [(super v)] 'yank)
  (global-set-key [(super q)] 'save-buffers-kill-emacs))

;; this should probably be conditional on OS....
(setq browse-url-browser-function 'browse-url-generic)
(setq browse-url-generic-program "open")
(global-set-key [s-mouse-1] 'browse-url-at-mouse)

;; Frame title formatting.
(setq-default frame-title-format
              '((:eval (if (buffer-file-name)
                           (abbreviate-file-name (buffer-file-name))
                         "%b"))))

;; Character encodings default to utf-8.
(prefer-coding-system 'utf-8)
(set-language-environment 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)

;; Show column numbers in mode line.
(setq column-number-mode t)

;; Never ring the bell. Never.
(setq ring-bell-function (lambda()))

;; Don't disable any commands (e.g. `upcase-region').
(setq disabled-command-function nil)

;; Don't use dialog boxes.
(setq use-dialog-box nil)

;; Hide mouse while typing.
(setq make-pointer-invisible t)

;; Reduce keystroke echo delay.
(setq echo-keystrokes 0.001)

;; Enable y/n answers.
(fset 'yes-or-no-p 'y-or-n-p)

;; Automatically scroll compilation window.
(setq compilation-scroll-output 1)

(sm/mkdir-p (sm/emacs.d "var/cache"))
(sm/mkdir-p (sm/emacs.d "etc"))
(sm/mkdir-p (sm/cache-for "backups"))

;; Emoji font.
(when (fboundp 'set-fontset-font)
  (set-fontset-font t 'symbol
		    (font-spec :family "Apple Color Emoji")
		    nil 'prepend))

;; Keep backups in a separate directory.
(defun make-backup-file-name (file)
  (concat (sm/cache-for "backups/") (file-name-nondirectory file) "~"))

;; Keep autosave files in /tmp.
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Change auto-save-list directory.
(setq auto-save-list-file-prefix (sm/cache-for "auto-save-list/.saves-"))

;; Change eshell directory.
(setq eshell-directory-name (sm/cache-for "eshell"))

;; Disable annoying lock files.
(setq create-lockfiles nil)

;; Change bookmarks file location.
(setq bookmark-default-file (sm/emacs.d "etc/bookmarks"))

;; Change save-places file location.
(setq save-place-file (sm/cache-for "places"))

;; Ido history.
(setq ido-save-directory-list-file (sm/cache-for "ido.last"))

;; Allow pasting selection outside of Emacs.
(setq x-select-enable-clipboard t)

;; Move files to trash when deleting
(setq delete-by-moving-to-trash t)

;; Ignore case for completion.
(setq completion-ignore-case t
      read-file-name-completion-ignore-case t)

;; When copying something from outside emacs, save to kill-ring.
(setq save-interprogram-paste-before-kill t)

;; Dired defaults.
;; (setq-default insert-directory-program "gls")
(setq-default dired-listing-switches "-lha")
(setq-default dired-clean-up-buffers-too t)
(setq-default dired-recursive-copies 'always)
(setq-default dired-recursive-deletes 'top)
(when (string= system-type "darwin")
  (setq dired-use-ls-dired nil))

;; Scratch buffer configuration.
(setq initial-major-mode 'markdown-mode)
(setq initial-scratch-message "\
### Scratch buffer
This buffer is for text that is not saved.")

;; See hi-line-plus in modules/sm-ui.el
;; (global-hl-line-mode t)

;; Misc.
(setq inhibit-startup-message t)
(setq-default indicate-empty-lines t)
(global-font-lock-mode t)

(setq comment-empty-lines 'eol)

;; don't warn about "large" files
(setq large-file-warning-threshold nil)

(provide 'sm-defaults)
