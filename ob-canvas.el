;;; ob-canvas.el --- Org babel test -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require 'ob)

(defvar ob-canvas-count 0)
(defvar ob-canvas-start (float-time))
(defvar ob-canvas-handle '(image :type canvas :canvas-width 300 :canvas-height 300 :canvas-id ob-canvas))
(defvar ob-canvas-timer (run-with-timer
                         nil (/ 1 60.0)
                         (lambda ()
                           (when (fboundp 'ob-canvas-render)
                             (ob-canvas-render ob-canvas-handle (- (float-time) ob-canvas-start))))))

(defun org-babel-execute:canvas (body params)
  (font-lock-add-keywords nil `((": {CANVAS}" 0 '(face nil display ,ob-canvas-handle))) t)
  (let ((file (format "/tmp/ob-canvas%s.so" ob-canvas-count)))
    (shell-command (format "gcc -DEXP=%s -O3 -I%ssrc ob-canvas.c -o %s -fPIC -shared"
                           (shell-quote-argument (string-clean-whitespace body))
                           (shell-quote-argument source-directory)
                           (shell-quote-argument file)))
    (module-load file)
    (delete-file file))
  (incf ob-canvas-count)
  "{CANVAS}")

(provide 'ob-canvas)
;;; ob-canvas.el ends here
