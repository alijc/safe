;;; Current Column mode for GNU Emacs (version 19)
;;; Copyright (C) 1994 Kyle E. Jones
;;;
;;; This program is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 1, or (at your option)
;;; any later version.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; A copy of the GNU General Public License can be obtained from this
;;; program's author (send electronic mail to kyle@uunet.uu.net) or from
;;; the Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA
;;; 02139, USA.
;;;
;;; Send bug reports to kyle@wonderworks.com
;;
;; M-x current-column-mode  toggles the mode.
;; 
;; Put this file somewhere Emacs can find it (see load-path).
;; Name it colmode.el.
;; Byte-compile it.  M-x byte-compile-file.
;; Put (require 'colmode) in your .emacs file.
;;
;; The code at the end of this file tries to install the current
;; column mode display variable somewhere reasonable in the
;; modeline.  It works fine with the default mode line format.
;; If you've customized your mode line, you may want to comment
;; out the mode line isntallation code and set it up yourself.
;; The variable that contains the current column information is
;; mode-line-current-column.

(provide 'colmode)

(defvar current-column-mode nil
  "Non-nil means Current Column mode is on.")

(defvar mode-line-current-column nil
  "Current column (for mode line).
Becomes local when set in any fashion.")
(make-variable-buffer-local 'mode-line-current-column)

(defun mode-line-current-column ()
  (if current-column-mode
      (let ((col (current-column)))
	;; do all this instead of using (format ...) to avoid
	;; consing stacks and stacks of small strings.
	(if (not (stringp mode-line-current-column))
	    (setq mode-line-current-column (make-string 3 ?\ )))
	(aset mode-line-current-column 2 (+ (% col 10) ?0))
	(setq col (/ col 10))
	(aset mode-line-current-column 1 (+ (% col 10) ?0))
	(setq col (/ col 10))
	(aset mode-line-current-column 0 (+ (% col 10) ?0))
	(force-mode-line-update))))

(defun current-column-mode (&optional arg)
  "Toggle Current Column mode.
With arg, turn Current Column mode on iff arg is positive.
When Current Column mode is enabled, the current column number
appears in the mode line."
  (interactive "P")
  (setq current-column-mode (or (and arg (> (prefix-numeric-value arg) 0))
				(and (null arg) (null current-column-mode)))))

(or (memq 'mode-line-current-column post-command-hook)
    (add-hook 'post-command-hook 'mode-line-current-column))

;; install mode-line-current-column into mode-line-format
(let ((tail (member '(-3 . "%p") mode-line-format))
      (format '(current-column-mode
		("" "C" mode-line-current-column "--"))))
  (if tail
      (progn
	(setcar tail format)
	(setcdr tail (cons '(-3 . "%p") (cdr tail))))))
