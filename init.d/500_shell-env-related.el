;;; shell environments

;;; exec-path-from-shell.el to configure correct $PATH for external files
;; http://d.hatena.ne.jp/syohex/20130718/1374154709
;; check with (getenv "PATH")
(require 'exec-path-from-shell)
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))
;;
;; OBSOLETE
;; System-specific configuration
;; http://stackoverflow.com/questions/1817257/how-to-determine-operating-system-in-elisp
;; (when (eq system-type 'darwin)
;;   Mac only
;;   $PATH for external commands		; Necessary for AUCtex platex coordination
;;   http://emacswiki.org/emacs/EmacsApp
;;   http://rforge.org/2011/08/16/sane-path-variable-in-emacs-on-mac-os-x/
;;   You can use them to have the same PATH as .bashrc sets
;;   (if (not (getenv "TERM_PROGRAM"))
;;       (setenv "PATH"
;;   	      (shell-command-to-string "source $HOME/.bashrc && printf $PATH")))
;;   )


;;; essh.el for shell (like ESS for R
;; http://www.emacswiki.org/emacs/essh.el
;; Obsolete
;; http://stackoverflow.com/questions/6286579/emacs-shell-mode-how-to-send-region-to-shell
(require 'essh)
(defun essh-sh-hook ()
  (define-key sh-mode-map (kbd "C-c C-r") 'pipe-region-to-shell)
  (define-key sh-mode-map (kbd "C-c C-b") 'pipe-buffer-to-shell)
  (define-key sh-mode-map (kbd "C-c C-j") 'pipe-line-to-shell)
  (define-key sh-mode-map (kbd "C-c C-n") 'pipe-line-to-shell-and-step)
  (define-key sh-mode-map (kbd "C-c C-f") 'pipe-function-to-shell)
  (define-key sh-mode-map (kbd "C-c C-d") 'shell-cd-current-directory))
(add-hook 'sh-mode-hook 'essh-sh-hook)
;;
;;
;; bash-completion in emacs' shell (M-x shell)
;; http://stackoverflow.com/questions/163591/bash-autocompletion-in-emacs-shell-mode
;; https://github.com/szermatt/emacs-bash-completion
;;
;; http://www.namazu.org/~tsuchiya/elisp/shell-command.el
(require 'shell-command)
(shell-command-completion-mode)
;;
;; https://github.com/szermatt/emacs-bash-completion
(autoload 'bash-completion-dynamic-complete
  "bash-completion"
  "BASH completion hook")
(add-hook 'shell-dynamic-complete-functions
	  'bash-completion-dynamic-complete)
(add-hook 'shell-command-complete-functions
	  'bash-completion-dynamic-complete)

;; shell scripts saved with chmod +x
(add-hook 'after-save-hook
	  'executable-make-buffer-file-executable-if-script-p)


;; 2014-04-16 commented out. Error in 24.4
;; Eval error  Symbol's function definition is void: ad-advised-definition-p
;;
;; ;; multi-term.el
;; ;; rubikitch book p199
;; (require 'multi-term)
;; (setq multi-term-program "/bin/bash")
;; ;; Key not used by term
;; (setq term-unbind-key-list '("C-x" "C-c" "<ESC>"))
;; ;; Assign these commands (part of what is in the definition file).
;; (setq term-bind-key-alist
;;       '(("C-c C-c" . term-interrupt-subjob)
;; 	("C-m" . term-send-raw)
;; 	("M-f" . term-send-forward-word)
;; 	("M-b" . term-send-backward-word)
;; 	("M-o" . term-send-backspace)
;; 	("M-p" . term-send-up)
;; 	("M-n" . term-send-down)
;; 	("M-M" . term-send-forward-kill-word)
;; 	("M-N" . term-send-backward-kill-word)
;; 	("M-r" . term-send-reverse-search-history)
;; 	("M-," . term-send-input)
;; 	("M-." . comint-dynamic-complete)
;; 	))



;; flymake-shell.el 2013-12-27
;; https://github.com/purcell/flymake-easy
(require 'flymake-shell)
(add-hook 'sh-set-shell-hook 'flymake-shell-load)


;; SSH support 2014-01-15
;; Support for remote logins using `ssh'.
;; This program is layered on top of shell.el; the code here only accounts
;; for the variations needed to handle a remote process, e.g. directory
;; tracking and the sending of some special characters.
;;
;; If you wish for ssh mode to prompt you in the minibuffer for
;; passwords when a password prompt appears, just enter m-x send-invisible
;; and type in your line, or add `comint-watch-for-password-prompt' to
;; `comint-output-filter-functions'.
(require 'ssh)
;;
;; Completion. Not functional as of 2014-01-18.
;; https://github.com/ieure/ssh-el
(add-hook 'ssh-mode-hook
	  (lambda ()
	    (setq ssh-directory-tracking-mode 'ftp)	; Using the function with the same name is better?
	    (shell-dirtrack-mode t)))


;; Shell Dirtrack By Prompt 2014-01-17. Not functional yet
;; http://www.emacswiki.org/emacs/ShellDirtrackByPrompt
;; http://nflath.com/2009/09/dirtrack-mode/
;; First, program your shell prompt to emit the PWD
;; ~/.bashrc
;; if [ $EMACS ]; then
;;     # Emit the PWD in the prompt, taking care that it doesn't get truncated.
;;     PS1='\n\u@\h:$(pwd) \n\$ '
;; fi
;; Capture
;;
;; (require 'dirtrack)	; Check if this is necessary for eshell.
;; (add-hook 'shell-mode-hook
;;           (lambda ()
;; 	     ;; List for directory tracking.
;; 	     ;; First item is a regexp that describes where to find the path in a prompt.
;; 	     ;; Second is a number, the regexp group to match.
;; 	     ;; http://stackoverflow.com/questions/15812638/emacs-i-need-and-explanation-on-dirtrack-list-variable
;; 	     ;; (setq dirtrack-list '("^[^@]*@[^ ]*:\([^\]]*\) \$" 1))
;; 	     (setq dirtrack-list '("^[^@]*@\\([^:]*:[^$].*\\) \\$" 1))
;; 	     (dirtrack-mode 1)
;; 	     (shell-dirtrack-mode nil)
;; 	     ))
;;
;; This is probably about ssh'ing into a remote computer and using the emacs there.
;; http://nflath.com/2009/09/dirtrack-mode/
;; (add-hook 'dirtrack-directory-change-hook
;;           (lambda ()
;;             (let ((base-buffer-name (concat "shell-" default-directory "-shell"))
;;                   (i 1)
;;                   (full-buffer-name base-buffer-name))
;;               (while (get-buffer full-buffer-name)
;;                 (setq i (1+ i))
;;                 (setq full-buffer-name (concat base-buffer-name "<" (number-to-string i) ">")))
;;               (rename-buffer full-buffer-name))))
;; (add-hook 'shell-mode-hook
;;           (lambda ()
;;             (shell-dirtrack-mode -1)
;;             (insert "export PS1=\"nflath@/:\\w$ \"")
;;             (comint-send-input)
;;             (dirtrack-mode 1)
;;             ))

;; TRAMP (Transparent Remote Access, Multiple Protocols) 2014-01-17
;; Access remote files like local files
;; http://www.emacswiki.org/emacs/TrampMode
(require 'tramp)
(setq tramp-default-method "ssh")
;; Handle Odyssey's two-step authentication. Password:, then, Verification code:   2014-01-18
;; http://emacs.1067599.n5.nabble.com/emacs-hangs-when-connecting-from-windows-to-linux-with-tcsh-shell-td244075.html
;; (setq tramp-password-prompt-regexp "^.*\\([pP]assword\\|[pP]assphrase\\).*: ? *")	; Original
(setq tramp-password-prompt-regexp "^.*\\([pP]assword\\|[pP]assphrase\\|Verification code\\).*: ? *")
;;
;; Completion works in the eshell open from within a tramp connection
;; http://stackoverflow.com/questions/1346688/ssh-through-emacs-shell
