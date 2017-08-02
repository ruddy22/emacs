;;; M-x customize seperation
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Saving-Customizations.html
;; The actual file resides here.
(setq custom-file (concat user-emacs-directory
                          "init.d/init-customize.el"))
;; Load the file
(load custom-file)
