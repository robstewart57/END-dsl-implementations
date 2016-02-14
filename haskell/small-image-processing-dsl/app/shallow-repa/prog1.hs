
module Main where

import ShallowRepa
import IO
import Text.Printf

main = do
    img <- readImgAsRepaArray "../../images/maisie.png"
    (diff,newImg) <- time $ run (blurX img)
    printf "%0.3f\n" (diff :: Double)
    writeRepaImg "../../images/prog1-out-repa.png" newImg
