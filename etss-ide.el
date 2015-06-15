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
  (if (eq major-mode 'typescript-mode)
      (cond
       (etss-ide-mode
        (etss-setup-current-buffer)
        (etss-ide--setup-company)
        (etss-ide--setup-flymake)
        (etss-ide--setup-extra-keymap)
        (message "ETSS-IDE Loaded!"))
       ;; disable
       (t
        (flymake-mode-off)
        ;; TODO restore keymap
        ;; TODO clean up various ETSS status for the buffer
        (message "ETSS-IDE unloaded.")))
    (error "ETSS-IDE: can't be used for non-TypeScript files.")))

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
  (flymake-mode-on)
  (message "ETSS-IDE: enable `flymake-etss'."))

(defun etss-ide--setup-extra-keymap ()
  ;;; TODO how to revert this setup?
  (define-key typescript-mode-map
    (kbd "M-.") #'etss-ide--jump-to-definition))

(defun etss-ide--jump-to-definition ()
  "Jump to definition at point."
  (interactive)
  (let ((ret (etss--get-definition))
        deffile col line)
    (if (null ret)
        (message "ETSS: No definition found at point!")
      (setq deffile (etss-utils/assoc-path ret 'file)
            line (etss-utils/assoc-path ret '(min line))
            col (etss-utils/assoc-path ret '(min character)))
      ;; TODO better integration with `find-tag'?
      (ring-insert find-tag-marker-ring (point-marker))

      (find-file deffile)
      (goto-char (point-min))
      (forward-line (- line 1))
      (forward-char (- col 1)))))

(provide 'etss-ide)
