
(setq mail-yank-prefix "> ")
(setq mail-signature t)
(setq mail-default-reply-to "ali@axian.com")
(setq mail-archive-file-name "~/Mail/sent.xmail")
(setq mail-personal-alias-file "~/.elm/aliases.emacs")
(add-hook 'mail-setup-hook 'mail-abbrevs-setup)

;;(load-library "rmail-new")
(setq rmail-display-summary t)
(setq rmail-summary-window-size 10)
(setq rmail-secondary-file-directory "~/Mail/")
(setq rmail-delete-after-output t)

(defun rmail-summary-reply-to-sender-only nil
    "Replies only to the sender."
    (interactive)
    (rmail-summary-reply t))

(add-hook 'rmail-summary-mode-hook
  (function (lambda ()
    (define-key rmail-summary-mode-map [backspace] 'rmail-summary-scroll-msg-down)
    (define-key rmail-summary-mode-map "R" 'rmail-summary-reply)
    (define-key rmail-summary-mode-map "r" 'rmail-summary-reply-to-sender-only)
)))

(add-hook 'rmail-get-new-mail-hook
  (function (lambda ()
    (if (file-exists-p "/users/ctlsys/alicec/.newmailhere" )
      (delete-file "/users/ctlsys/alicec/.newmailhere" ))
)))

