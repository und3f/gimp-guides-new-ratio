; -*-scheme-*-

; advanced-guides.scm -- create advanced ratio guides
; Copyright (C) 2017 Sergey Zasenko

; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
; 
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
; 
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(define (golden-ratio-split value)
    (- 
    value
    (* value (/ (- (sqrt 5) 1) 2))
    )
)

(define (twos-split value)
  (/ value 2)
)

(define (thirds-split value)
  (/ value 3)
)

(define (fifths-split value)
  (/ value 5)
)

(define (silver-ration-split value)
  (* value (- (sqrt 2) 1))
)

(define (calc-using-direction full-length local-length calc-direction)
    (if (= calc-direction FALSE)
        (- full-length local-length)
        (+ local-length)
    )
)

(define (advanced-guides image drawable depth indirection ratio)
  (gimp-undo-push-group-start image)
  (let* (
         (total-value
           (case indirection
             ((0 2) (car (gimp-image-width image)))
             (else (car (gimp-image-height image)))
           )
         )
         (guide
           (case indirection
             ((0 2) gimp-image-add-vguide)
             (else gimp-image-add-hguide)
           )
         )
         (direction
           (case indirection
             ((0 1) 0)
             (else 1)
           )
         )
         (ratio-algo (nth ratio 
                          (list
                            golden-ratio-split
                            twos-split
                            thirds-split
                            fifths-split
                            silver-ration-split
                          )
                     )
         )
    )

    (define (draw-guide guide total-value value direction depth)
        (if (> depth 0)
        (let* (
            (local-value (ratio-algo value))
            )

            (guide image (calc-using-direction total-value local-value direction))
            (draw-guide guide total-value local-value direction (- depth 1))
        )
        )
    )

    (draw-guide guide total-value total-value direction depth)
  )
  (gimp-undo-push-group-end image)
  (gimp-displays-flush)
)

(script-fu-register "advanced-guides"
  _"New guides (by _Ratio)..."
  _"Add series of guides at the position specified as a ratio"
  "Sergey Zasenko (sergii@zasenko.name)"
  "Sergey Zasenko"
  "2017-07-25"
  "*"
  SF-IMAGE      "The Image"     0
  SF-DRAWABLE   "The Layer"     0
  SF-ADJUSTMENT "Rules depth"   '(3 1 10 1 2 0 1)
  SF-OPTION     "Direction"     '(_"Right" _"Down" _"Left" _"Up")
  SF-OPTION     "Ratio"     '(_"Golden sections" _"Rule of twos" _"Rule of thirds" _"Rule of fifths" _"Silver sections")
)

(script-fu-menu-register "advanced-guides"
                         "<Image>/Image/Guides")
