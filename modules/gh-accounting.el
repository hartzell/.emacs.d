(use-package beancount
  :ensure t
  :commands beancount-mode
  :hook
  (beancount-mode . outline-minor-mode)
  ;; (beancount-mode . flymake-bean-check-enable)
  :config
  (progn
    (setq-local electric-indent-chars nil)
                                        ; (add-to-list 'auto-mode-alist '("\\.bean$" . beancount-mode))
    )
  :bind (:map beancount-mode-map
              ("C-c C-n" . outline-next-visible-heading)
              ("C-c C-p" . outline-previous-visible-heading)
              ("C-c C-u" . outline-up-heading)
              ("C-c C-b" . outline-backward-same-level)
              ("C-c C-f" . outline-forward-same-level)
              ("C-c C-a" . outline-show-all)
              ("C-c TAB" . beancount-outline-cycle)
              ))

(provide 'gh-accounting)
