;; rust-mode, racer, cargo

;; rust-mode
;; https://github.com/rust-lang/rust-mode
(use-package rust-mode
  :bind ( :map rust-mode-map
         (("C-c C-t" . racer-describe)
         ([?\t] .  company-indent-or-complete-common)))
  :config
  (progn
    ;; add flycheck support for rust
    ;; https://github.com/flycheck/flycheck-rust
    (use-package flycheck-rust)

    ;; cargo-mode for all the cargo related operations
    ;; https://github.com/kwrooijen/cargo.el
    (use-package cargo
      :hook (rust-mode . cargo-minor-mode)
      :bind
      ("C-c C-c C-n" . cargo-process-new))

    ;;; separedit ;; via https://github.com/twlz0ne/separedit.el
    (use-package separedit
      :config
      (progn
        (define-key prog-mode-map (kbd "C-c '") #'separedit)
        (setq separedit-default-mode 'markdown-mode)))


    ;; racer-mode for getting IDE like features for rust-mode
    ;; https://github.com/racer-rust/emacs-racer
    (use-package racer
      :hook (rust-mode . racer-mode)
      :config
      (progn
        ;; set racer rust source path environment variable
        (setq racer-rust-src-path (getenv "RUST_SRC_PATH"))
        (defun my-racer-mode-hook ()
          (set (make-local-variable 'company-backends)
               '((company-capf company-files)))

          (setq company-minimum-prefix-length 1)
          (setq indent-tabs-mode nil))

        (add-hook 'racer-mode-hook 'my-racer-mode-hook)

        ;; enable company and eldoc minor modes in rust-mode
        (add-hook 'racer-mode-hook 'company-mode)
        (add-hook 'racer-mode-hook 'eldoc-mode)))

    (add-hook 'rust-mode-hook 'flycheck-mode)
    (add-hook 'flycheck-mode-hook 'flycheck-rust-setup)

    ;; format rust buffers on save using rustfmt
    (add-hook 'before-save-hook
              (lambda ()
                (when (eq major-mode 'rust-mode)
                  (rust-format-buffer))))))

(provide 'lang-rust)
