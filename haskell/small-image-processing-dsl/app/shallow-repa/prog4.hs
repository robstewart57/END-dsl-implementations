
module Main where

import ShallowRepa
import IO
import Text.Printf

main = do
    img <- readImgAsRepaArray "../../images/maisie.png"
    m <- read <$> getLine
    n <- read <$> getLine
    newImg <- printTimeIO $ run ((darkenBy n . brightenBy m) img)
    writeRepaImg "../../images/prog4-out-repa.png" newImg
