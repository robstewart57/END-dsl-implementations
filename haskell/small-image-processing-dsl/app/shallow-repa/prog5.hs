
module Main where

import ShallowRepa
import IO
import Text.Printf

main = do
    img <- readImgAsRepaArray "../../images/maisie.png"
    newImg <- printTimeIO $ run ((brightenBy 30 . blurY . blurX) img)
    writeRepaImg "../../images/prog5-out-repa.png" newImg
