;;; 500_opening-special-files-related.el ---         -*- lexical-binding: t; -*-

;;;
;;; vlf: View Large Files
;; https://github.com/m00natic/vlfi
(use-package vlf-setup)


;;;
;;; open-junk-file.el for creation of permanent test files
(use-package open-junk-file
  :bind (("C-x C-z" . open-junk-file))
  :config
  (setq open-junk-file-directory "~/junk/%Y/%m/%d-%H%M%S."))


;;;
;;; pdf-tools.el
;; https://github.com/politza/pdf-tools
;; $ brew install poppler automake
;; Although OS X is not officially supported, it has been reported to have been
;; successfully compiled. You will need to install poppler which you can get with
;; homebrew via $ brew install poppler automake (recipe below takes care of this)
;;
;; http://emacs.stackexchange.com/questions/13314/install-pdf-tools-on-emacs-macosx
;; Install epdfinfo via 'brew install homebrew/emacs/pdf-tools' and then install the
;; pdf-tools elisp via the use-package below. To upgrade the epdfinfo
;; server, just do 'brew upgrade pdf-tools' prior to upgrading to newest
;; pdf-tools package using Emacs package system. If things get messed
;; up, just do 'brew uninstall pdf-tools', wipe out the elpa
;; pdf-tools package and reinstall both as at the start.
;;
;; When dysfunctional, try uninstalling and installing again.
;; $ brew reinstall pdf-tools
;;
;; Homebrew recipe moved to:
;; https://github.com/dunn/homebrew-emacs
;;
;;;  poppler compatibility issue
;; $ brew install pdf-tools
;; Updating Homebrew...
;; ==> Installing pdf-tools from dunn/emacs
;; ==> Downloading https://github.com/politza/pdf-tools/archive/v0.70.tar.gz
;; Already downloaded: /Users/kazuki/Library/Caches/Homebrew/pdf-tools-0.70.tar.gz
;; ==> make server/epdfinfo
;; Last 15 lines from /Users/kazuki/Library/Logs/Homebrew/pdf-tools/01.make:
;; configure.ac:11: installing './compile'
;; configure.ac:6: installing './install-sh'
;; configure.ac:6: installing './missing'
;; Makefile.am: installing './depcomp'
;; cd server && ./configure -q
;; configure: WARNING: Annot.h: present but cannot be compiled
;; configure: WARNING: Annot.h:     check for missing prerequisite headers?
;; configure: WARNING: Annot.h: see the Autoconf documentation
;; configure: WARNING: Annot.h:     section "Present But Cannot Be Compiled"
;; configure: WARNING: Annot.h: proceeding with the compiler's result
;; configure: WARNING:     ## ---------------------------------- ##
;; configure: WARNING:     ## Report this to politza@fh-trier.de ##
;; configure: WARNING:     ## ---------------------------------- ##
;; configure: error: cannot find necessary  poppler-private header (see README.org)
;; make: *** [server/Makefile] Error 1
;; If reporting this issue please do so at (not Homebrew/brew or Homebrew/core):
;; https://github.com/dunn/homebrew-emacs/issues
;;
;; $ brew switch poppler 0.57.0_1 # This fixed the above issue.
;;
;; poppler development information.
;; https://poppler.freedesktop.org
(use-package pdf-tools
  ;; The deferring configuration was take from the following repository.
  ;; https://github.com/kaushalmodi/.emacs.d/blob/master/setup-files/setup-pdf.el
  :mode (("\\.pdf\\'" . pdf-view-mode))
  ;;
  :init
  ;; Add the path to the MELPA version to avoid loading the Homebrew version.
  (add-to-list 'load-path
               ;; We need a wild card as a MELPA package keeps changing the folder name.
               ;; http://emacs.stackexchange.com/questions/9768/elisp-files-in-load-path-are-not-loaded-on-emacs-start
               ;; https://www.gnu.org/software/emacs/manual/html_node/elisp/List-Elements.html
               (car
                (last
                 (file-expand-wildcards
                  (concat user-emacs-directory "elpa/pdf-tools*")))))
  ;;
  :config
  ;; Whether PDF Tools should handle upgrading itself.
  ;; Up grading should be via Homebrew
  (setq pdf-tools-handle-upgrades nil)
  ;;
  ;; Filename of the epdfinfo executable installed via Homebrew
  (setq pdf-info-epdfinfo-program "/usr/local/bin/epdfinfo")
  ;;
  ;; Install PDF-Tools in all current and future PDF buffers.
  ;; https://github.com/politza/pdf-tools/issues/72
  (use-package pdf-occur
    ;; These are required by pdf-tools-install.
    :commands (pdf-occur-global-minor-mode))
  ;;
  (pdf-tools-install)
  ;;
  ;; Auto-revert
  ;; (add-hook 'pdf-view-mode-hook #'turn-on-auto-revert-mode)
  )


;;;
;;; ePUB-related
;;; nov.el
;; https://github.com/wasamasa/nov.el
(use-package nov
  :mode (("\\.epub" . nov-mode)))


;;;
;;; IMAGE-RELATED
;; https://emacs.stackexchange.com/questions/2433/shrink-zoom-scale-images-in-image-mode

;;;  eimp.el
;; https://www.emacswiki.org/emacs/eimp.el
;; Beaware this immediately manipulates the original image if used with auto-save.
(use-package eimp
  :disabled t
  :commands (eimp-mode)
  :init
  (add-hook 'image-mode-hook 'eimp-mode))


;;;  picpocket.el
;; https://github.com/johanclaesson/picpocket
(use-package picpocket
  :commands (picpocket))
