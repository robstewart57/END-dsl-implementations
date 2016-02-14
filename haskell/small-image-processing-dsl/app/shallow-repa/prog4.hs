
module Main where

import ShallowRepa
import IO
import Text.Printf

main = do
    img <- readImgAsRepaArray "../../images/maisie.png"
    m <- read <$> getLine
    n <- read <$> getLine
    (diff,newImg) <- time $ run ((darkenBy n . brightenBy m) img)
    printf "%0.3f\n" (diff :: Double)
    writeRepaImg "../../images/prog4-out-repa.png" newImg
