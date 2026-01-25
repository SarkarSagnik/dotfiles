(load "~/.emacs.d/themes/noctalia-theme.el")
(load-theme 'noctalia t)

(setq inhibit-splash-screen t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;; Evil mode (Vim emulation)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'evil)
  (package-install 'evil))

(use-package evil
  :init
  (evil-mode 1))

;; Install and configure rust-mode
(unless (package-installed-p 'rust-mode)
  (package-install 'rust-mode))

(use-package rust-mode
  :config
  (setq rust-format-on-save t))

;; Install and configure python-mode
(unless (package-installed-p 'python-mode)
  (package-install 'python-mode))

;; Install and configure zig-mode
(unless (package-installed-p 'zig-mode)
  (package-install 'zig-mode))

;; Eglot LSP client
(unless (package-installed-p 'eglot)
  (package-install 'eglot))

(use-package eglot
  :config
  ;; Auto-start Eglot in programming modes
  (add-hook 'prog-mode-hook 'eglot-ensure)
  ;; C/C++ server configuration
  (add-to-list 'eglot-server-programs
               '((c-mode c++-mode) . ("clangd")))
  ;; Rust server configuration  
  (add-to-list 'eglot-server-programs
               '(rust-mode . ("rust-analyzer")))
  ;; Python server configuration
  (add-to-list 'eglot-server-programs
               '(python-mode . ("pylsp")))
  ;; Zig server configuration
  (add-to-list 'eglot-server-programs
               '(zig-mode . ("zls"))))



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
