(setq user-full-name "Aaron Pankratz")
(setq user-mail-address "pankratz.aaron@gmail.com")

(setenv "PATH" (concat "/usr/local/bin:/opt/local/bin:/usr/bin:/bin" (getenv "PATH")))
(require 'cl)

(load "package")
(package-initialize)

(add-to-list 'package-archives
                  '("melpa" . "http://melpa.milkbox.net/packages/") t)

(setq package-archive-enable-alist '(("melpa" deft magit)))

(defvar apankratz/packages '(ac-slime
			     auto-complete
                             autopair
                             clojure-mode
			     coffee-mode
			     csharp-mode
			     deft
			     erlang
			     feature-mode
			     flycheck
			     gist
			     go-mode
			     graphviz-dot-mode
			     haml-mode
			     htmlize
			     magit
			     markdown-mode
			     marmalade
			     nodejs-repl
			     o-blog
			     org
			     paredit
			     php-mode
			     puppet-mode
			     restclient
			     rvm
			     scala-mode
			     smex
			     sml-mode
			     solarized-theme
                             web-mode
			     writegood-mode
			     yaml-mode)
  "Default packages")

(defun apankratz/packages-installed-p ()
  (loop for pkg in apankratz/packages
	when (not (package-installed-p pkg)) do (return nil)
	finally (return t)))

(unless (apankratz/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg apankratz/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

(setq inhibit-splash-screen t
      initial-scratch-message nil
      initial-major-mode 'org-mode)

(tool-bar-mode -1)
(delete-selection-mode t)
(transient-mark-mode t)
(setq x-select-enable-clipboard t)

(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (set-face-attribute 'default nil
		      :family "Inconsolata"
		      :height 140
		      :weight 'normal
		      :width 'normal)

  (when (functionp 'set-fontset-font)
    (set-fontset-font "fontset-default"
		      'unicode
		      (font-spec :family "DejaVu Sans Mono"
				 :width 'normal
				 :size 12.4
                                 :weight 'normal))))

(setq-default indicate-empty-lines t)
(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))

(setq tab-width 2
      indent-tabs-mode nil)
(setq make-backup-files nil)
(defalias 'yes-or-no-p 'y-or-n-p)

(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-c C-k") 'compile)
(global-set-key (kbd "C-x g") 'magit-status)

(defvar apankratz/vendor-dir (expand-file-name "vendor" user-emacs-directory))
(add-to-list 'load-path apankratz/vendor-dir)

(dolist (project (directory-files apankratz/vendor-dir t "\\w+"))
    (when (file-directory-p project)
          (add-to-list 'load-path project)))

(setq echo-keystrokes 0.1
      use-dialog-box nil
      visible-bell t)
(show-paren-mode t)

(setq smex-save-file (expand-file-name ".smex-items" user-emacs-directory))
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

(ido-mode t)
(setq ido-enable-flex-matching t
            ido-use-virtual-buffers t)

(setq column-number-mode t)

(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

(require 'autopair)
(require 'auto-complete-config)
(ac-config-default)

(defun untabify-buffer ()
    (interactive)
      (untabify (point-min) (point-max)))

(defun indent-buffer ()
    (interactive)
      (indent-region (point-min) (point-max)))

(defun cleanup-buffer ()
    "Perform a bunch of operations on the whitespace content of a buffer."
      (interactive)
        (indent-buffer)
	  (untabify-buffer)
	    (delete-trailing-whitespace))

(defun cleanup-region (beg end)
    "Remove tmux artifacts from region."
      (interactive "r")
        (dolist (re '("\\\\│\·*\n" "\W*│\·*"))
	      (replace-regexp re "" nil beg end)))

(global-set-key (kbd "C-x M-t") 'cleanup-region)
(global-set-key (kbd "C-c n") 'cleanup-buffer)

(setq-default show-trailing-whitespace t)

(add-to-list 'auto-mode-alist '("\\.gitconfig$" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.hbs$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$" . web-mode))

(defun js-custom ()
    "js-mode-hook"
      (setq js-indent-level 2))

(add-hook 'js-mode-hook 'js-custom)

(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mdown$" . markdown-mode))
(add-hook 'markdown-mode-hook
	            (lambda ()
		                  (visual-line-mode t)
				              (writegood-mode t)
					                  (flyspell-mode t)))
(setq markdown-command "pandoc --smart -f markdown -t html")
(setq markdown-css-path (expand-file-name "markdown.css" apankratz/vendor-dir))

(load-theme 'solarized-dark t)
(set-default-font "SF Mono Light 16")
