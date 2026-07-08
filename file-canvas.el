;;; Read a file containing ARGB32 binary pixel data and create a canvas from it -*- lexical-binding: t -*-

(defvar test-canvas)
(setq test-canvas (create-image (expand-file-name "file-canvas.data")
                                'canvas nil
                                :data-width 200
                                :data-height 50))
(insert (propertize "#" 'display test-canvas))
