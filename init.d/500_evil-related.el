;;; EVIL AND VIM-LIKE CONFIGURATIONS

;;;
;;; evil.el
;; http://www.emacswiki.org/emacs/Evil
;; Change toggle key from C-z to s-e to avoid helm.el conflict
(setq evil-toggle-key "s-e")
;; Activate
(require 'evil)
;; (evil-mode 1)
;; 
;;; Making the most of RET and SPC
;; Keep RET and SPC bindings.
;; http://www.emacswiki.org/emacs/Evil
(defun my-move-key (keymap-from keymap-to key)
  "Moves key binding from one keymap to another, deleting from the old location. "
  (define-key keymap-to key (lookup-key keymap-from key))
  (define-key keymap-from key nil))
(my-move-key evil-motion-state-map evil-normal-state-map (kbd "RET"))
(my-move-key evil-motion-state-map evil-normal-state-map " ")
;;
;;; Further config
;; http://qureana.hatenadiary.com/entry/2013/06/15/204147
;; http://d.hatena.ne.jp/tarao/20130303/evil_intro
;; Make insert state completely emacs
(setcdr evil-insert-state-map nil)

;;;
;;; evil-surround.el
;; https://github.com/timcharper/evil-surround
(require 'evil-surround)
(global-evil-surround-mode 1)