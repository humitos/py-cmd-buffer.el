;;; py-unify.el --- Use unify command to use always the same quote.

;; Copyright (C) 2016-2017, Manuel Kaufmann <humitos@gmail.com>

;; Author: Manuel Kaufmann <humitos@gmail.com>
;; URL: https://github.com/humitos/py-unify.el
;; Version: 0.2
;; Package-Requires: ((buftra "0.6"))

;;; Commentary:

;; Provides the `py-unify' command, which uses the external "unify"
;; tool to modifies strings to all use the same quote where possible

;; To automatically apply when saving a python file, use the
;; following code:

;;   (add-hook 'python-mode-hook 'py-unify-enable-on-save)

;; To customize the behaviour of "unify" you can set the
;; py-unify-options e.g.

;;   (setq py-unify-options '("--quote='"))

;; To disable this command at certain situation you can set
;; py-unify-enabled to nil e.g.

;;  (setq py-unify-enabled nil)

;;; Code:

(require 'buftra)

(defgroup py-unify nil
  "Use unify to beautify a Python buffer."
  :group 'convenience
  :prefix "py-unify-")


(defcustom py-unify-options nil
  "Options used for unify.

Note that `--in-place' is used by default."
  :group 'py-unify
  :type '(repeat (string :tag "option")))

(defcustom py-unify-enabled t
  "Wheter or not run \"unify\" command even if the hook is ran."
  :group 'py-unify
  :type 'boolean)

(defun py-unify--call-executable (errbuf file)
  (zerop (apply 'call-process "unify" nil errbuf nil
                (append py-unify-options `("--in-place", file)))))


;;;###autoload
(defun py-unify-buffer ()
  "Uses the \"unify\" tool to reformat the current buffer."
  (interactive)
  (if py-unify-enabled
      (buftra--apply-executable-to-buffer "unify"
                                          'py-unify--call-executable
                                          nil
                                          "py"
                                          nil)))


;;;###autoload
(defun py-unify-enable-on-save ()
  "Pre-save hook to be used before running unify."
  (interactive)
  (add-hook 'before-save-hook 'py-unify-buffer nil t))

(provide 'py-unify)

;;; py-unify.el ends here
