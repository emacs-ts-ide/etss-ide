;;; A minor mode that integrate multiple ELisp utilities based on etss to offer
;;; a universal experience of coding in TypeScript

;;;: Dependencies
;; (require 'etss)
;; (require 'company-etss)
;; (require 'flymake-etss)
;; (require 'typescript)

(define-minor-mode etss-ide-mode
  "Minor mode for TypeScript coding in Emacs."
  :lighter " ETSS"
  :keymap '()
  (when (eq major-mode 'typescript-mode)
    (message "ETSS-IDE Loaded!")))

(provide 'etss-ide)
