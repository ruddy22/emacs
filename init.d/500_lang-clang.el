;;; 500_lang-clang.el ---                            -*- lexical-binding: t; -*-

;;;
;;; cc-mode.el
(use-package cc-mode
  :config
  ;; Indentation
  (setq c-basic-offset 4)
  ;;
  ;; Keys
  (define-key c++-mode-map (kbd "A-c") #'save-all-and-compile)
  (define-key c++-mode-map (kbd "A-s") #'save-all-and-compile)
  ;;
  ;; using the current buffer's file name in M-x compile
  ;; http://stackoverflow.com/questions/12756531/using-the-current-buffers-file-name-in-m-x-compile
  (defun c++compile-command-setter ()
    "Set compile-command for C++"
    (unless (or (file-exists-p "makefile")
                (file-exists-p "Makefile"))
      ;; Proceed unless there is a Makefile.
      (set
       ;; (make-local-variable VARIABLE)
       ;; Make VARIABLE have a separate value in the current buffer.
       (make-local-variable 'compile-command)
       ;; This will be the value for c++.
       (concat "g++ -pipe -O2 -std=c++14 "
               buffer-file-name
               " -lm -o "
               (file-name-sans-extension buffer-file-name)))))
  (add-hook 'c++-mode-hook #'c++compile-command-setter))


;;;
;;; company-c-headers.el
;; https://github.com/randomphrase/company-c-headers
(use-package company-c-headers
  :disabled t
  :commands (company-c-headers)
  ;;
  :init
  (eval-after-load 'company
    (add-to-list 'company-backends 'company-c-headers)))


;;;
;;; IRONY-RELATED
;;;  irony-mode.el
;; https://github.com/Sarcasm/irony-mode
;; https://github.com/Sarcasm/irony-mode/wiki/Mac-OS-X-issues-and-workaround
;; https://github.com/Sarcasm/irony-mode/issues/351
;; https://github.com/Golevka/emacs-clang-complete-async/issues/18
;;
;; Install llvm with header files.
;; brew install --with-clang --all-targets --rtti --universal --jit llvm
;;
;; M-x irony-install-server
;; Change the command to the following with additional -DLIBCLANG* options for brew's llvm.
;; cmake -DLIBCLANG_INCLUDE_DIR\=/usr/local/opt/llvm/include/ -DLIBCLANG_LIBRARY\=/usr/local/opt/llvm/lib/libclang.dylib -DCMAKE_INSTALL_PREFIX\=/Users/kazuki/.emacs.d/irony/ /Users/kazuki/.emacs.d/elpa/irony-20170627.1045/server && cmake --build . --use-stderr --config Release --target install
;;
;; ~/.emacs.d/irony/bin/irony-server is installed.
(use-package irony-mode
  :commands (irony-mode)
  ;;
  :init
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'objc-mode-hook 'irony-mode))


;;;  company-irony.el
;; https://github.com/Sarcasm/company-irony/
(use-package company-irony
  :commands (company-irony)
  ;;
  :init
  (eval-after-load 'company
    '(add-to-list 'company-backends 'company-irony)))


;;;  irony-eldoc.el
(use-package irony-eldoc
  :commands (irony-eldoc)
  :init
  (add-hook 'irony-mode-hook #'irony-eldoc))
