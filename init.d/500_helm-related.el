;;; Helm (Anything successor)
;; http://d.hatena.ne.jp/a_bicky/20140104/1388822688		; arabiki
;; http://d.hatena.ne.jp/a_bicky/20140125/1390647299		; arabiki 2
;; http://sleepboy-zzz.blogspot.com/2012/09/anythinghelm.html	; in general
;; http://d.hatena.ne.jp/syohex/20121207/1354885367		; some useful tips


;; Temporary fix for name change
;; https://github.com/emacs-helm/helm/commit/8cb7a9e0b98175845a68309e2dd9850bd0f02a28
(defalias 'helm--make-source 'helm-make-source)


;; Activate helm
(require 'helm-config)
(require 'helm-command)
;;
;;
(setq helm-idle-delay             0.3
      helm-input-idle-delay       0.3
      helm-candidate-number-limit 200
      helm-M-x-always-save-history t)
;;
;; Disabled because it was giving an error 2013-11-22
(setq helm-locate-command "")
;;
(require 'cl)
(let ((key-and-func
       `(;;(,(kbd "C-x C-f") helm-find-files)
         (,(kbd "M-x")     helm-M-x)
         (,(kbd "C-M-x")   execute-extended-command)
         (,(kbd "C-z")     helm-for-files)
         (,(kbd "M-y")     helm-show-kill-ring)
         (,(kbd "C-x b")   helm-buffers-list)
         (,(kbd "C-x C-r") helm-recentf)
         ;;
         (,(kbd "C-^")     helm-c-apropos)
         (,(kbd "C-;")     helm-resume)
         (,(kbd "s-c")     helm-occur)
         (,(kbd "M-z")     helm-do-grep)
         (,(kbd "C-S-h")   helm-descbinds))))
  (loop for (key func) in key-and-func
        do (global-set-key key func)))
;;
;; (define-key global-map (kbd "C-x b")   'helm-buffers-list)
;; (define-key global-map (kbd "C-x C-r") 'helm-recentf)
;;
;; helm for isearch 2014-02-01
;; http://shibayu36.hatenablog.com/entry/2013/12/30/190354
(define-key isearch-mode-map (kbd "C-o") 'helm-occur-from-isearch)
;;
;; Emulate `kill-line' in helm minibuffer
;; http://d.hatena.ne.jp/a_bicky/20140104/1388822688
(setq helm-delete-minibuffer-contents-from-point t)
(defadvice helm-delete-minibuffer-contents (before helm-emulate-kill-line activate)
  "Emulate `kill-line' in helm minibuffer"
  (kill-new (buffer-substring (point) (field-end))))
;;
;;
;;; debug
;; (defvar *helm for files*) in helm.el
;; 2014-09-21 Add the following to test how auctex works with this
;; (setq helm-buffer "*helm for files*")



;;;
;;; Optional helm packages
;;
;;; helm-descbinds.el
;; Replace describe-bindings with helm interface
;; http://emacs-jp.github.io/packages/helm/helm-descbinds.html
;; http://d.hatena.ne.jp/buzztaiki/20081115/1226760184 (anything version)
(use-package helm-descbinds
  :commands (helm-descbinds)
  :config
  (helm-descbinds-mode))


;;; helm-migemo.el
;; https://github.com/emacs-jp/helm-migemo
;; http://sleepboy-zzz.blogspot.com/2013/02/helm-migemo.html
(use-package helm-migemo
  ;; Mac-only
  :if (eq system-type 'darwin))


;;; wgrep-helm.el  2014-01-14
;; Writable helm-grep-mode buffer and apply the changes to files
(use-package wgrep-helm)


;;; helm-ag.el
;; https://github.com/syohex/emacs-helm-ag
;; http://qiita.com/l3msh0@github/items/97909d6e2c92af3acc00
(use-package helm-ag
  :commands (helm-ag helm-ag-this-file)
  :config
  (setq helm-ag-base-command "ag --nocolor --nogroup --ignore-case")
  (setq helm-ag-command-option "--all-text")
  (setq helm-ag-thing-at-point 'symbol))



;;; helm-open-github
;;  2014-02-01 OAutho required
;; http://shibayu36.hatenablog.com/entry/2013/01/18/211428
(use-package helm-open-github
  :commands (helm-open-github-from-file
             helm-open-github-from-commit
             helm-open-github-from-issues))


;;; helm-mode-manager.el
;; Select and toggle major and minor modes with helm
;; https://github.com/istib/helm-mode-manager
(use-package helm-mode-manager
  :commands (helm-switch-major-mode
             helm-enable-minor-mode
             helm-disable-minor-mode))


;;; helm-dash.el
;; http://fukuyama.co/helm-dash
;; http://kapeli.com/dash
(use-package helm-dash
  :commands (helm-dash
             helm-dash-at-point))


;;; helm-swoop.el
(use-package helm-swoop
  :bind ("s-s" . helm-swoop))
;; Give swoop additional bindings
;; (define-key helm-swoop-map (kbd "C-s") 'swoop-action-goto-line-next)
;; (define-key helm-swoop-map (kbd "C-r") 'swoop-action-goto-line-prev)
