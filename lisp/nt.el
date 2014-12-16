
;;; Add the `site-lisp' directory to the load path.
(setq load-path (cons (expand-file-name "f:/emacs/site-lisp/") load-path))
;;;(setq load-path (append load-path (list "f:/emacs/site-lisp/")))

;;; Use a special ftp executable.
(setq ange-ftp-ftp-program-name "f:/emacs/site-bin/ftp.exe")
;;; According to the documentation in
;;; `http://www.cs.uwashington.edu/homes/voelker/ntemacs.html' 
;;; the following line should also work:
;;;(setq exec-path (cons (expand-file-name "f:/emacs/site-bin") exec-path))


;;; Set the temporary file location to a directory that exists on
;;; the local machine.
(setq ange-ftp-tmp-name-template "f:/tmp/ange-ftp")


;;; This function will display the font that you pick
(defun disp-set-font (&rest fonts)
  (interactive)
   (print (win32-select-font)))


;;; Arbitrarily set the font to the one that I like.
(set-default-font "-*-Lucida Console-normal-r-*-*-11-82-*-*-*-c-*-*-ansi-")
