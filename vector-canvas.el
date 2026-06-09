;;; This should create a 250x250 RED square in your (canvas supported) Emacs buffer

(defun make-rect (width height pixel)
  (make-vector (* width height) pixel))

(setq rect-canvas-vec (make-rect 250 250 #xFFFF0000))
(setq rect-canvas `(image :type canvas
			  :canvas-id rect
			  :data-width 250
			  :data-height 250
			  :data ,rect-canvas-vec))
(insert (propertize "#" 'display rect-canvas))
(canvas-refresh rect-canvas t)

(defun reload-rect-vec ()
  (dotimes (i 100)
  (aset rect-canvas-vec i #xFFFFFFFF))
  (canvas-refresh rect-canvas t))

(reload-rect-vec)
