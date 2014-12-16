;Jan 27 -96, hniksic@jagor.srce.hr (Hrvoje Niksic), comp.emacs
; That is what I need. It is quite easy in vi (% in command-mode), or in
; joe (C-g), but I cannot find it in Emacs. I did find a lot of commands
; for moving around sexp-s, but I need exactly goto-matching-paren.

;This all time favourite function should be distributed with the
;emacs.... Erik!

;;; from:   michael@pbinfo.UUCP  or  michael@uni-paderborn.de
(defun vi-type-paren-match (arg)
  "Go to the matching parenthesis if on parenthesis otherwise insert %."
  (interactive "p")
  (cond ((looking-at "[([{]") (forward-sexp 1) (backward-char))
        ((looking-at "[])}]") (forward-char) (backward-sexp 1))
        (t (self-insert-command (or arg 1)))))


;(define-key global-map "%" 'vi-type-paren-match)

;--
;/Jari, "The Man who makes no mistakes does not usually make anything."

