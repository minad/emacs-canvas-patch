;;; This will read a file containing ARGB32 binary pixel data and then create a canvas from it.
;;; At the end you should see a 100x100 RED square.

(setq test-canvas (create-image "canvas-argb32-data"
				'canvas nil
				:data-width 100
				:data-height 100))
(insert (propertize "#" 'display test-canvas))
(canvas-refresh test-canvas t)
