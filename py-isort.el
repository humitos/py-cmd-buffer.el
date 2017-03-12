;;; py-isort.el --- Use isort to sort the imports in a Python buffer

;; Copyright (C) 2017, Manuel Kaufmann <humitos@gmail.com>

;; Author: Manuel Kaufmann <humitos@gmail.com>
;; URL: https://github.com/humitos/py-cmd-buffer.el
;; Version: 0.2
;; Package-Requires: ((buftra "0.6"))

;;; Commentary:

;; Provides commands, which use the external "isort" tool
;; to tidy up the imports in the current buffer.

;; To automatically sort imports when saving a python file, use the
;; following code:

;;   (add-hook 'pythom-mode-hook 'py-isort-enable-on-save)

;; To customize the behaviour of "isort" you can set the
;; py-isort-options e.g.

;;   (setq py-isort-options '("--lines=100"))

;;; Code:

(require 'buftra)

(defgroup py-isort nil
  "Use isort to sort the imports in a Python buffer."
  :group 'convenience
  :prefix "py-isort-")


(defcustom py-isort-options nil
  "Options used for isort."
  :group 'py-isort
  :type '(repeat (string :tag "option")))

(defcustom py-isort-enabled t
  "Wheter or not run \"isort\" command even if the hook is ran."
  :group 'py-isort
  :type 'boolean)

(defun py-isort--find-settings-path ()
  (expand-file-name
   (or (locate-dominating-file buffer-file-name ".isort.cfg")
       (file-name-directory buffer-file-name))))


(defun py-isort--call-executable (errbuf file)
  (let ((default-directory (py-isort--find-settings-path)))
    (zerop (apply 'call-process "isort" nil errbuf nil
                  (append `(" " , file, " ",
                            (concat "--settings-path=" default-directory))
                          py-isort-options)))))


;;;###autoload
(defun py-isort-buffer ()
  "Uses the \"isort\" tool to reformat the current buffer."
  (interactive)
  (if py-isort-enabled
      (buftra--apply-executable-to-buffer "isort"
                                          'py-isort--call-executable
                                          nil
                                          "py"
                                          nil)))


;;;###autoload
(defun py-isort-enable-on-save ()
  "Pre-save hook to be used before running isort."
  (interactive)
  (add-hook 'before-save-hook 'py-isort-buffer nil t))

(provide 'py-isort)

;;; py-isort.el ends here
