;;; eval-in-repl configuration

;; Uncomment to use the local dev repo
(add-to-list 'load-path "~/Documents/programming/emacs-lisp-repos/eval-in-repl")

;; require the main file containing common functions
(require 'eval-in-repl)

;; ielm for emacs lisp
(require 'eval-in-repl-ielm)
;; For .el files
(define-key emacs-lisp-mode-map (kbd "<C-return>") 'eir-eval-in-ielm)
;; For *scratch*
(define-key lisp-interaction-mode-map (kbd "<C-return>") 'eir-eval-in-ielm)
;; For M-x info
(define-key Info-mode-map (kbd "<C-return>") 'eir-eval-in-ielm)

;; cider for Clojure
;; (require 'cider) ; if not done elsewhere
(require 'eval-in-repl-cider)
(define-key clojure-mode-map (kbd "<C-return>") 'eir-eval-in-cider)

;; SLIME support (for common lisp)
;; (require 'slime) ; if not done elsewhere
(require 'eval-in-repl-slime)
(add-hook 'lisp-mode-hook
		  '(lambda ()
		     (local-set-key (kbd "<C-return>") 'eir-eval-in-slime)))

;; geiser support (for Racket and Guile Scheme)
;; When using this, turn off racket-mode and scheme supports
;; (require 'geiser) ; if not done elsewhere
(require 'eval-in-repl-geiser)
(add-hook 'geiser-mode-hook
		  '(lambda ()
		     (local-set-key (kbd "<C-return>") 'eir-eval-in-geiser)))

;; racket-mode support (for Racket)
;; (require 'racket-mode) ; if not done elsewhere
;; (require 'eval-in-repl-racket)
;; (define-key racket-mode-map (kbd "<C-return>") 'eir-eval-in-racket)

;; scheme support
;; (require 'scheme) ; if not done elsewhere
;; (require 'cmuscheme) ; if not done elsewhere
;; (require 'eval-in-repl-scheme)
;; (add-hook 'scheme-mode-hook
;; 	  '(lambda ()
;; 	     (local-set-key (kbd "<C-return>") 'eir-eval-in-scheme)))

;; python support 
;; (require 'python) ; if not done elsewhere
(require 'eval-in-repl-python)
(define-key python-mode-map (kbd "<C-return>") 'eir-eval-in-python)

;; shell
;; (require 'essh) ; if not done elsewhere
(require 'eval-in-repl-shell)
(add-hook 'sh-mode-hook
          '(lambda()
	     (local-set-key (kbd "C-<return>") 'eir-eval-in-shell)))
