;;; sm-coding-go.el --- Golang config.

;; go get golang.org/x/tools/cmd/goimports
;; go get github.com/rogpeppe/godef
;; GO111MODULE=on go get golang.org/x/tools/gopls@latest

;; Things to look into...
;; From http://dominik.honnef.co/posts/2013/03/writing_go_in_emacs/
;;; go get github.com/dougm/goflymake
;;; goerrcheck

(use-package go-mode
  :hook ((before-save . gofmt-before-save)
         (go-mode . (lambda ()
                      ;; (whitespace-toggle-options '(tabs))
                      (setq whitespace-style '(face empty trailing lines-tail))
                      ))
         (go-mode . lsp-deferred))
  :bind (:map go-mode-map
              ("M-." . godef-jump)
              ("M-*" . pop-tag-mark))
  :config
  (setq gofmt-command "goimports")
  )

(use-package go-dlv)

;; This works, but seems to overlap with lsp-ui, plus it's
;; confusing....
;; (use-package go-guru)

;; if you use company-mode for completion (otherwise,
;; complete-at-point works out of the box):
;; (use-package company-lsp
;;   :commands company-lsp)

(use-package go-template-mode
  :straight nil
  :load-path "etc/extra"
  :demand t
  :config
  (progn
    (add-to-list 'auto-mode-alist '("\\.tmpl$" . go-template-mode))
    ))

(provide 'sm-coding-go)
