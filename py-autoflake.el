;;; py-autoflake.el --- Use autoflake to remove unused imports and
;;; unused variables as reported by pyflakes.

;; Copyright (C) 2016-2017, Manuel Kaufmann <humitos@gmail.com>

;; Author: Manuel Kaufmann <humitos@gmail.com>
;; URL: https://github.com/humitos/py-autoflake.el
;; Version: 0.2
;; Package-Requires: ((buftra "0.6"))

;;; Commentary:

;; Provides the `py-autoflake.el' command, which uses the external
;; "autoflake" tool to remove unused imports and unused variables as
;; reported by pyflakes.

;; To automatically apply when saving a python file, use the
;; following code:

;;   (add-hook 'python-mode-hook 'py-autoflake-enable-on-save)

;; To customize the behaviour of "autoflake" you can set the
;; py-autoflake-options e.g.

;;   (setq py-autoflake-options '("--remove-all-unused-imports" "--remove-unused-variables"))

;; To disable this command at certain situation you can set
;; py-autoflake-enabled to nil e.g.

;;  (setq py-autoflake-enabled nil)

;;; Code:

(require 'buftra)

(defgroup py-autoflake nil
  "Use autoflake to beautify a Python buffer."
  :group 'convenience
  :prefix "py-autoflake-")


(defcustom py-autoflake-options nil
  "Options used for autoflake.

Note that `--in-place' is used by default."
  :group 'py-autoflake
  :type '(repeat (string :tag "option")))

(defcustom py-autoflake-enabled t
  "Wheter or not run \"autoflake\" command even if the hook is ran."
  :group 'py-autoflake
  :type 'boolean)

(defun py-autoflake--call-executable (errbuf file)
  (zerop (apply 'call-process "autoflake" nil errbuf nil
                (append py-autoflake-options `("--in-place", file)))))


;;;###autoload
(defun py-autoflake-buffer ()
  "Uses the \"autoflake\" tool to reformat the current buffer."
  (interactive)
  (if py-autoflake-enabled
      (buftra--apply-executable-to-buffer "autoflake"
                                          'py-autoflake--call-executable
                                          nil
                                          "py"
                                          nil)))


;;;###autoload
(defun py-autoflake-enable-on-save ()
  "Pre-save hook to be used before running autoflake."
  (interactive)
  (add-hook 'before-save-hook 'py-autoflake-buffer nil t))

(provide 'py-autoflake)

;;; py-autoflake.el ends here
