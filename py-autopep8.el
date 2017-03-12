;;; py-autopep8.el --- Use autopep8 to beautify a Python buffer

;; Copyright (C) 2017, Manuel Kaufmann <humitos@gmail.com>

;; Author: Manuel Kaufmann <humitos@gmail.com>
;; URL: https://github.com/humitos/py-cmd-buffer.el
;; Version: 0.2
;; Package-Requires: ((buftra "0.6"))

;;; Commentary:

;; Provides the `py-autopep8' command, which uses the external "autopep8"
;; tool to tidy up the current buffer according to Python's PEP8.

;; To automatically apply when saving a python file, use the
;; following code:

;;   (add-hook 'python-mode-hook 'py-autopep8-enable-on-save)

;; To customize the behaviour of "autopep8" you can set the
;; py-autopep8-options e.g.

;;   (setq py-autopep8-options '("--max-line-length=100"))

;; To disable this command at certain situation you can set
;; py-autopep8-enabled to nil e.g.

;;  (setq py-autopep8-enabled nil)

;;; Code:

(require 'buftra)

(defgroup py-autopep8 nil
  "Use autopep8 to beautify a Python buffer."
  :group 'convenience
  :prefix "py-autopep8-")


(defcustom py-autopep8-options nil
  "Options used for autopep8.

Note that `--in-place' is used by default."
  :group 'py-autopep8
  :type '(repeat (string :tag "option")))

(defcustom py-autopep8-enabled t
  "Wheter or not run \"autopep8\" command even if the hook is ran."
  :group 'py-autopep8
  :type 'boolean)

(defun py-autopep8--call-executable (errbuf file)
  (zerop (apply 'call-process "autopep8" nil errbuf nil
                (append py-autopep8-options `("--in-place", file)))))


;;;###autoload
(defun py-autopep8-buffer ()
  "Uses the \"autopep8\" tool to reformat the current buffer."
  (interactive)
  (if py-autopep8-enabled
      (buftra--apply-executable-to-buffer "autopep8"
                                          'py-autopep8--call-executable
                                          nil
                                          "py"
                                          nil)))


;;;###autoload
(defun py-autopep8-enable-on-save ()
  "Pre-save hook to be used before running autopep8."
  (interactive)
  (add-hook 'before-save-hook 'py-autopep8-buffer nil t))

(provide 'py-autopep8)

;;; py-autopep8.el ends here
