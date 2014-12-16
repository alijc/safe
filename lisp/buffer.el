
(defun tpu-next-buffer nil
  "Go to next buffer in ring."
  (interactive)
  (switch-to-buffer (car (reverse (buffer-list)))))

(defun tpu-previous-file-buffer nil
  "Go to previous buffer in ring that is visiting a file or directory."
  (interactive)
  (let ((list (tpu-make-file-buffer-list (buffer-list))))
    (setq list (delq (current-buffer) list))
    (if (not list) (error "No other buffers."))
    (switch-to-buffer (car list))))

(defun tpu-next-file-buffer nil
  "Go to next buffer in ring that is visiting a file or directory."
  (interactive)
  (let ((list (tpu-make-file-buffer-list (buffer-list))))
    (setq list (delq (current-buffer) list))
    (if (not list) (error "No other buffers."))
    (switch-to-buffer (car (reverse list)))))

(defun tpu-previous-non-file-buffer nil
  "Go to previous buffer in ring that is NOT visiting a file or directory."
  (interactive)
  (let ((list (tpu-make-non-file-buffer-list (buffer-list))))
    (setq list (delq (current-buffer) list))
    (if (not list) (error "No other buffers."))
    (switch-to-buffer (car list))))

(defun tpu-next-non-file-buffer nil
  "Go to next buffer in ring that is NOT visiting a file or directory."
  (interactive)
  (let ((list (tpu-make-non-file-buffer-list (buffer-list))))
    (setq list (delq (current-buffer) list))
    (if (not list) (error "No other buffers."))
    (switch-to-buffer (car (reverse list)))))

(defun tpu-make-file-buffer-list (buffer-list)
  "Returns names from BUFFER-LIST excluding those beginning with a space or star."
  (delq nil (mapcar '(lambda (b)
                       (if (or (= (aref (buffer-name b) 0) ? )
                               (= (aref (buffer-name b) 0) ?*)) nil b))
                    buffer-list)))

(defun tpu-make-non-file-buffer-list (buffer-list)
  "Returns those names from BUFFER-LIST that begin with a space or star."
  (delq nil (mapcar '(lambda (b)
                       (if (not (or (= (aref (buffer-name b) 0) ? )
                                    (= (aref (buffer-name b) 0) ?*))) nil b))
                    buffer-list)))
