;;; This will read a file containing ARGB32 binary pixel data and then create a canvas from it.
;;; At the end you should see a 100x100 RED square.

(setq test-canvas (create-image "file-canvas.data"
                                'canvas nil
                                :data-width 200
                                :data-height 50))
(insert (propertize "#" 'display test-canvas))
