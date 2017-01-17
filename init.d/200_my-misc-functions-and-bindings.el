;;; My miscellaneous functions -*- lexical-binding: t; -*-

;;;
;;; Take current line to top
(defun my-recenter-top ()
  "Recenter to the top"
  (interactive)
  (recenter "Top"))
(global-set-key (kbd "C-S-l") 'my-recenter-top)


;;;
;;; my-insert-date
;; http://ergoemacs.org/emacs/elisp_datetime.html
(defun my-insert-date (u-arg)
  "Insert current date yyyy-mm-dd.

The format is yyyymmdd if a universal argument is given."
  (interactive "P")
  (when (region-active-p)
    (delete-region (region-beginning) (region-end)))
  (insert (if u-arg
              (format-time-string "%Y%m%d")
            (format-time-string "%Y-%m-%d"))))
(global-set-key (kbd "C-c d") 'my-insert-date)


;;;
;;; replace (kbd "C-c r")
(global-set-key (kbd "C-c r") 'replace-string)
(global-set-key (kbd "s-r") 'replace-string)


;;;
;;; Surround region
;; http://www.emacswiki.org/emacs/SurroundRegion
(defun surround (begin end open close)
  "Put OPEN at START and CLOSE at END of the region.
If you omit CLOSE, it will reuse OPEN."
  (interactive  "r\nsStart: \nsEnd: ")
  (when (string= close "")
    (setq close open))
  (save-excursion
    (goto-char end)
    (insert close)
    (goto-char begin)
    (insert open)))


;;;
;;; flush-empty-lines
(defun flush-empty-lines (start end)
  "Flush empty lines in the selected region."
  (interactive "r")
  ;; Do not do anything if no selection is present.
  (if (and transient-mark-mode mark-active)
      (flush-lines "^ *$" start end)))
;; key
(global-set-key (kbd "s-f") 'flush-empty-lines)

;;;
;;; just-one-space
(global-set-key (kbd "s-o") 'just-one-space)

;;;
;;; revert-buffer
(global-set-key (kbd "s-v") 'revert-buffer)



;;; Suppress messages
;; http://qiita.com/itiut@github/items/d917eafd6ab255629346
;; http://emacs.stackexchange.com/questions/14706/suppress-message-in-minibuffer-when-a-buffer-is-saved
(defmacro with-suppressed-message (&rest body)
  "Suppress new messages temporarily in the echo area and the `*Messages*' buffer while BODY is evaluated."
  (declare (indent 0))
  (let ((message-log-max nil))
    `(with-temp-message (or (current-message) "") ,@body)))
