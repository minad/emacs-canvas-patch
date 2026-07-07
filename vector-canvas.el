;;; Create a canvas from a vector, and refresh it from Lisp -*- lexical-binding: t -*-

(setq test-canvas `(image :type canvas
                          :data-width 200
                          :data-height 100
                          :data ,(make-vector (* 200 100) #xFFFF0000)))
(insert (propertize "#" 'display test-canvas))

(run-at-time 1.0 nil (lambda ()
                       (dotimes (i 100)
                         (aset (plist-get (cdr test-canvas) :data) (+ i (* 200 i)) #xFFFFFFFF)
                         (canvas-refresh test-canvas t)
                         (redisplay))))
