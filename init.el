;;; init.el --- Start of the Emacs initialisation process.

;; E.g., useful for debugging problems where a package
;;(e.g. transient) is being loaded from the emacs distro instead of
;;straight's copy.
;; (eval-after-load "transient" '(debug))
;; This will show you where the copy that's being used came from:
;; (symbol-file 'transient-define-prefix)

;; Increase the GC threshold as soon as possible.
(setq gc-cons-threshold 402653184
      gc-cons-percentage 1.0)
(add-hook 'after-init-hook
          (lambda ()
            (setq gc-cons-threshold 16777216)))

;; Not using package.el.
(setq package-enable-at-startup nil)

;; Prepare paths.
(add-to-list 'load-path (expand-file-name "core/" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "modules/" user-emacs-directory))
(add-to-list 'exec-path "/usr/local/bin")

;; Set up some sane defaults.
(require 'sm-defaults)

;; Custom functions.
(require 'sm-defuns)

;; Set up available modules and the `load-modules' function.
(require 'sm-modules)

;; Personal settings unique to my setup.
(require 'sm-personal)

;; Load configured modules.
(sm/load-modules)
