;;; flymake-shell.el --- A flymake syntax-checker for shell scripts
;;
;;; Copyright (C) 2011 Steve Purcell
;;; Author: Steve Purcell <steve@sanityinc.com>
;;; URL: https://github.com/purcell/flymake-shell
;;; Version: DEV
;;;
;;; Commentary:

;; Usage:

;;   (require 'flymake-shell)
;;   (add-hook 'sh-set-shell-hook 'flymake-shell-load)

(require 'flymake)


(defvar flymake-shell-supported-shells '(bash zsh))

(defcustom flymake-shell-err-line-pattern-re
  '(("^\\(.+\\): line \\([0-9]+\\): \\(.+\\)$" 1 2 nil 3) ; bash
    ("^\\(.+\\):\\([0-9]+\\): \\(.+\\)$" 1 2 nil 3)) ; zsh
  "Regexp matching JavaScript error messages.")

(defun flymake-shell-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
		     'flymake-create-temp-inplace))
	 (local-file (file-relative-name
		      temp-file
		      (file-name-directory buffer-file-name))))
    (list (format "%s" sh-shell) (append '("-n") (list local-file)))))

;;;###autoload
(defun flymake-shell-load ()
  (unless (eq 'sh-mode major-mode)
    (error "cannot enable flymake-shell in this major mode"))
  (if (memq sh-shell flymake-shell-supported-shells)
      (progn
        (make-variable-buffer-local 'flymake-allowed-file-name-masks)
        (setq flymake-allowed-file-name-masks '(("." flymake-shell-init)))
        (make-variable-buffer-local 'flymake-err-line-patterns)
        (setq flymake-err-line-patterns flymake-shell-err-line-pattern-re)
        (flymake-mode t)
        (local-set-key (kbd "C-c d") 'flymake-display-err-menu-for-current-line))
    (message "Shell %s is not supported by flymake-shell" sh-shell)))

(provide 'flymake-shell)

;;; flymake-shell.el ends here
