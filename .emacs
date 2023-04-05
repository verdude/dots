(setq package-enable-at-startup t)
(setq vc-follow-symlinks t)
(ido-mode 1)
(defvar ido-enable-flex-matching)
(setq ido-enable-flex-matching t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(defvar backup-directory-alist)
(setq backup-directory-alist `(("." . "/tmp/.emacs/backups")))
(defvar auto-save-default)
(setq auto-save-default nil)
(setq-default indent-tabs-mode nil)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq-default require-final-newline t)

;; Straight
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'helm)
(straight-use-package 'helm-ls-git)
(straight-use-package 'terraform-mode)
(straight-use-package 'go-mode)
(straight-use-package 'darkroom)
(straight-use-package 'fzf)
(straight-use-package 'evil)
(straight-use-package 'magit)
(straight-use-package 'yaml-mode)
(straight-use-package 'bnf-mode)

(straight-use-package 'color-theme-sanityinc-solarized)
(straight-use-package 'color-theme-sanityinc-tomorrow)

;; Don't prompt to confirm theme safety. This avoids problems with
;; first-time startup on Emacs > 26.3.
(setq custom-safe-themes t)

;; If you don't customize it, this is the theme you get.
(setq custom-enabled-themes '(sanityinc-tomorrow-eighties))

;; Ensure that themes will be applied even if they have not been customized
(defun reapply-themes ()
  "Forcibly load the themes listed in `custom-enabled-themes'."
  (dolist (theme custom-enabled-themes)
    (unless (custom-theme-p theme)
      (load-theme theme)))
  (custom-set-variables `(custom-enabled-themes (quote ,custom-enabled-themes))))

(add-hook 'after-init-hook 'reapply-themes)

(defun light ()
  "Activate a light color theme."
  (interactive)
  (setq custom-enabled-themes '(sanityinc-tomorrow-day))
  (reapply-themes))

(defun dark ()
  "Activate a dark color theme."
  (interactive)
  (setq custom-enabled-themes '(sanityinc-tomorrow-bright))
  (reapply-themes))

(global-set-key (kbd "C-x C-p") 'fzf-git)
(global-set-key (kbd "C-x C-i") 'darkroom-tentative-mode)
(global-set-key (kbd "C-x /") 'darkroom-increase-margins)
(global-set-key (kbd "C-x ,") 'darkroom-decrease-margins)
(global-set-key (kbd "C-x C-n") 'display-line-numbers-mode)

(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x C-d") 'helm-browse-project)
(global-set-key (kbd "C-x C-r") 'helm-projects-history)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x TAB") 'indent-rigidly)
(helm-mode 1)
(setq tab-width 2)
(put 'upcase-region 'disabled nil)

;; Start off warm and fuzzy
;; courtesy of mr purcell
(setq-default initial-scratch-message
              (concat ";; Happy hacking, " user-login-name " - Emacs ♥ you!!\n\n"))

(setq inhibit-startup-screen t)
(setq x-select-enable-clipboard t)

(defun create-lang-repo (dirname)
  (make-directory dirname nil)
  (magit-init dirname)
  (cd dirname)
  (switch-to-buffer-other-frame (create-file-buffer "grammar.bnf")))
