;;; -*- lexical-binding: t; -*-
;;;
;;; EMACS LISP
;;;  elisp programming configurations
;; Non-nil means enter debugger if an error is signaled.
;; (setq debug-on-error t)


;;;  elisp-slime-nav.el
;; SLIME-like navigation for elisp
;; https://github.com/purcell/elisp-slime-nav
;; This package provides Slime's convenient "M-." and "M-," navigation
(use-package elisp-slime-nav
  :diminish elisp-slime-nav-mode
  :commands (turn-on-elisp-slime-nav-mode)
  ;; Hook
  :init
  (dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
    (add-hook hook 'turn-on-elisp-slime-nav-mode)))


;;;  eros.el
;; https://github.com/xiongtx/eros/tree/dd8910279226259e100dab798b073a52f9b4233a
(use-package eros
  :config
  (eros-mode 1))


;;;  lispxmp.el
;; https://www.emacswiki.org/emacs/lispxmp.el
;; M-; M-; to insert ; =>
;; M-; is for paredit-comment-dwim, which is advised by lispxmp.el.
(use-package lispxmp
  :commands (lispxmp))


;;;  macrostep.el
;; https://github.com/joddie/macrostep
(use-package macrostep
  :commands (macrostep-mode
             macrostep-expand))


;;;  nameless.el
;; https://github.com/Malabarba/Nameless
;; http://endlessparentheses.com/nameless-less-is-more.html
(use-package nameless
  :commands (nameless-mode))


;;;
;;; SLIME for non-elisp lisps

;;;  slime-company.el
;; https://github.com/anwyn/slime-company
(use-package slime-company
  :commands (slime-company))

;;;  slime.el
;;
;; http://www.common-lisp.net/project/slime/
;; http://dev.ariel-networks.com/wp/archives/462
(use-package slime
  :commands (slime)
  ;;
  :config
  ;; Setup Emacs so that lisp-mode buffers always use SLIME.
  (slime-setup '(slime-repl slime-fancy slime-banner slime-company))
  ;;
  ;; Common Lisp hyperspec via homebrew
  ;; http://www.lispworks.com/documentation/common-lisp.html
  (setq common-lisp-hyperspec-root
        "/usr/local/share/doc/hyperspec/HyperSpec/")
  (setq common-lisp-hyperspec-symbol-table
        (concat common-lisp-hyperspec-root "Data/Map_Sym.txt"))
  (setq common-lisp-hyperspec-issuex-table
        (concat common-lisp-hyperspec-root "Data/Map_IssX.txt"))
  ;;
  ;; 2.5.2 Multiple Lisps (The first one serves as the default.)
  ;; http://common-lisp.net/project/slime/doc/html/Multiple-Lisps.html
  ;; (NAME (PROGRAM PROGRAM-ARGS...) &key CODING-SYSTEM INIT INIT-FUNCTION ENV)
  ;; NAME is a symbol and is used to identify the program.
  ;; PROGRAM is the filename of the program. Note that the filename can contain spaces.
  ;; PROGRAM-ARGS is a list of command line arguments.
  ;; CODING-SYSTEM the coding system for the connection. (see slime-net-coding-system)
  (setq slime-lisp-implementations
        '((clisp  ("/usr/local/bin/clisp"))
          (sbcl   ("/usr/local/bin/sbcl")))))


;;;
;;; RACKET RELATED
;; Racket documentation for emacs
;; http://docs.racket-lang.org/guide/Emacs.html
;;
;; Package Management in Racket
;; http://docs.racket-lang.org/pkg/
;;
;; Install these to make racket-mode work
;; $ raco pkg install rackunit

;;;  racket-mode.el
;; https://github.com/greghendershott/racket-mode
;; major mode for Racket. incompatible with geiser minor mode.
;;
;; (require 'racket-mode)

;;;  geiser.el
;; Geiser for Racket and Guile Scheme
;; Works as an add-on to the built-in scheme mode
;; http://www.nongnu.org/geiser/
;;
;; Do $ raco pkg install compatibility-lib if installing plt-racket via Homebrew
;; https://github.com/jaor/geiser/issues/39
(use-package geiser
  :commands (geiser-mode switch-to-geiser)
  :config
;;;  ac-geiser.el
  (when (require 'ac-geiser nil 'noerror)
    (eval-after-load "auto-complete"
      '(add-to-list 'ac-modes 'geiser-repl-mode))
    ;;
    (defun my-ac-geiser-setup ()
      (ac-geiser-setup)
      (company-mode -1)
      (define-key geiser-mode-map (kbd "C-.") 'highlight-symbol-at-point))
    (add-hook 'geiser-mode-hook      'my-ac-geiser-setup)
    (add-hook 'geiser-repl-mode-hook 'my-ac-geiser-setup)))
