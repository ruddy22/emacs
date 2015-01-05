;;; package.el and repositories
;; THIS HAS TO COME BOFORE init-loader.el (installed via package.el)
;; http://www.emacswiki.org/emacs/ELPA
(require 'package)
;;
;; Load Emacs Lisp packages, and activate them.
;; (package-initialize)
;;
;; MELPA repository
;; http://melpa.milkbox.net/#installing
;; http://melpa.milkbox.net/#/getting-started
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
;;
;; MELPA Stable
;; http://stable.melpa.org/#/getting-started
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
;;
;; Marmalade repository (not active)
;; http://www.emacswiki.org/emacs/Marmalade
;; http://qiita.com/items/e81fca7a9797fe203e9f
;; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
;;
;; org mode repository
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
;;
;; Refresh contents  if no package-archive-contents available
;; http://stackoverflow.com/questions/14836958/updating-packages-in-emacs
(when (not package-archive-contents)
  (package-refresh-contents))
;;
;; Need to be initialized.
(package-initialize)


;;; el-get.el package system 2013-02-26
;; https://github.com/dimitri/el-get
;; The load-path is configured at the top of init.el.
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))
(el-get 'sync)