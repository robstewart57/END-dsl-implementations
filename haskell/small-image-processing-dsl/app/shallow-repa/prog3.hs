
module Main where

import ShallowRepa
import IO
import Text.Printf

main = do
    img <- readImgAsRepaArray "../../images/maisie.png"
    m <- read <$> getLine
    (diff,newImg) <- time $ run ((darkenBy m . brightenBy m) img)
    printf "%0.3f\n" (diff :: Double)
    writeRepaImg "../../images/prog3-out-repa.png" newImg
