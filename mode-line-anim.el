;;; mode-line-anim.el --- Mode Line Animation with Canvas -*- lexical-binding: t -*-

(defvar anim-vec (make-vector (* 16 16) #xFF000000))
(defvar mode-line-anim-canvas
  `(image :type canvas
          :id ml-canvas
          :data-width 16
          :data-height 16
          :data ,anim-vec
          :ascent center))
(defvar mode-line-anim-timer nil)
(defvar mode-line-anim-tt 0.0)

(defun mode-line-anim-start ()
  (interactive)
  (when (timerp mode-line-anim-timer) (cancel-timer mode-line-anim-timer))
  (setq mode-line-anim-timer
        (run-with-timer 0 0.07 #'mode-line-anim-update)))

(defun mode-line-anim-update ()
  (dotimes (y 16)
    (dotimes (x 16)
      (let* ((tt mode-line-anim-tt)
             (v (/ (+ (sin (+ (/ x 2.5) tt))
                      (sin (+ (/ y 2.5) (* tt 1.3)))
                      (sin (/ (+ (sqrt (+ (* x x) (* y y))) (* tt 10)) 2.5)))
                   3.0))
             (h (mod (/ (+ v 1) 2.0) 1.0))
             (i (floor (* h 6))) (f (- (* h 6) i)))
        (aset anim-vec (+ (* y 16) x)
              (pcase i
                (0 (logior #xFF000000 #xFF0000 (ash (round (* f 255)) 8)))
                (1 (logior #xFF000000 (ash (round (* (- 1 f) 255)) 16) #x00FF00))
                (2 (logior #xFF000000 #x00FF00 (round (* f 255))))
                (3 (logior #xFF000000 (ash (round (* (- 1 f) 255)) 8) #x0000FF))
                (4 (logior #xFF000000 (ash (round (* f 255)) 16) #x0000FF))
                (_ (logior #xFF000000 #xFF0000 (round (* (- 1 f) 255)))))))))
  (canvas-refresh mode-line-anim-canvas t)
  (setq mode-line-anim-tt (+ mode-line-anim-tt 0.15)))

(defun mode-line-anim-stop ()
  (interactive)
  (when (timerp mode-line-anim-timer)
    (cancel-timer mode-line-anim-timer)
    (setq mode-line-anim-timer nil)))

(add-to-list 'mode-line-format
             '(:eval (propertize "#" 'display mode-line-anim-canvas)))
(mode-line-anim-start)
