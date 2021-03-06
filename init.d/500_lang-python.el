;;;
;;; PYTHON SUPPORT-RELATED

;;;  python.el
;; http://superuser.com/questions/345595/python-el-for-long-time-python-mode-el-user
(use-package python
  :commands (python-mode)
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python[0-9.]*" . python-mode)
  :bind (:map python-mode-map
              ("C-m" . newline-and-indent)
              ("C-c c" . python-check))
  ;;
  :config
  (setq python-shell-interpreter (executable-find "python"))
  ;; Disable python-indent-dedent-line-backspace
  (unbind-key "DEl" python-mode-map))


;;;  anaconda-mode.el
;; Code navigation, documentation lookup and completion for Python.
;; https://github.com/proofit404/anaconda-mode
(use-package anaconda-mode
  :commands (anaconda-mode)
  :hook ((python-mode . anaconda-mode)
         ;; anaconda-eldoc-mode provide document function to eldoc-mode.
         (python-mode . anaconda-eldoc-mode)))


;;;  company-anaconda.el
;; https://github.com/proofit404/company-anaconda
(use-package company-anaconda
  :commands (company-anaconda-setup)
  :hook (python-mode . company-anaconda-setup)
  ;;
  :config
  (defun company-anaconda-setup ()
    "Add company-anaconda to company-backends buffer-locally."
    (add-to-list (make-local-variable 'company-backends)
                 ;; If you want to see anaconda-mode completions together with ones comes from inferior python process use company grouped backend instead:
                 '(company-anaconda :with company-capf))))


;;;  ein.el
(use-package ein-loaddefs
  :commands (ein:jupyter-server-start
             ein:jupyter-server-login-and-open
             ein:jupyterhub-connect
             ;; This is for old iPython Notebook
             ein:connect-to-notebook)
  :config
  (setq ein:notebook-autosave-frequency 10))


;;;
;;; hy-mode.el
;; https://github.com/hylang/hy-mode
;; http://docs.hylang.org/en/stable/
(use-package hy-mode
  :mode "\\.hy"
  :commands (company-hy-setup)
  :hook (hy . company-hy-setup)
  ;;
  :config
  (setq hy-mode-inferior-lisp-command (executable-find "hy"))
  ;;
  ;; Define company backend
  (defun company-hy-setup ()
    "Add company-hy to company-backends buffer-locally."
    (add-to-list (make-local-variable 'company-backends)
                 'company-hy)))
