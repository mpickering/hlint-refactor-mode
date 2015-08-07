(defun refact-gen (opts)
    (shell-command-on-region-with-output-to-end-of-buffer (point-min) (point-max) (concat "hlint --refactor - " opts))
      )

(defun shell-command-on-region-to-string (start end command)
  (with-output-to-string
    (shell-command-on-region start end command standard-output)))

  
(defun call-process-region-checked (start end program)
  (let ((exit (call-process-region
	      start end
	      shell-file-name      ; name of program
	      1            ; delete region
	      t            ; send output to buffer
	      nil          ; no redisplay during output
	      "-c" program
	      )))
    (unless (eq exit 0) (primitive-undo 1 buffer-undo-list))))


(defun shell-command-on-region-with-output-to-end-of-buffer (start end command)
  (interactive)
    (setq pos (point))
    (call-process-region-checked start end command)
    (goto-char pos)
    )

(defun refactor-at-pos () 
  (setq col (number-to-string (current-column)))
  (setq line (number-to-string (line-number-at-pos)))
  (refact-gen
   (concat "--refactor-options=--pos\\ " line "," col)))

(define-minor-mode hlint-refactor-mode
  "Automatically apply hlint suggestions"
  :lighter " hlint-refactor"
  :keymap (let ((map (make-sparse-keymap)))
	    (define-key map (kbd "C-c a") (lambda () (interactive) (refact-gen "")))
	    (define-key map (kbd "C-c o") (lambda ()
					    (interactive)
					    (refactor-at-pos)))
	    map))
