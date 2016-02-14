
module Main where

import ShallowRepa
import IO
import Text.Printf

main = do
    img <- readImgAsRepaArray "../../images/maisie.png"
    m <- read <$> getLine
    newImg <- printTimeIO $ run ((darkenBy m . brightenBy m) img)
    writeRepaImg "../../images/prog3-out-repa.png" newImg
