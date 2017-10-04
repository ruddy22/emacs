;;; Buffere-related configurations  -*- lexical-binding: t; -*-


;;;
;;; Unique buffer names
;; http://www.gnu.org/software/emacs/manual/html_node/emacs/Uniquify.html
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-ignore-buffers-re "*[^*]+*")


;;;
;;; autorevert.el
(use-package autorevert
  :commands (auto-revert-mode)
  :bind (:map my-key-map
              ("a" . auto-revert-mode))
  ;;
  :config
  ;; Active in all buffers
  (setq global-auto-revert-mode nil)
  ;; Even in non-file buffers
  (setq global-auto-revert-non-file-buffers t)
  ;; VC status change is also captured
  (setq auto-revert-check-vc-info t)
  ;; No ARev in mode-line
  ;; (setq auto-revert-mode-text "")
  )



;;;
;;; ibuffer.el
;; http://www.emacswiki.org/emacs/IbufferMode
;; http://ergoemacs.org/emacs/emacs_buffer_management.html
(defalias 'list-buffers 'ibuffer)
;;
;;;  Sorting
;; http://mytechrants.wordpress.com/2010/03/25/emacs-tip-of-the-day-start-using-ibuffer-asap/
;; (setq ibuffer-default-sorting-mode 'major-mode)
;; https://github.com/pd/dotfiles/blob/master/emacs.d/pd/core.el
(setq ibuffer-default-sorting-mode 'filename/process)
;; Drop empty groups
(setq ibuffer-show-empty-filter-groups nil)
;;
;;;  Grouping
;; http://www.emacswiki.org/emacs/IbufferMode#toc6
;; An alist of filtering groups to switch between.
;; This variable should look like (("STRING" QUALIFIERS)
;;                                 ("STRING" QUALIFIERS) ...), where
;; QUALIFIERS is a list of the same form as `ibuffer-filtering-qualifiers'.
(setq ibuffer-saved-filter-groups
      '(("default"
         ;; Directories
         ("DIRED" (mode . dired-mode))
         ;; Authoring
         ("ORG" (mode . org-mode))
         ("TeX"    (or
                    (mode . TeX-mode)
                    (mode . LaTeX-mode)))
         ;; Programming languages
         ("ESS"   (or
                   (mode . ess-mode)
                   (mode . inferior-ess-mode)
                   (mode . Rd-mode)))
         ("CLOJURE" (or
                     (mode . clojure-mode)
                     (name . "^\\*cider-")
                     (name . "^\\*nrepl-")))
         ("SLIME" (or
                   (mode . lisp-mode)
                   (name . "^\\*slime")
                   (name . "*inferior-lisp*")))
         ("SCHEME" (or
                    (mode . scheme-mode)
                    (mode . inferior-scheme-mode)
                    (mode . geiser-repl-mode)))
         ("HASKELL" (or
                     (mode . haskell-mode)
                     (mode . inferior-haskell-mode)))
         ("PYTHON" (or
                    (mode . python-mode)
                    (mode . inferior-python-mode)
                    (mode . ein:notebooklist-mode)
                    (mode . ein:notebook-multilang-mode)))
         ("ML" (or
                (mode . sml-mode)
                (mode . inferior-sml-mode)))
         ("RUBY" (or
                  (mode . ruby-mode)
                  (mode . inf-ruby-mode)))
         ("SQL"  (or
                  (mode . sql-mode)
                  (mode . sql-interactive-mode)))
         ;; Email
         ("EMAIL" (or
                   (name . "^\\*mu4e")
                   (mode . mu4e:compose)))
         ;; Shells
         ("SHELL"  (or
                    (mode . sh-mode)
                    (mode . shell-mode)
                    (mode . ssh-mode)
                    (mode . eshell-mode)
                    (mode . term-mode)))
         ;; PDF
         ("PDF" (mode . pdf-view-mode))
         ;; Emacs related
         ("ELISP" (or
                   (mode . emacs-lisp-mode)
                   (mode . list-mode)
                   (mode . inferior-emacs-lisp-mode)))
         ("EMACS" (or
                   (name . "^\\*scratch\\*$")
                   (name . "^\\*Messages\\*$")
                   (name . "^\\*Packages\\*$")))
         ;; Version control
         ("MAGIT"  (or
                    (mode . magit-mode)
                    (name . "^\\*magit")))
         ;; Services
         ("PRODIGY"  (or
                      (mode . prodigy-mode)
                      (name . "^\\*prodigy")))
         ;; All others
         ("OTHERS" (name . ".*")))))
;;
;; Set this buffer’s filter groups to saved version with NAME.
(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-switch-to-saved-filter-groups "default")))


;;;
;;; Kill process buffer without confirmation?
;; https://emacs.stackexchange.com/questions/14509/kill-process-buffer-without-confirmation
(setq kill-buffer-query-functions
      ;; Delete members of LIST which are eq to ELT, and return the result.
      (delq 'process-kill-buffer-query-function
            kill-buffer-query-functions))
