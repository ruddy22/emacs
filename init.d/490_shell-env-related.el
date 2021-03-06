;;; SHELL ENVIRONMENT-RELATED

;;; Password prompt detection
;; https://emacs.stackexchange.com/questions/21116/how-to-prevent-emacs-from-showing-passphrase-in-m-x-shell
(setq comint-password-prompt-regexp
      (concat comint-password-prompt-regexp "\\|Verification code"))


;;;
;;; shell scripts saved with chmod +x
(add-hook 'after-save-hook
	  'executable-make-buffer-file-executable-if-script-p)


;;;
;;; shell.el
(use-package shell
  :commands (shell)
  :bind (:map my-key-map
              ("s" . shell)))


;;;
;;; sh-script.el
(use-package sh-script
  :bind (:map sh-mode-map
              ("M-s M-s" . buffer-do-async-shell-command)))


;;;
;;; exec-path-from-shell.el to configure correct $PATH for external files
;; https://github.com/purcell/exec-path-from-shell
;; check with (getenv "PATH")
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :config
  ;; https://github.com/purcell/exec-path-from-shell/issues/36
  ;; Do not pass "-i" (interactive shell) to save time.
  ;; bash options
  ;; -i If the -i option is present, the shell is interactive.
  ;; -l Make bash act as if it had been invoked as a login shell (see INVOCATION below).
  (setq exec-path-from-shell-arguments '("-l"))
  ;; Environment variables to copy.
  (setq exec-path-from-shell-variables '("PATH" "MANPATH"))
  ;; Call exec-path-from-shell-copy-envs on each element of exec-path-from-shell-variables.
  (exec-path-from-shell-initialize))


;;;
;;; shell-command.el
;; bash-completion in emacs' shell (M-x shell)
;; http://stackoverflow.com/questions/163591/bash-autocompletion-in-emacs-shell-mode
;; https://github.com/szermatt/emacs-bash-completion
;; http://www.namazu.org/~tsuchiya/elisp/shell-command.el
(use-package shell-command
  :commands (shell-command-completion-mode)
  :config
  ;; For bash-completion-dynamic-complete
  (use-package emacs-bash-completion)
  ;;
  (add-hook 'shell-dynamic-complete-functions
            'bash-completion-dynamic-complete)
  (add-hook 'shell-command-complete-functions
            'bash-completion-dynamic-complete)
  ;;
  (add-hook 'shell-mode-hook
            'shell-command-completion-mode))


;;;
;;; sudo-edit.el
;; https://github.com/nflath/sudo-edit
(use-package sudo-edit
  :commands (sudo-edit))


;;;
;;; SSH support
;;
;; Passphrase issue in OS X. Conflict with gpg-agent
;; How to pass the user-agent ssh key passphrase through to Emacs [i.e. for magit]?
;; https://www.reddit.com/r/emacs/comments/3skh5v/how_to_pass_the_useragent_ssh_key_passphrase/
;; SSH_AUTH_SOCK must be setenv'ed correctly in OS X. However, gpg-agent overrides this.
;; my-set-gpg-agent-info was the offender. Do not use if gpg-agent is not acting as ssh-agent.
;;
;; Code to fix SSH_AUTH_SOCK back to OS X-native
;; (when (eq system-type 'darwin)
;;   (setenv "SSH_AUTH_SOCK"
;;           (replace-regexp-in-string "\n$" ""
;;                                     (shell-command-to-string "ls /private/tmp/*launchd*/Listeners"))))
;;
;;
;;;  ssh.el
;; M-x ssh to run remote shell
;; https://github.com/ieure/ssh-el
;; http://www.emacswiki.org/emacs/ShellDirtrackByPrompt
(use-package ssh
  :commands (ssh)
  :config
  (setq ssh-directory-tracking-mode 'ftp)
  ;;
  (add-hook 'ssh-mode-hook
            (lambda ()
              (shell-dirtrack-mode t)
              (setq dirtrackp nil))))


;;;
;;; TRAMP (Transparent Remote Access, Multiple Protocols)
;; Access remote files like local files
;; http://www.emacswiki.org/emacs/TrampMode
;; ad-hoc multi-hop syntax
;; https://www.emacswiki.org/emacs/TrampMode#toc13
;; 5 Configuring TRAMP
;; http://www.gnu.org/software/tramp/#Configuration
;; 6.3 Declaring multiple hops in the file name
;; http://www.gnu.org/software/tramp/#Ad_002dhoc-multi_002dhops
;;;  tramp.el
(use-package tramp
  :config
  (setq tramp-verbose 10)
  ;; Default method to use for transferring files.
  ;; http://emacs.stackexchange.com/questions/13797/tramp-dired-transfers-files-inline-over-ssh-instead-of-using-scp-externaly
  ;; ssh is faster, but experience frequent invalid base64 data error
  (setq tramp-default-method "ssh")
  ;; scp is slower, but is safer.
  ;; (setq tramp-default-method "scp")
  ;; To respect the default method in tramp-default-method, use /host:/path/to/file.
  ;; This will automatically converted to /default-method:host:/path/to/file.
  ;;
  ;; Respect locally set path
  ;; http://emacs.stackexchange.com/questions/7673/how-do-i-make-trampeshell-use-my-environment-customized-in-the-remote-bash-p
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
  ;;
  ;; http://emacs.stackexchange.com/questions/22304/invalid-base64-data-error-when-using-tramp
  ;; The maximum file size where inline copying is preferred over an out-of-the-band copy.
  ;; If it is nil, out-of-the-band copy will be used without a check.
  (setq tramp-copy-size-limit nil)
  ;; The minimum size of compressing where inline transfer.
  (setq tramp-inline-compress-start-size nil)
  ;;
  ;; Handle Odyssey's two-step authentication. Password:, then, Verification code:   2014-01-18
  ;; http://emacs.1067599.n5.nabble.com/emacs-hangs-when-connecting-from-windows-to-linux-with-tcsh-shell-td244075.html
  ;; (setq tramp-password-prompt-regexp "^.*\\([pP]assword\\|[pP]assphrase\\).*: ? *")	; Original
  (setq tramp-password-prompt-regexp "^.*\\([pP]assword\\|[pP]assphrase\\|Verification code\\).*: ? *")
  ;;
  ;; Completion works in the eshell open from within a tramp connection
  ;; http://stackoverflow.com/questions/1346688/ssh-through-emacs-shell
  ;;
  ;; /sudo:hostname for sudo'ing after remote login
  ;; http://qiita.com/miyakou1982/items/d05e1ce07ad632c94720
  (add-to-list 'tramp-default-proxies-alist
               '(nil "\\`root\\'" "/ssh:%h:"))
  (add-to-list 'tramp-default-proxies-alist
               '("localhost" nil nil))
  (add-to-list 'tramp-default-proxies-alist
               '((regexp-quote (system-name)) nil nil))

  ;; Sudoing current file (need improvement for remote use)
  ;; https://www.reddit.com/r/emacs/comments/58zieq/still_cant_get_over_how_powerful_tramp_is/
  ;; (defun find-file-sudo ()
  ;;   "Reopen the current file as root, preserving point position."
  ;;   (interactive)
  ;;   (let ((p (point)))
  ;;     (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))
  ;;     (goto-char p)))
  )


;;;  tramp-term.el
;; https://github.com/randymorris/tramp-term.el
(use-package tramp-term
  :commands (tramp-term))


;;;
;;; Open in Terminal app
;; http://truongtx.me/2013/09/13/emacs-dired-new-terminal-window-at-current-directory-on-macos/
;; default terminal application path
(defvar osx-term-app-path
  "/Applications/Utilities/Terminal.app"
  "The path to the terminal application to use in open-in-osx-term-app")
;;
;; function to open new terminal window at current directory
(defun open-in-osx-term-app ()
  "Open current directory in dired mode in terminal application.
For OS X only"
  (interactive)
  (shell-command (concat "open -a "
                         (shell-quote-argument osx-term-app-path)
                         " "
                         (shell-quote-argument (file-truename default-directory)))))


;;;
;;; Gnu Privacy Guard (gpg)-related
;;
;;;  gpg-agent handling
;; http://whatthefuck.computer/blog/2015/05/20/re-agent/
;; (defun my-set-gpg-agent-info ()
;;   "Load your gpg-agent.env file in to the environment

;; SSH_AUTH_SOCK and SSH_AGENT_PID are updated for gpg-agent.
;; This is extra useful if you use gpg-agent with --enable-ssh-support
;; Do not use if gpg-agent is not acting as ssh-agent. It will break
;; OS X-native SSH_AUTH_SOCK."
;;   (interactive)
;;   (let ((home (getenv "HOME"))
;;         (old-buffer (current-buffer)))
;;     (with-temp-buffer
;;       (insert-file-contents (concat home "/.gpg-agent-info"))
;;       (goto-char (point-min))
;;       (setq case-replace nil)
;;       (replace-regexp "\\(.*\\)=\\(.*\\)" "(setenv \"\\1\" \"\\2\")")
;;       (eval-buffer)))
;;   (getenv "GPG_AGENT_INFO"))
;;
;; Incompatible with current OS X-naitive SSH_AUTH_SOCK
;; ;; Retrieve and set GPG_AGENT_INFO
;; (my-set-gpg-agent-info)
;; ;; Repeat when idle for 60 sec
;; (run-with-idle-timer 60 t 'my-set-gpg-agent-info)



;;;
;;; prodigy.el
;; https://github.com/rejeep/prodigy.el
;; Handling Email with Emacs
;; https://martinralbrecht.wordpress.com/2016/05/30/handling-email-with-emacs/
(use-package prodigy
  :if (and
       (executable-find "~/node_modules/imapnotify/bin/imapnotify")
       (executable-find "google-ime-skk"))
  :commands (prodigy
             prodigy-start-service-by-name)
  ;; :hook ((after-init . (lambda ()
  ;;                        (mapc #'prodigy-start-service-by-name
  ;;                              ;; Start these services
  ;;                              '(
  ;;                                "imapnotify-gmail"
  ;;                                "imapnotify-harvard"
  ;;                                "imapnotify-icloud"
  ;;                                "google-ime-skk")))))
  :config
  ;; Define helper functions.
  (defun prodigy-start-service-by-name (name)
    "Start a prodigy service by its name"
    ;; Check for non-nil
    (when name
      (prodigy-start-service
          (prodigy-find-service name))))
  ;;
  (defun prodigy-restart-service-by-name (name)
    "restart a prodigy service by its name"
    ;; Check for non-nil
    (when name
      (prodigy-restart-service
          (prodigy-find-service name))))
  ;;
  (defun names-of-failed-prodigy-services ()
    "Return the names of failed prodigy services"
    (thread-last
        prodigy-services
      (-filter (lambda (service) (eq (plist-get service :status) 'failed)))
      (-map (lambda (service) (plist-get service :name)))))
  ;;
  (defun restart-failed-prodigy-services ()
    "Restart failed prodigy services"
    (mapc #'prodigy-restart-service-by-name
          (names-of-failed-prodigy-services)))
  ;;
  ;; Periodically restart failed processes.
  ;; http://stackoverflow.com/questions/3841459/how-to-periodically-run-a-task-within-emacs
  (run-with-timer (* 15 60) (* 15 60) 'restart-failed-prodigy-services)
  ;;
  ;; Tags
  ;; Define a new tag with ARGS.
  (prodigy-define-tag
    :name 'email
    :ready-message "Checking Email using IMAP IDLE. Ctrl-C to shutdown.")
  (prodigy-define-tag
    :name 'ime
    :ready-message "Google IME")
  ;; Service
  ;; Define a new service with ARGS.
  (prodigy-define-service
    :name "imapnotify-gmail"
    :command "~/node_modules/imapnotify/bin/imapnotify"
    :args (list "-c" (expand-file-name ".imapnotify_gmail.js" (getenv "HOME")))
    :tags '(email)
    :kill-signal 'sigkill)
  (prodigy-define-service
    :name "imapnotify-harvard"
    :command "~/node_modules/imapnotify/bin/imapnotify"
    :args (list "-c" (expand-file-name ".imapnotify_harvard.js" (getenv "HOME")))
    :tags '(email)
    :kill-signal 'sigkill)
  (prodigy-define-service
    :name "imapnotify-icloud"
    :command "~/node_modules/imapnotify/bin/imapnotify"
    :args (list "-c" (expand-file-name ".imapnotify_icloud.js" (getenv "HOME")))
    :tags '(email)
    :kill-signal 'sigkill)
  ;;
  (prodigy-define-service
    :name "google-ime-skk"
    :command "google-ime-skk"
    :tags '(ime)
    :kill-signal 'sigkill))


;;;
;;; SLURM-RELATED
;; Not available on MELPA.
;; https://github.com/ffevotte/slurm.el
;;;  slurm-script-mode.el for scripting
;; https://github.com/ffevotte/slurm.el#slurm-script-mode
(use-package slurm-script-mode
  :commands (slurm-script-mode))
;;
;;;  slurm-mode.el for interaction
;; https://github.com/ffevotte/slurm.el#slurm-mode
(use-package slurm-mode
  ;; https://github.com/jwiegley/use-package/issues/500
  :load-path "~/Documents/programming/emacs-lisp-repos/slurm.el/"
  :commands (slurm)
  :config
  ;; If non-nil, the jobs list is filtered by user at start.
  (setq slurm-filter-user-at-start t)
  )


;;;
;;; emamux.el
;; https://github.com/syohex/emacs-emamux
(use-package emamux
  :commands (emamux:send-command)
  :config
  )
