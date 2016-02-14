
module Main where

import ShallowRepa
import IO
import Text.Printf

main = do
    img <- readImgAsRepaArray "../../images/maisie.png"
    (diff,newImg) <- time $ run ((blurX . blurX) img)
    printf "%0.3f\n" (diff :: Double)
    writeRepaImg "../../images/prog2-out-repa.png" newImg
