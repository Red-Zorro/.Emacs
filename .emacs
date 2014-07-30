(if (string-equal "darwin" (symbol-name system-type))
      (setenv "PATH" (concat "/opt/local/bin:/opt/local/sbin:" (getenv "PATH"))))
;;set the default file path
(setq default-directory "~/Desktop/")

;; start package.el with emacs
(require 'package)
;; add MELPA to repository list
(dolist (source '(("marmalade" . "http://marmalade-repo.org/packages/")
		  ("elpa" . "http://tromey.com/elpa/")
		  ("melpa" . "http://melpa.milkbox.net/packages/")
		  ))
  (add-to-list 'package-archives source t))
;;initialize package.el
(package-initialize)

;; indent configuration
(require 'cc-mode)
(setq-default c-basic-offset 4 c-default-style "linux")
(setq-default tab-width 4 indent-tabs-mode t)
(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)
(setq column-number-mode t)
(setq line-number-mode t)
(global-set-key (kbd "C-c C-c") 'ecb-goto-window-edit-last)
(global-set-key (kbd "C-c <up>") 'ecb-goto-window-sources)
(global-set-key (kbd "C-c <left>") 'ecb-goto-window-directories)
(global-set-key (kbd "C-c <right>") 'ecb-goto-window-methods)
(global-set-key (kbd "C-c <down>") 'ecb-goto-window-history)
(global-set-key (kbd "C-x k") 'kill-this-buffer)

(require 'ctypes)
(ctypes-auto-parse-mode 1)

(require 'linum)                                                   
(global-linum-mode 1)

;; import autopair mode: pair autocomplete
(require 'autopair)
(autopair-global-mode 1)
(setq autopair-autowrap t)

;; import iedit mode: identical variable match 
(define-key global-map (kbd "C-c C-v") 'iedit-mode)

;; import yasnippet
(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(setq yas-snippet-dirs
      '(
        "~/.emacs.d/plugins/yasnippet/yasmate/snippets"
        "~/.emacs.d/plugins/yasnippet/snippets"
        ))
(yas-global-mode 1)

;;auto-complete
(add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-20140726.303")
(require 'auto-complete)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elpa/auto-complete-20140726.303/dict")
(ac-config-default)
(setq ac-use-quick-help nil) 
;; Show menu 0.8 second later
(setq ac-auto-show-menu 0.8)
(setq ac-use-menu-map t)
(setq ac-menu-height 12)

;;import ECB
(add-to-list 'load-path "~/.emacs.d/plugins/ecb")
(require 'ecb)
(setq ecb-tip-of-the-day nil)
(setq ecb-layout-name "leftright2")
(setq ecb-windows-height 0.5)
(setq ecb-windows-width 0.15)
(setq ecb-auto-activate t)

;;parenthess jump
(define-key global-map (kbd "C-x m") 'match-paren)
(defun match-paren (arg) 
(interactive "p") 
(cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1)) 
((looking-at "\\s\)") (forward-char 1) (backward-list 1)) 
(t (self-insert-command (or arg 1))))) 

(global-set-key [(control ?\.)] 'ska-point-to-register) 
(global-set-key [(control ?\,)] 'ska-jump-to-register) 
(defun ska-point-to-register()
;;Use ska-jump-to-register to jump back to the stored position. 
(interactive) 
(setq zmacs-region-stays t) 
(point-to-register 8)) 

(defun ska-jump-to-register()
;;Switches between current cursorposition and position that was stored with ska-point-to-register." 
(interactive) 
(setq zmacs-region-stays t) 
(let ((tmp (point-marker))) 
(jump-to-register 8) 
(set-register 8 tmp))) 

;;comment setting
(defun qiang-comment-dwim-line (&optional arg) 
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))
(global-set-key [(control ?\/)] 'qiang-comment-dwim-line)

;; copy line
(defadvice kill-line (before check-position activate)
  (if (member major-mode
              '(emacs-lisp-mode scheme-mode lisp-mode
                                c-mode c++-mode objc-mode js-mode
                                latex-mode plain-tex-mode))
      (if (and (eolp) (not (bolp)))
          (progn (forward-char 1)
                 (just-one-space 0)
                 (backward-char 1))))) 
(defadvice kill-ring-save (before slick-copy activate compile)
  (interactive (if mark-active (list (region-beginning) (region-end))
                 (message "Copied line")
                 (list (line-beginning-position)
                       (line-beginning-position 2)))))
(defadvice kill-region (before slick-cut activate compile)
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))
(add-hook 'c++-mode-hook 'hs-minor-mode) 
(define-key global-map (kbd "C-x C-,") 'hs-toggle-hiding)

(mouse-avoidance-mode 'animate) 

(custom-set-variables
 '(blink-cursor-mode nil)
 '(custom-enabled-themes (quote (deeper-blue)))
 '(default-fill-column 80 t)
 '(display-time-24hr-format t)
 '(display-time-day-and-date t)
 '(display-time-mode 1)
 '(ecb-layout-window-sizes nil)
 '(electric-indent-mode 1)
 '(global-font-lock-mode t)
 '(gnus-inhibit-startup-message t)
 '(inhibit-startup-screen t)
 '(initial-frame-alist (quote ((fullscreen . maximized))))
 '(menu-bar-mode nil)
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(show-paren-style (quote parentheses))
 '(tool-bar-mode nil))

(custom-set-faces
 '(default ((t (:inherit nil :stipple nil :background "#2d3743" :foreground "#e1e1e0" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 140 :width normal :foundry "apple" :family "Courier")))))
