;;; A minor mode that integrate multiple ELisp utilities based on etss to offer
;;; a universal experience of coding in TypeScript

;;;: Dependencies
(require 'etss)
(require 'company-etss)
(require 'flymake-etss)

(require 'typescript)

(define-minor-mode etss-ide-mode
  "Minor mode for TypeScript coding in Emacs."
  :lighter " ETSS"
  :keymap '()
  (when (eq major-mode 'typescript-mode)
    (etss-ide--setup-company)
    (etss-ide--setup-flymake)
    (etss-setup-current-buffer)
    (message "ETSS-IDE Loaded!")))

(defun etss-ide--setup-company ()
  (unless (memq 'company-etss company-backends)
    (add-to-list 'company-backends #'company-etss))
  (unless company-mode
    (company-mode 1))
  (message "ETSS-IDE: enable `company-etss' backend."))

(defun etss-ide--setup-flymake ()
  (unless (and (member flymake-etss--err-line-pattern flymake-err-line-patterns)
               (assoc ".+\\.ts$" flymake-allowed-file-name-masks))
    (flymake-etss-setup))
  (flymake-mode 1)
  (message "ETSS-IDE: enable `flymake-etss'."))

(provide 'etss-ide)
