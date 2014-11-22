;;; 
;;; crosshairs.el: highlight current line/column using hl-line(+).el/col-highlight.el
;; http://www.emacswiki.org/emacs/CrosshairHighlighting
(require 'crosshairs)
;; (toggle-crosshairs-when-idle t) ; No need for crosshairs when idle
;; (col-highlight-set-interval 60)
;;
;; hl-line+.el: highlight current line only (no column)
;; http://www.emacswiki.org/emacs/HighlightCurrentLine#toc3
;; (require 'hl-line+)		; required by crosshairs already
;; (toggle-hl-line-when-idle t)	; turned on line highlight when idle
;; (toggle-hl-line-when-idle nil)	; turned off line highlight when idle
(hl-line-when-idle-interval 60)
;;
;; To customize the background color
;; (setq my-highlight-color "light goldenrod yellow")
(setq my-highlight-color "dark red")
(set-face-background 'hl-line	    my-highlight-color) ; Line color
(set-face-background 'col-highlight my-highlight-color)	; Column color
;; (set-face-background 'hl-line	    "light goldenrod yellow")   ; Line color
;; (set-face-background 'col-highlight "light goldenrod yellow")	; Column color
;; (set-face-background 'hl-line "lemon chiffon")		; Line color
;; (set-face-background 'col-highlight "lemon chiffon")		; Column color


;;;
;;; highligh-symbol for highlighting multiple occurences
;; http://nschum.de/src/emacs/highlight-symbol/
;; http://stackoverflow.com/questions/385661/emacs-highlight-all-occurences-of-a-word
(require 'highlight-symbol)
(global-set-key (kbd "C-.") 'highlight-symbol-at-point)
;; (global-set-key (kbd "C-\}") 'highlight-symbol-next)
;; (global-set-key (kbd "C-\{") 'highlight-symbol-prev)
;;
;; Define highlight-symbol-prev/next and recenter
(defun my-highlight-symbol-prev ()
  (interactive)
  (highlight-symbol-prev)
  (recenter))
(defun my-highlight-symbol-next ()
  (interactive)
  (highlight-symbol-next)
  (recenter))
;;
(global-set-key (kbd "C-\}") 'my-highlight-symbol-next)
(global-set-key (kbd "C-\{") 'my-highlight-symbol-prev)
(global-set-key (kbd "A-]") 'my-highlight-symbol-next)
(global-set-key (kbd "A-[") 'my-highlight-symbol-prev)


;;; 
;;; anzu.el 2014-02-01
;; http://shibayu36.hatenablog.com/entry/2013/12/30/190354
;; http://qiita.com/syohex/items/56cf3b7f7d9943f7a7ba
(require 'anzu)
;;
(global-anzu-mode +1)
(setq anzu-mode-lighter "")
(setq anzu-use-migemo t)
(setq anzu-search-threshold 1000)
(setq anzu-minimum-input-length 1)
;;
;; Define a large face (also used for multiple-cursors.el)
;; This was done in custom-set-faces.
;;
;; (global-set-key (kbd "C-c r") 'anzu-query-replace)
;; (global-set-key (kbd "C-c R") 'anzu-query-replace-regexp)


;;; 
;;; multiple-cursors for simultaneous editing multiple occurrences
;; https://github.com/magnars/multiple-cursors.el
;; http://ongaeshi.hatenablog.com/entry/20121205/1354672102 (for a similar package)
;; http://emacsrocks.com/e13.html (video)
;; http://rubikitch.com/2014/11/10/multiple-cursors/
;;
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
;; highlighting symbols only
(global-set-key (kbd "C-M->") 'mc/mark-next-symbol-like-this)
(global-set-key (kbd "C-M-<") 'mc/mark-previous-symbol-like-this)
(global-set-key (kbd "C-M-*") 'mc/mark-all-symbols-like-this)
;; highlighting all
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-*") 'mc/mark-all-like-this)
;;
;;(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
;;
;; What to display in the mode line while multiple-cursors-mode is active.
(setq mc/mode-line
      ;; `(" mc:" (:eval (format ,(propertize "%d" 'face 'font-lock-warning-face)
      ;; `(" mc:" (:eval (format ,(propertize "%d" 'face 'anzu-mode-line)	; Requires anzu.el
      `(" mc:" (:eval (format ,(propertize "%d" 'face 'anzu-mode-line)	; Requires anzu.el
			      (mc/num-cursors)))))


;;;
;;; phi-search.el
;; https://github.com/zk-phi/phi-search
;; https://www.youtube.com/watch?v=JSTO674y6Hcp
(require 'phi-search)



;;; 
;;; isearch the selected word 2014-02-01
;; http://shibayu36.hatenablog.com/entry/2013/12/30/190354
(defadvice isearch-mode (around isearch-mode-default-string (forward &optional regexp op-fun recursive-edit word-p) activate)
  (if (and transient-mark-mode mark-active (not (eq (mark) (point))))
      (progn
        (isearch-update-ring (buffer-substring-no-properties (mark) (point)))
        (deactivate-mark)
        ad-do-it
        (if (not forward)
            (isearch-repeat-backward)
          (goto-char (mark))
          (isearch-repeat-forward)))
    ad-do-it))

;;; 
;;; moccur-edit.el (el-get)
;; Requires color-moccur.el (elpa)
;; http://www.bookshelf.jp/elc/moccur-edit.el
;; http://d.hatena.ne.jp/higepon/20061226/1167098839
;; http://d.hatena.ne.jp/sandai/20120304/p2
(require 'moccur-edit)
;; Modified buffers are saved automatically.
(defadvice moccur-edit-change-file
  (after save-after-moccur-edit-buffer activate)
  (save-buffer))
;; Usage:
;; M-x moccur-grep-find to enter Moccur-grep, then objectName .R$
;; r to enter Moccur-edit. C-x C-s to save, C-c C-k


;;; 
;;; helm-c-moccur.el		; helm source for color-moccur.el
(require 'helm-c-moccur)
(global-set-key (kbd "M-o") 'helm-c-moccur-occur-by-moccur)
(global-set-key (kbd "C-M-o") 'helm-c-moccur-dmoccur)
(add-hook 'dired-mode-hook
          '(lambda ()
             (local-set-key (kbd "O") 'helm-c-moccur-dired-do-moccur-by-moccur)))
(global-set-key (kbd "C-M-s") 'helm-c-moccur-isearch-forward)
(global-set-key (kbd "C-M-r") 'helm-c-moccur-isearch-backward)

;;; 
;;; ag.el and wgrep-ag.el. Faster replacement for moccur-edit.el 2014-01-14
;; http://yukihr.github.io/blog/2013/12/18/emacs-ag-wgrep-for-code-grep-search/
;; https://github.com/Wilfred/ag.el
;; ag.el
(require 'ag)
(setq ag-arguments '("--smart-case" "--group" "--column" "--"))	; grouping is better.
(setq ag-highlight-search t)
(setq ag-reuse-buffers t)
(setq ag-reuse-window t)
;;
;; wgrep-ag.el
(require 'wgrep-ag)
(autoload 'wgrep-ag-setup "wgrep-ag")
(add-hook 'ag-mode-hook 'wgrep-ag-setup)
;; r in ag result buffer invokes edit mode. C-x C-s to save. C-x C-k to cancel.
(define-key ag-mode-map (kbd "r") 'wgrep-change-to-wgrep-mode)

;;; 
;;; highlight-sexp.el
;; http://www.emacswiki.org/emacs/HighlightSexp
;; Color M-x list-colors-display  to check good colors
(require 'highlight-sexp)
;; (setq hl-sexp-background-color "thistle1")
;; (setq hl-sexp-background-color "snow1")
;; (setq hl-sexp-background-color "CadetBlue1") ; for light background
(setq hl-sexp-background-color "dark red") ; for dark background
;; (add-hook 'lisp-mode-hook 'highlight-sexp-mode)
;; (add-hook 'emacs-lisp-mode-hook 'highlight-sexp-mode)
;; (add-hook 'ess-mode-hook 'highlight-sexp-mode)	; Not turned on by default use sx to toggle


;;; 
;;; expand-region.el
;; https://github.com/magnars/expand-region.el
(require 'expand-region)
(global-set-key (kbd "C-,") 'er/expand-region)
(global-set-key (kbd "C-M-,") 'er/contract-region)


;;; 
;;; cmigemo (installed from Homebrew)
;; Mac-only configuration
(when (eq system-type 'darwin)
  ;; Used brew to install cmigemo
  ;; Used M-x list-package to install migemo.el (github)
  ;; Configured refering to: http://d.hatena.ne.jp/ground256/20111008/1318063872
  (require 'migemo)
  (setq migemo-command "/usr/local/bin/cmigemo")
  (setq migemo-options '("-q" "--emacs"))
  (setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")
  (setq migemo-user-dictionary nil)
  (setq migemo-coding-system 'utf-8-unix)
  (setq migemo-regex-dictionary nil)
  (load-library "migemo")
  (migemo-init)
  )


;;; 
;;; rainbow-mode.el
;; Make strings describing colors appear in colors
;; http://julien.danjou.info/projects/emacs-packages
(require 'rainbow-mode)
;;
;; Colors in R
;; use the following code to generate the list in R
;; output_colors <- function(colors) {for(color in colors) {col <- col2rgb(color); cat(sprintf("(\"%s\" . \"#%02X%02X%02X\")\n",color,col[1],col[2],col[3]));}}
;; output_colors(colors())
;; See variable rainbow-r-colors-alist


;;; 
;;; rainbow-blocks.el
;;
;; Rainbow-blocks highlights blocks made of parentheses, brackets, and
;; braces according to their depth. Each successive level is
;; highlighted in a different color. This makes it easy to orient
;; yourself in the code, and tell which statements are at a given
;; level.
(require 'rainbow-blocks)


;;;
;;; Temprary fix for void cua-replace-region
;; https://github.com/Fuco1/smartparens/issues/271 
(unless (fboundp 'cua-replace-region)
  (defun cua-replace-region ()
    "Replace the active region with the character you type."
    (interactive)
    (let ((not-empty (and cua-delete-selection (cua-delete-region))))
      (unless (eq this-original-command this-command)
        (let ((overwrite-mode
               (and overwrite-mode
                    not-empty
                    (not (eq this-original-command 'self-insert-command)))))
          (cua--fallback))))))

;;;
;;; ACE-JUMP-MODE-RELATED
;;; ace-jump-mode.el
;; https://github.com/winterTTr/ace-jump-mode
;; http://d.hatena.ne.jp/rkworks/20120520/1337528737
(require 'ace-jump-mode)
;; rubikitch setting Software Design September 2014
;; (setq ace-jump-mode-gray-background nil)
;; If we need to ask for the query char before entering `ace-jump-word-mode'
;; (setq ace-jump-word-mode-use-query-char nil)
;; This is optimized for JIS keyboards.
;; (setq ace-jump-mode-move-keys (append "asdfghjkl;:]qwertyuiop@zxcvbnm,." nil))
(global-set-key (kbd "s-a") 'ace-jump-word-mode)
;;
;; Radical setting using H- bindings
;; http://d.hatena.ne.jp/rkworks/20120520/1337528737
(defun add-keys-to-ace-jump-mode (prefix c &optional mode)
  (define-key global-map
    (read-kbd-macro (concat prefix (string c)))
    `(lambda ()
       (interactive)
       (funcall (if (eq ',mode 'word)
                    #'ace-jump-word-mode
                  #'ace-jump-char-mode) ,c))))
;;
;; Numbers and characters
;; (loop for c from ?0 to ?9 do (add-keys-to-ace-jump-mode "H-" c))
;; (loop for c from ?a to ?z do (add-keys-to-ace-jump-mode "H-" c))
;; (loop for c from ?0 to ?9 do (add-keys-to-ace-jump-mode "H-M-" c 'word))
;; (loop for c from ?a to ?z do (add-keys-to-ace-jump-mode "H-M-" c 'word))
;;
;; Everything
(loop for c from ?! to ?~ do (add-keys-to-ace-jump-mode "H-" c))
(loop for c from ?! to ?~ do (add-keys-to-ace-jump-mode "H-M-" c 'word))
(loop for c from ?! to ?~ do (add-keys-to-ace-jump-mode "M-s-" c))
;;
;;; ace-window.el
;; https://github.com/abo-abo/ace-window
(require 'ace-window)
(global-set-key (kbd "s-5") 'ace-window)
;;
;;; ace-jump-zap.el
;; https://github.com/waymondo/ace-jump-zap
(require 'ace-jump-zap)
;;
;;; ace-isearch.el
;; https://github.com/tam17aki/ace-isearch
(require 'ace-isearch)
(global-ace-isearch-mode +1)
;;
;; all characters, not just word beginning
(setq ace-isearch-submode 'ace-jump-char-mode)
;;
;; Delay before ace-jump kicks in
(setq ace-isearch-input-idle-delay 0.3)
;;
;; Use ace-isearch-funtion-from-isearch if the search term is longer than
(setq ace-isearch-input-length 600)
;; Give swoop additional bindings
(define-key helm-swoop-map (kbd "C-s") 'swoop-action-goto-line-next)
(define-key helm-swoop-map (kbd "C-r") 'swoop-action-goto-line-prev)
