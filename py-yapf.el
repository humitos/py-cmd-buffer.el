;;; py-yapf.el --- Use yapf to format the code.

;; Copyright (C) 2017, Manuel Kaufmann <humitos@gmail.com>

;; Author: Manuel Kaufmann <humitos@gmail.com>
;; URL: https://github.com/humitos/py-cmd-buffer.el
;; Version: 0.2
;; Package-Requires: ((buftra "0.6"))

;;; Commentary:

;; Provides the `py-yapf' command, which uses the external
;; "yapf" tool to remove unused imports and unused variables as
;; reported by pyflakes.

;; To automatically apply when saving a python file, use the
;; following code:

;;   (add-hook 'python-mode-hook 'py-yapf-enable-on-save)

;; To customize the behaviour of "yapf" you can set the
;; py-yapf-options e.g.

;;   (setq py-yapf-options '("--no-local-style" "--style=.my.yapf"))

;; To disable this command at certain situation you can set
;; py-yapf-enabled to nil e.g.

;;  (setq py-yapf-enabled nil)

;;; Code:

(require 'buftra)

(defgroup py-yapf nil
  "Use yapf to beautify a Python buffer."
  :group 'convenience
  :prefix "py-yapf-")


(defcustom py-yapf-options nil
  "Options used for yapf.

Note that `--in-place' is used by default."
  :group 'py-yapf
  :type '(repeat (string :tag "option")))

(defcustom py-yapf-enabled t
  "Wheter or not run \"yapf\" command even if the hook is ran."
  :group 'py-yapf
  :type 'boolean)

(defun py-yapf--call-executable (errbuf file)
  (zerop (apply 'call-process "yapf" nil errbuf nil
                (append py-yapf-options `("--in-place", file)))))


;;;###autoload
(defun py-yapf-buffer ()
  "Uses the \"yapf\" tool to reformat the current buffer."
  (interactive)
  (if py-yapf-enabled
      (buftra--apply-executable-to-buffer "yapf"
                                          'py-yapf--call-executable
                                          nil
                                          "py"
                                          nil)))


;;;###autoload
(defun py-yapf-enable-on-save ()
  "Pre-save hook to be used before running yapf."
  (interactive)
  (add-hook 'before-save-hook 'py-yapf-buffer nil t))

(provide 'py-yapf)

;;; py-yapf.el ends here
