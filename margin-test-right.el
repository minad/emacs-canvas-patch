;;; Right Margins

(defun make-rect (width height pixel)
  (make-vector (* width height) pixel))
(setq rect-canvas-vec (make-rect 250 250 #xFFFF0000))
(setq rect-canvas `(image :type canvas
                          :id test-canvas
                          :data-width 250
                          :data-height 250
                          :data ,rect-canvas-vec))
(setq right-margin-width (ceiling (/ 250 (float (frame-char-width)))))
(set-window-margins (selected-window) nil right-margin-width)
(insert (propertize "#" 'display `((margin right-margin) ,rect-canvas)))

(defvar rect-canvas-timer nil)
(let ((i 0))
  (setq rect-canvas-timer
    (run-with-timer
     0 0.016
     (lambda ()
       (if (< i (* 20 250))
           (progn
             (aset rect-canvas-vec (+ (* 115 250) i) #xFF0000FF)
             (canvas-refresh rect-canvas t)
             (setq i (1+ i)))
         (cancel-timer rect-canvas-timer))))))
