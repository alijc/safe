;;;; This's a stripped down version of:

;;; tpu-edt.el --- Emacs emulating TPU emulating EDT

;; Copyright (C) 1993, 1994 Free Software Foundation, Inc.

;; Author: Rob Riepel <riepel@networking.stanford.edu>
;; Maintainer: Rob Riepel <riepel@networking.stanford.edu>
;; Version: 4.0
;; Keywords: emulations

;;;; All that's left is the insert-formfeed function (formerly
;;;; tpu-insert-formfeed).


(defun insert-formfeed nil
  "Inserts a formfeed character."
  (interactive)
  (insert "\C-L"))

(define-key global-map "\C-l" 'insert-formfeed)           ; ^L (FF)
