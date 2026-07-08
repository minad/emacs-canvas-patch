;;; canvas-demo.el -*- lexical-binding: t -*-
;;; Run with emacs -Q -l canvas-demo.el

(shell-command (format "gcc -O2 -I%ssrc canvas-demo.c -o /tmp/canvas-demo.so -fPIC -shared && echo Compiled sucessfully" source-directory))
(module-load "/tmp/canvas-demo.so")
(declare-function canvas-demo-render "ext:canvas-demo.c")

(switch-to-buffer (get-buffer-create "*canvas-demo*"))

(defvar canvas-demo-canvas1)
(defvar canvas-demo-canvas2)
(defvar canvas-demo-frame)
(defvar canvas-demo-time)
(defvar canvas-demo-mode-line)

(setq canvas-demo-canvas1 '(image :type canvas
                                  :data-width 400
                                  :data-height 300
                                  :margin (20 . 20)
                                  :scale 2
                                  :canvas-id 1)
      canvas-demo-canvas2 '(image :type canvas
                                  :data-width 400
                                  :data-height 300
                                  :margin (20 . 20)
                                  :scale 2
                                  :canvas-id 2)
      canvas-demo-frame 0
      canvas-demo-time (float-time)
      canvas-demo-mode-line nil)

(setq-local cursor-type nil
            mode-line-process '((canvas-demo-mode-line canvas-demo-mode-line))
            mode-line-position nil
            mode-line-modified nil
            mode-line-mule-info nil
            mode-line-remote nil)

(insert (propertize "#" 'display canvas-demo-canvas1))
(insert (propertize "#" 'display canvas-demo-canvas2))

(run-with-timer
 nil (/ 1 100.0)
 (lambda ()
   (canvas-demo-render canvas-demo-canvas1 canvas-demo-canvas2)
   (canvas-refresh canvas-demo-canvas1)
   (canvas-refresh canvas-demo-canvas2)
   (let* ((time (float-time))
          (delta (- time canvas-demo-time)))
     (incf canvas-demo-frame)
     (when (> delta 2)
       (setq canvas-demo-mode-line (format " FPS: %.1f" (/ canvas-demo-frame delta))
             canvas-demo-time time
             canvas-demo-frame 0)
       (force-mode-line-update t)))))
