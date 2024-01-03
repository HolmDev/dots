;;; init.el --- Fredholms init file:

;;; Commentary:

;; Just my bloated init file

;;; Code:
;; Customized variables {{{
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-source-save-behavior nil)
 '(package-selected-packages
	 '(scad-mode elisp-format helpful format-all flycheck org-present elfeed smooth-scrolling good-scroll linum-relative telephone-line rainbow-delimiters rainbow-mode gruvbox-theme dashboard evil-vimish-fold vimish-fold company-go company-jedi company-auctex company-math company-quickhelp company yaml-mode svelte-mode typescript-mode which-key evil-goggles evil-collection evil use-package))
 '(warning-suppress-types '((comp)))
 '(whitespace-style
	 '(face trailing tabs spaces lines newline missing-newline-at-eof empty indentation space-after-tab space-before-tab space-mark tab-mark newline-mark)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(linum ((t (:background "#1d2021" :foreground "#7c6f64"))))
 '(linum-relative-current-face ((t (:background "#1d2021" :foreground "#fe8019")))))
;; }}}

(eval-when-compile
	(require 'use-package))


(setq backup-by-copying t								; don't clobber symlinks
			backup-directory-alist '(("." . "~/.emacs.d/saves/"))	; don't litter my fs tree
			delete-old-versions t kept-new-versions 6 kept-old-versions 2 version-control t)

;; {{{ Costmetic things

;; Remove tool-, menu- & scroll-bar
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq-default line-move-visual nil)

;; Set font
(add-to-list 'default-frame-alist '(font . "FiraCode Nerd Font Mono-16"))

;; Activate `prettify-symbols-mode'
(global-prettify-symbols-mode 1)

;; Transparent background
(set-frame-parameter (selected-frame) 'alpha '(80 . 80))
(add-to-list 'default-frame-alist '(alpha . (80 . 80)))
;; Fix tabs
(setq-default tab-width 2)

(indent-tabs-mode t)

(add-hook 'before-save-hook 'whitespace-cleanup)

;; Fix word wrapping
(global-visual-line-mode t)
;; }}}

;; {{{ Add MELPA archive
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
;; }}}

;; Install and load packages
;; {{{ Keybinds
(use-package
	evil
	:ensure t
	:init (setq evil-want-keybinding nil)
	:config (evil-mode t)
	(define-key evil-normal-state-map (kbd "SPC h") 'helpful-at-point)
	(define-key evil-normal-state-map (kbd "SPC c u") 'insert-char)
	(define-key evil-normal-state-map (kbd "SPC c n") 'nerd-insert)
	(define-key evil-normal-state-map (kbd "SPC s") 'sed)

	(define-key evil-normal-state-map (kbd "SPC b i") 'ibuffer)
	(define-key evil-normal-state-map (kbd "SPC b x") 'kill-buffer)
	(define-key evil-normal-state-map (kbd "SPC b r") 'rename-buffer)
	(define-key evil-normal-state-map (kbd "SPC b s") 'switch-to-buffer)
	(define-key evil-normal-state-map (kbd "SPC b c") '(lambda () (interactive) (switch-to-buffer (generate-new-buffer "New"))))

	(define-key evil-normal-state-map (kbd "SPC w c") 'make-frame)
	(define-key evil-normal-state-map (kbd "SPC w x") 'delete-frame)

	(define-key evil-normal-state-map (kbd "SPC Q") 'kill-emacs)

	(define-key evil-normal-state-map (kbd "SPC r t") 'ansi-term)
	(define-key evil-normal-state-map (kbd "SPC r w") 'eww)

	(define-key evil-normal-state-map (kbd "SPC p m") 'compile)

	(define-key evil-normal-state-map (kbd "SPC t i") '(lambda () (interactive) (indent-region (point-min) (point-max) nil)))

	(which-key-add-key-based-replacements
		"SPC c" "Characters"
		"SPC c u" "Insert Unicode Char"
		"SPC c n" "Insert Nerdfont Char"

		"SPC b" "Buffer"
		"SPC b i" "Ibuffer"
		"SPC b x" "Kill buffer"
		"SPC b r" "Rename buffer"
		"SPC b s" "Switch buffer"
		"SPC b c" "Create buffer"

		"SPC w" "Window"
		"SPC w c" "Create window"
		"SPC w x" "Kill window"

		"SPC r" "Programs"
		"SPC r t" "Terminal"
		"SPC r w" "Web"

		"SPC p" "Programming"
		"SPC p m" "Compile"

		"SPC t" "Text operations"
		"SPC t i" "Indent whole buffer"

		"SPC Q" "Kill emacs"

		"SPC h" "Helpful"
		"SPC s" "Sed")
	(define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
	(define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
	(define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
	(define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
	(setq-default evil-cross-lines t)
	(setq-default evil-undo-system 'undo-redo))

(use-package evil-collection
	:after evil
	:ensure t
	:config
	(evil-collection-init))

(use-package
	evil-goggles
	:ensure t
	:config (evil-goggles-mode t)
	:after evil)

(use-package
	which-key
	:ensure t
	:config
	(which-key-setup-minibuffer)
	(which-key-mode)
	:after evil)
;; }}}
;; {{{ Programming modes
(use-package
	typescript-mode
	:ensure t)

(use-package
	svelte-mode
	:ensure t)

(use-package
	yaml-mode
	:ensure t)

(use-package
	scad-mode
	:ensure t)
;; }}}
;; {{{ Company modes
(use-package
	company
	:ensure t
	:config (global-company-mode 1))

(use-package
	company-quickhelp
	:ensure t
	:config (company-quickhelp-mode 1)
	:after company)

(use-package
	company-math
	:ensure t
	:after company)

(use-package
	company-auctex
	:ensure t
	:after company)

(use-package
	company-jedi
	:ensure t
	:after company
	:config (add-hook 'python-mode-hook
										(lambda ()
											(add-to-list 'company-backends 'company-jedi))))

(use-package
	company-go
	:ensure t
	:after company)
;; }}}
;; {{{ Visuals
(use-package vimish-fold
	:ensure t
	:after evil)

(use-package evil-vimish-fold
	:ensure t
	:config
	(setq evil-vimish-fold-target-modes '(prog-mode conf-mode text-mode))
	(global-evil-vimish-fold-mode 1)
	:after vimish-fold)

(use-package
	dashboard
	:ensure t
	:config (dashboard-setup-startup-hook)
	(setq initial-buffer-choice
				(lambda ()
					(get-buffer "*dashboard*")))
	(setq dashboard-startup-banner 'logo)
	(setq dashboard-center-content t))

(use-package
	gruvbox-theme
	:ensure t
	:config (load-theme 'gruvbox-dark-hard t))


(use-package
	rainbow-mode
	:ensure t
	:config (rainbow-mode))

(use-package
	rainbow-delimiters
	:ensure t
	:config (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))


(use-package
	telephone-line
	:ensure t
	:config (telephone-line-mode 1))

(use-package
	ligature
	:load-path "~/.emacs.d/lisp"
	:config (ligature-set-ligatures 't '("www"))
	(ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
	(ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
																			 ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
																			 "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
																			 "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
																			 "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
																			 "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
																			 "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
																			 "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
																			 ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
																			 "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
																			 "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
																			 "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
																			 "\\\\" "://"))
	(global-ligature-mode t))

(use-package
	linum-relative
	:ensure t
	:config (setq linum-relative-current-symbol "")
	(linum-relative-global-mode 1))

(use-package
	good-scroll
	:ensure t
	:config (good-scroll-mode 1))

(use-package
	smooth-scrolling
	:ensure t
	:config (smooth-scrolling-mode 1)
	(setq smooth-scroll-margin 5))
;; }}}
;; {{{ Applications
(use-package
	elfeed
	:ensure t
	:config
	(load (concat user-emacs-directory "rss-feeds.el"))
	(elfeed-update)
	(global-set-key (kbd "C-x w") 'elfeed))
;; }}}
;; {{{ Org
(use-package
	org-present
	:ensure t
	:config (add-hook 'org-present-mode-hook
										(lambda ()
											(org-present-big)
											(org-display-inline-images)
											(org-present-hide-cursor)
											(org-present-read-only)))
	(add-hook 'org-present-mode-quit-hook
						(lambda ()
							(org-present-small)
							(org-remove-inline-images)
							(org-present-show-cursor)
							(org-present-read-write))))
;; }}}
;; {{{ Misc
(use-package
	flycheck
	:ensure t
	:config
	(global-flycheck-mode))

(use-package
	format-all
	:ensure t)

(use-package
	helpful
	:ensure t)

(use-package
	elisp-format
	:ensure t)

(use-package
	nerd-insert
	:load-path "~/.emacs.d/lisp/")

(use-package
	auctex
	:defer t
	:ensure t)
;; }}}

;; {{{ Custom functions
(defun image(file)
	"Insert an image in to the current buffer"
	(interactive "fPath to image: ")
	(insert-image (create-image file)))

(defun sed (command)
	"Run a sed command on current buffer"
	(interactive "s;")
	(setq sed-point (point))
	(shell-command-on-region (point-at-bol)
													 (point-max)
													 (concat "sed -e '" (concat command "'")) nil t)
	(goto-char sed-point))

(defun create-fold ()
	"Create a named fold at location."
	(interactive)
	(beginning-of-line)
	(insert "\n;; }}}")
	(beginning-of-line 0)
	(insert ";; {{{ ")
	(evil-insert-state)
	)
;; }}}

;; {{{ Org mode settings
(org-babel-do-load-languages 'org-babel-load-languages '((python . t)))
;; }}}

;; {{{ Misc settings
(dolist (hook '(text-mode-hook))
	(add-hook hook (lambda () (flyspell-mode 1))))
;; }}}
