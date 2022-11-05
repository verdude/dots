(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("fe1c13d75398b1c8fd7fdd1241a55c286b86c3e4ce513c4292d01383de152cb7" "03adef25678d624333371e34ec050db1ad7d13c9db92995df5085ebb82978671" default))
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(line-number-current-line ((t (:inherit line-number :background "brightblack" :box (:line-width (2 . 2) :color "brightcyan" :style released-button))))))

(setq package-enable-at-startup nil)
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

(global-set-key (kbd "C-x C-p") 'fzf-git)
(global-set-key (kbd "C-x C-i") 'darkroom-tentative-mode)
(global-set-key (kbd "C-x /") 'darkroom-increase-margins)
(global-set-key (kbd "C-x ,") 'darkroom-decrease-margins)
(global-set-key (kbd "C-x C-n") 'display-line-numbers-mode)

(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x C-d") 'helm-browse-project)
(global-set-key (kbd "C-x C-r") 'helm-projects-history)
(global-set-key (kbd "M-x") 'helm-M-x)
(helm-mode 1)
(setq tab-width 2)
(put 'upcase-region 'disabled nil)
