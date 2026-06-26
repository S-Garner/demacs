(setq inhibit-startup-message t) ; skips welcome screen

(scroll-bar-mode -1)  ; removes graphics scrollbar
(tool-bar-mode -1)    ; removes the icon toolbar
(tooltip-mode -1)     ; disable graphical tooltips
(menu-bar-mode -1)    ; removes the top menu bar

(setq visible-bell t) ; replaces audible beep with a visual flash

(set-face-attribute 'default nil
		    :font "DejaVu Sans Mono" ; Font family
		    :height 125)             ; Font size

(load-theme 'wombat) ; THEME

(require 'package)   ; loads emacs' package-management library

(setq package-archives                                ; defines the package repo emacs uses
      '(("melpa" . "https://melpa.org/packages/")     ; MELPA provides large collection of community packages
	("elpa" . "https://elpa.gnu.org/packages/"))) ; ELPA is the official GNU emacs

(package-initialize) ; prepares installed packages for use

(unless package-archive-contents
  (package-refresh-contents)) ; downloads the current package list if emacs does not already have it

(unless (package-installed-p 'use-package) ; checks whether a package is already installed
                                           ; in elisp, functions ending with -p usually asks a yes or no question and return true or nil
  (package-install 'use-package))          ; 

(require 'use-package)

(setq use-package-always-ensure t) ; tells use-package to install packages automatically if they are missing

(use-package diminish) ; hide minor modes you do not need to see

(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ; binds the escape key to keyboard-escape-quit which cancels many active prompts

; ivy is a completion framework, and counsel provides improved versions of common emacs commands that use ivy

(use-package ivy                      ; declares config for the ivy package
  :diminish                           ; hides ivy's mode name from the mode line
  :bind (("C-s" . swiper)             ; defines keybindings
	 :map ivy-minibuffer-map      ; bindings only apply while ivy's minibuffer is active
	 ("C-j" . ivy-next-line)      ; move down in ivy results
	 ("C-k" . ivy-previous-line)) ; move up in ivy results
  :config                             ; contains code that runs after the package loads
  (ivy-mode 1))                       ; enables ivy globally

(use-package counsel                     ; use package counsel
  :after ivy                             ; use after loading ivy
  :bind (("M-x" . counsel-M-x)           ; ivy powered command list
	 ("C-x b" . counsel-ibuffer)     ; better buffer switcher
	 ("C-x C-f" . counsel-find-file) ; better file navigation
	 :map minibuffer-local-map
	 ("C-r" . counsel-minibuffer-history)) ; minibuffer history
  :config
  (counsel-mode 1))                   ; counsel enabled after ivy

(use-package doom-modeline
  :init
  (doom-modeline-mode 1)
  :custom ; sets package variables using emacs' customization system
  (doom-modeline-height 15)) ; set modeline height

;; Keep backup and auto-save files out of project directories.
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups/" user-emacs-directory))))

(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save-list/" user-emacs-directory) t)))

;; Stop Emacs from creating lockfiles like .#init.el
(setq create-lockfiles nil)

(global-display-line-numbers-mode 1) ; turn on numberline
(column-number-mode 1)               ; show columns in mode line
(dolist (mode '(term-mode-hook       ; disable numberline in term
		shell-mode-hook      ; disable in shell
		eshell-mode-hook))   ; disable in eshell
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; when prog-mode is active, enable rainbow delimiters
;; since many programming modes derive from this mode, it turns on rainbow delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

; shows a popup of which key is available after typing in an input
(use-package which-key
  :init
  (which-key-mode)
  :custom
  (which-key-idle-delay 0.6)) ; how long it takes for it to appear

; adds more functionality to ivy and counsel like metadata
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))


