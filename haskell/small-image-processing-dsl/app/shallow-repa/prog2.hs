
module Main where

import ShallowRepa
import IO
import Text.Printf

main = do
    img <- readImgAsRepaArray "../../images/maisie.png"
    newImg <- printTimeIO $ run ((blurX . blurX) img)
    writeRepaImg "../../images/prog2-out-repa.png" newImg
