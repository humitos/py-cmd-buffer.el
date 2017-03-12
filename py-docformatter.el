;;; py-docformatter.el --- Use docformatter to beautify a Python buffer

;; Copyright (C) 2017, Manuel Kaufmann <humitos@gmail.com>

;; Author: Manuel Kaufmann <humitos@gmail.com>
;; URL: https://github.com/humitos/py-cmd-buffer.el
;; Version: 0.2
;; Package-Requires: ((buftra "0.6"))

;;; Commentary:

;; Provides the `py-docformatter' command, which uses the external
;; "docformatter" tool to tidy up the current buffer according to
;; Python's PEP257.

;; To automatically apply when saving a python file, use the
;; following code:

;;   (add-hook 'python-mode-hook 'py-docformatter-enable-on-save)

;; To customize the behaviour of "docformatter" you can set the
;; py-docformatter-options e.g.

;;   (setq py-docformatter-options '("--wrap-summaries=100"))

;; To disable this command at certain situation you can set
;; py-docformatter-enabled to nil e.g.

;;  (setq py-docformatter-enabled nil)

;;; Code:

(require 'buftra)

(defgroup py-docformatter nil
  "Use docformatter to beautify a Python buffer."
  :group 'convenience
  :prefix "py-docformatter-")


(defcustom py-docformatter-options nil
  "Options used for docformatter.

Note that `--in-place' is used by default."
  :group 'py-docformatter
  :type '(repeat (string :tag "option")))

(defcustom py-docformatter-enabled t
  "Wheter or not run \"docformatter\" command even if the hook is ran."
  :group 'py-docformatter
  :type 'boolean)

(defun py-docformatter--call-executable (errbuf file)
  (zerop (apply 'call-process "docformatter" nil errbuf nil
                (append py-docformatter-options `("--in-place", file)))))


;;;###autoload
(defun py-docformatter-buffer ()
  "Uses the \"docformatter\" tool to reformat the current buffer."
  (interactive)
  (if py-docformatter-enabled
      (buftra--apply-executable-to-buffer "docformatter"
                                          'py-docformatter--call-executable
                                          nil
                                          "py"
                                          nil)))


;;;###autoload
(defun py-docformatter-enable-on-save ()
  "Pre-save hook to be used before running docformatter."
  (interactive)
  (add-hook 'before-save-hook 'py-docformatter-buffer nil t))

(provide 'py-docformatter)

;;; py-docformatter.el ends here
