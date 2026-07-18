;;; Create a canvas from a vector, and refresh it from Lisp -*- lexical-binding: t -*-

(defvar test-canvas1)
(defvar test-canvas2)

(setq test-canvas1 `(image :type canvas
                           :id test-canvas1
                           :data-width 200
                           :data-height 100
                           :rotation 90
                           :data ,(make-vector (* 200 100) #xFFFF0000)))

(setq test-canvas2 `(image :type canvas
                           :id test-canvas2
                           :data-width 200
                           :data-height 100
                           :scale 3.5
                           :data ,(make-vector (* 200 100) #xFF0000FF)))

(insert (propertize "#" 'display test-canvas1))
(insert (propertize "#" 'display test-canvas2))

(run-at-time 1.0 nil (lambda ()
                       (dotimes (i 100)
                         (aset (plist-get (cdr test-canvas1) :data) (+ i (* 200 i)) #xFFFFFFFF)
                         (aset (plist-get (cdr test-canvas2) :data) (+ i (* 200 i)) #xFFFFFFFF)
                         (canvas-refresh test-canvas1 t)
                         (canvas-refresh test-canvas2 t)
                         (redisplay))))
