;;; LaTeX environments
;;
;;;
;;; AUCtex
;; http://www.gnu.org/software/auctex/index.html
;; http://www.gnu.org/software/auctex/manual/auctex.html
;; Bare minimum
;; http://www.gnu.org/software/auctex/manual/auctex.html#Quick-Start
;; jwiegley's config
;; https://github.com/jwiegley/use-package/issues/379
(use-package tex
  :defines (latex-help-cmd-alist latex-help-file)
  :mode ("\\.tex\\'" . TeX-latex-mode)
  :config
  ;; Automatically save style information when saving the buffer.
  (setq TeX-auto-save t)
  ;; Parse file after loading it if no style hook is found for it.
  (setq TeX-parse-self t)
  ;; If non-nil, show output of TeX compilation in other window.
  (setq TeX-show-compilation nil)
  ;; The master file associated with the current buffer.
  ;; If the file being edited is actually included from another file, you
  ;; can tell AUCTeX the name of the master file by setting this variable.
  ;; If there are multiple levels of nesting, specify the top level file.
  (setq TeX-master nil)
  ;;
  ;; autosave before compiling
  ;; http://emacsworld.blogspot.com/2011/05/auctex-tip-automatically-save-file.html
  (setq TeX-save-query nil)
  ;;
  ;; Interactive mode for errors
  (add-hook 'LaTeX-mode-hook 'TeX-interactive-mode)
  ;;
  ;; TeX-PDF mode (no DVI intermediate file in pdfTeX, LuaTex, XeTeX)
  (add-hook 'LaTeX-mode-hook 'TeX-PDF-mode)
  ;;
  ;; Avoid font size changes
  ;; http://stackoverflow.com/questions/9534239/emacs-auctex-latex-syntax-prevents-monospaced-font
  ;; Only change sectioning colour
  (setq font-latex-fontify-sectioning 'color)
  ;; (setq font-latex-fontify-sectioning (quote nil))
  ;; super-/sub-script on baseline
  (setq font-latex-script-display (quote (nil)))
  ;; Do not change super-/sub-script font
  ;;
  ;; Exclude bold/italic from keywords
  (setq font-latex-deactivated-keyword-classes
        '("italic-command" "bold-command" "italic-declaration" "bold-declaration"))
  ;;
  ;; Insert {} after ^ or _
  (setq TeX-electric-sub-and-superscript t)
  ;;
;;;  Custom key bindings
  ;;
  ;; TeX-insert-backslash
  (defun my-tex-insert-backslash ()
    (interactive)
    (insert "\\"))
  (defun my-tex-insert-forwardslash ()
    (interactive)
    (insert "/"))
  (defun my-tex-insert-semicolon ()
    (interactive)
    (insert ";"))
  (add-hook 'LaTeX-mode-hook
            '(lambda ()
               (local-set-key (kbd   ";") 'my-tex-insert-backslash)
               (local-set-key (kbd "A-;") 'my-tex-insert-semicolon)))
  ;;
  ;;
;;;  Add commands
  ;; 4.1.2 Selecting and Executing a Command
  ;; https://www.gnu.org/software/auctex/manual/auctex/Selecting-a-Command.html
  ;; %s becomes the file name without .tex, but .Rnw is not removed correctly.
  ;;
  ;; TeX-command-list is a variable defined in `tex.el'.
  ;; list elements:
  ;; 1. name of the command
  ;; 2. string handed to the shell after being expanded (follows TeX-expand-list)
  ;; 3. function which actually start the process (various options)
  ;; 4. if nil directly executed
  ;; 5. if t, appears in all modes
  (add-hook 'LaTeX-mode-hook
            (function (lambda ()
                        (add-to-list 'TeX-command-list
                                     '("Preview" "/usr/bin/open -a Preview.app %s.pdf"
                                       TeX-run-discard-or-function nil t :help "Run Preview"))
                        (add-to-list 'TeX-command-list
                                     '("Skim" "/usr/bin/open -a Skim.app %s.pdf"
                                       TeX-run-discard-or-function nil t :help "Run Skim"))
                        ;; Replace original View
                        (add-to-list 'TeX-command-list
                                     '("View" "/usr/bin/open -a Skim.app %s.pdf"
                                       TeX-run-discard-or-function nil t :help "Run Skim"))
                        ;; Original BibTeX
                        (add-to-list 'TeX-command-list
                                     '("BibTeX" "bibtex %s"
                                       TeX-run-BibTeX nil t :help "Run BibTeX"))
                        ;; BibTeX alternative
                        (add-to-list 'TeX-command-list
                                     '("alt-BibTeX" "/Library/TeX/texbin/bibtex %s"
                                       TeX-run-discard-or-function nil t :help "Run BibTeX (alternative)"))
                        ;;
                        (add-to-list 'TeX-command-list
                                     '("displayline" "/Applications/Skim.app/Contents/SharedSupport/displayline %n %s.pdf \"%b\""
                                       TeX-run-discard-or-function t t :help "Forward search with Skim"))
                        ;; TeXShop for PDF
                        ;; Source - Configure for External Editor
                        ;; Preview - Automatic Preview Update
                        (add-to-list 'TeX-command-list
                                     '("TeXShop" "/usr/bin/open -a TeXShop.app %s.pdf"
                                       TeX-run-discard-or-function t t :help "Run TeXShop"))
                        (add-to-list 'TeX-command-list
                                     '("TeXworks" "/usr/bin/open -a TeXworks.app %s.pdf"
                                       TeX-run-discard-or-function t t :help "Run TeXworks"))
                        (add-to-list 'TeX-command-list
                                     '("Firefox" "/usr/bin/open -a Firefox.app %s.pdf"
                                       TeX-run-discard-or-function t t :help "Run Mozilla Firefox"))
                        (add-to-list 'TeX-command-list
                                     '("AdobeReader" "/usr/bin/open -a \"Adobe Reader.app\" %s.pdf"
                                       TeX-run-discard-or-function t t :help "Run Adobe Reader")))))
  ;;
  ;;
;;;  Japanese setting
  ;; http://oku.edu.mie-u.ac.jp/~okumura/texwiki/?AUCTeX
  ;; Hiragino font settings. Done in shell
  ;; http://oku.edu.mie-u.ac.jp/~okumura/texwiki/?Mac#i9febc9b
  ;;
  ;; (setq TeX-default-mode 'japanese-latex-mode)
  ;; jsarticle as the default style
  (setq japanese-LaTeX-default-style "jsarticle")
  ;; For Japanese document
  (setq kinsoku-limit 10)
  )



;;;
;;; auctex-latexmk.el
;; for Japanese tex to PDF direct conversion
;; http://qiita.com/tm_tn/items/cbc813028d7f5951b165
;; https://github.com/tom-tan/auctex-latexmk/
;; ln -sf ~/Documents/.latexmkrc ~/.latexmkrc
;; C-c C-c LatexMk to use
(use-package auctex-latexmk
  :commands (auctex-latexmk-setup)
  :init
  (add-hook 'LaTeX-mode-hook 'auctex-latexmk-setup))


;;;
;;; Auto-completion for LaTeX

;;; company-auctex.el
;; https://github.com/alexeyr/company-auctex
(use-package company-auctex
  :commands (company-auctex-init)
  :init
  (add-hook 'LaTeX-mode-hook 'company-auctex-init))



;;;
;;; latex-math-preview.el
;; http://www.emacswiki.org/emacs/LaTeXMathPreview
(use-package latex-math-preview
  :commands (my-latex-math-preview
             my-latex-beamer-preview)
  :config
  ;; Paths to required external software (specific to MacTeX)
  (setq latex-math-preview-command-path-alist
        '((latex    . "/Library/TeX/texbin/latex")
          (dvipng   . "/Library/TeX/texbin/dvipng")
          (dvips    . "/Library/TeX/texbin/dvips")
          ;; for beamer preview
          (pdflatex . "/Library/TeX/texbin/pdflatex")
          ;; for beamer preview
          (gs       . "/Library/TeX/local/bin/gs")))
  ;;
  ;; Colors for dark background 2013-09-28
  (setq latex-math-preview-dvipng-color-option nil)
  (setq latex-math-preview-image-foreground-color "black")
  (setq latex-math-preview-image-background-color "white")
  ;;
  ;; Function to preview math expression and shift focus after preview
  (defun my-latex-math-preview ()
    "Preview a math expression and shift focus after preview"
    (interactive)
    (setq w1 (selected-window))
    (latex-math-preview-expression)
    (select-window w1))
  ;;
  ;; Function to preview Beamer slide and shift focus after preview
  (defun my-latex-beamer-preview ()
    "Preview a Beamer slide and shift focus after preview"
    (interactive)
    (setq w1 (selected-window))
    (latex-math-preview-beamer-frame)
    (select-window w1)))



;;;
;;; Reference management
;; http://en.wikibooks.org/wiki/LaTeX/Bibliography_Management
;; http://www.fan.gr.jp/~ring/doc/bibtex.html
;; http://d.hatena.ne.jp/ckazu/20100107/1262871971
;; http://stackoverflow.com/questions/144639/how-do-i-order-citations-by-appearance-using-bibtex
;;
;;; reftex.el
;; part of emacs
;; http://www.gnu.org/software/emacs/manual/html_mono/reftex.html
(use-package reftex
  :commands (reftex-mode)
  :init
  ;; turn on REFTeX mode by default
  (add-hook 'LaTeX-mode-hook 'reftex-mode)
  :config
  ;; AUCTeX integration
  (setq reftex-plug-into-AUCTeX t)
  ;; Do not prompt for reference vs page
  (setq reftex-ref-macro-prompt nil)
  ;;
  (add-hook 'LaTeX-mode-hook
            '(lambda ()
               (local-set-key (kbd "H-c") 'reftex-citation)
               (local-set-key (kbd "A-C-a") 'reftex-citation))))
;;
;;
;;; bibtex.el
;; http://en.wikibooks.org/wiki/LaTeX/Bibliography_Management#BibTeX
;; Getting current LaTeX document to use your .bib file
;; http://en.wikibooks.org/wiki/LaTeX/Bibliography_Management#Getting_current_LaTeX_document_to_use_your_.bib_file
;; (require 'bibtex)
;;
;;; zotelo (Zotero-Local)
;; https://github.com/vitoshka/zotelo
;; https://forums.zotero.org/discussion/19608/zotero-emacs-integration/
(use-package zotelo
  :commands (zotelo-set-collection
             zotelo-update-database
             zotelo-minor-mode)
  :init
  (add-hook 'TeX-mode-hook 'zotelo-minor-mode)
  ;;
  :config
  (setq zotelo-use-ido nil)
  ;; C-c z c         zotelo-set-collection (also C-c z s)
  ;; C-c z u         zotelo-update-database
  ;; C-c z e         zotelo-export-secondary
  ;; C-c z r         zotelo-reset
  ;; C-c z t         zotelo-set-translator
  )
