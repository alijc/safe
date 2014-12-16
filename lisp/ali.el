;--------------------------------------------------------------------------
;   System Dependent Settings
;--------------------------------------------------------------------------

;-----------------------
; VT100 Keyboard States
;-----------------------
 
;(defvar GOLD-map (make-keymap)
;   "`GOLD-map' maps the function keys on the VT100 keyboard preceded
;by the PF1 key.  GOLD is the ASCII the 7-bit escape sequence <ESC>OP.")
;(defalias 'GOLD-prefix GOLD-map)

;(defvar BLUE-map (make-keymap)
;   "`BLUE-map' maps the function keys on the VT100 keyboard preceded
;by the PF2 key.")
;(defalias 'BLUE-prefix BLUE-map)

;--------------------------------------------------------------------------
;   Libraries
;--------------------------------------------------------------------------

;(load "paren")
;(load "s-region")
;(load "formfeed" )

;--------------------------------------------------------------------------
;   Key Assignements
;--------------------------------------------------------------------------

;; C-] = my translate map, make it available for us
;;
(global-unset-key "\C-]")           ;was abort-recursive-edit


; Cursor keys

(define-key global-map [home]        'beginning-of-line)
(define-key global-map [find]        'beginning-of-line)
(define-key global-map [end]         'end-of-line)
(define-key global-map [select]      'end-of-line)
(define-key global-map [C-home]      'beginning-of-buffer)
(define-key global-map [C-find]      'beginning-of-buffer)
(define-key global-map (kbd "C-] H") 'beginning-of-buffer)
(define-key global-map [S-home]      'recenter-to-top)
(define-key global-map [C-end]       'end-of-buffer)
(define-key global-map [C-select]    'end-of-buffer)
(define-key global-map (kbd "C-] E") 'end-of-buffer)

(define-key global-map (kbd "C-] L") 'backward-word)
(define-key global-map (kbd "C-] R") 'forward-word)
(define-key global-map (kbd "C-] U") 'backward-paragraph)
(define-key global-map (kbd "C-] D") 'forward-paragraph)

;;(define-key global-map [tab]         'tab-to-tab-stop)
(define-key global-map [delete]      'delete-char)
(define-key global-map [backspace]   'backward-delete-char)
(define-key global-map [C-delete]    'backward-delete-char)

(define-key isearch-mode-map [delete]    'isearch-delete-char)
(define-key isearch-mode-map [backspace] 'isearch-delete-char)

; Switch minibuffer completion to a tab
;;(define-key minibuffer-local-filename-completion-map [tab] 'minibuffer-complete-word)

; Function keys

(global-set-key [f1]   'delete-other-windows)
(global-set-key [f2]   'split-window-vertically)

(global-set-key [f3]   'isearch-repeat-backward)
(global-set-key [f4]   'isearch-repeat-forward)

(global-set-key [f5]   'goto-line)
(global-set-key [f6]   'next-error)
(global-set-key [f7]   'enter-date)
;;;(define-key flyspell-mode-map [f7]   'flyspell-goto-next-error)
(global-set-key [f8]   'call-last-kbd-macro)

(global-set-key [f9]   'compile)
(global-set-key [f10]  'other-window)

(global-set-key [f11]   'tpu-previous-file-buffer)           
(global-set-key [C-f11] 'tpu-previous-non-file-buffer)           
(global-set-key [f12]   'tpu-next-file-buffer)           
(global-set-key [C-f12] 'tpu-next-non-file-buffer)           

;--------------------------------------------------------------------------
;   Variables
;--------------------------------------------------------------------------

;(setq inhibit-default-init t) ; no global initializations

(setq scroll-step 2)
(setq-default fill-column 80)

;(transient-mark-mode t)

(setq column-number-mode t)
;(line-number-mode t)


(setq compile-command "make ")

;(setq next-line-add-newlines nil)

;(setq font-lock-maximum-decoration t)

;--------------------------------------------------------------------------
;    C-Mode Configuration
;--------------------------------------------------------------------------

;(defun no-newline ()
;  (nil))

(add-hook 'c-mode-hook
    (function (lambda ()
	  (c-set-style "user")
;;	  (c-set-style "soustroup")
;;	  (c-set-style "java")
;    	  (setq c-indent-level 4
;    	        c-continued-statement-offset 4
;    	        c-argdecl-indent 4
;		c-brace-offset 0
;    	        c-continued-brace-offset -4
;		c-brace-imaginary-offset 0
;		c-label-offset -2
;    	        c-auto-newline t
;		c-hanging-semi&comma-criteria '(no-newline)
;		truncate-lines t
;    	        comment-column 60)
;    	  (font-lock-mode 1)
;	  (define-key c-mode-map [S-tab] 'c-indent-command)
    ))
)
(add-hook 'c++-mode-hook
    (function (lambda ()
	  (c-set-style "user")
;	  (c-set-style "BSD")
;    	  (setq c-indent-level 4
;    	        c-continued-statement-offset 4
;    	        c-argdecl-indent 4
;		c-brace-offset 0
;    	        c-continued-brace-offset -4
;		c-brace-imaginary-offset 0
;		c-label-offset -2
;    	        c-auto-newline t
;		c-hanging-semi&comma-criteria '(no-newline)
;		truncate-lines t
;    	        comment-column 60)
;    	  (font-lock-mode 1)
;	  (define-key c++-mode-map [S-tab] 'c-indent-command)
   ))
)

;(add-hook 'perl-mode-hook
;    (function (lambda ()
;    	  (setq perl-indent-level 4
;    	        perl-continued-statement-offset 4
;    	        perl-argdecl-indent 4
;		perl-brace-offset 0
;    	        perl-continued-brace-offset -4
;		perl-brace-imaginary-offset 0
;		perl-label-offset -2
;    	        perl-auto-newline t
;		truncate-lines t
;    	        comment-column 60)
;    	  (font-lock-mode 1)
;	  (define-key perl-mode-map [S-tab] 'perl-indent-command)
;    ))
;)

;(if (featurep 'font-lock)
;    (require 'face-lock)
;  (add-hook 'font-lock-mode-hook '(lambda () (require 'face-lock))))

;(autoload 'turn-on-lazy-lock "lazy-lock"
;  "Unconditionally turn on Lazy Lock mode.")

;(add-hook 'font-lock-mode-hook 'turn-on-lazy-lock)
;(add-hook 'font-lock-mode-hook
;    (function (lambda ()
;        (setq lazy-lock-stealth-time 5
;              lazy-lock-delay-time 1))))

;--------------------------------------------------------------------------
;    Lisp-Mode Configuration
;--------------------------------------------------------------------------

;(add-hook 'emacs-lisp-mode-hook
;    (function (lambda ()
;	(font-lock-mode 1)
;    ))
;)

;--------------------------------------------------------------------------
;    Functions
;--------------------------------------------------------------------------

(defun enter-date nil
  "Enter today's date at point."
  (interactive)
  (shell-command "date '+&%B %d, %Y'" 1))

(defun recenter-to-top nil
   "Moves the current postion to the top of the window"
   (interactive)
   (recenter 3))

(defun tab4 nil
    "Sets tab width to 4."
    (interactive)
    (setq tab-width 4))

(defun tab8 nil
    "Sets tab width to 8."
    (interactive)
    (setq tab-width 8))

;--------------------------------------------------------------------------
;    Macros
;--------------------------------------------------------------------------

;(fset 'duplicate-line
;   "\C-a\C-k\C-k\C-y\C-y")

;(fset 'mark-it
;   "\C-@")

;(put 'erase-buffer 'disabled nil)

