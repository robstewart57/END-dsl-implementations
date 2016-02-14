
module Main where

import ShallowRepa
import IO
import Text.Printf

main = do
    img <- readImgAsRepaArray "../../images/maisie.png"
    newImg <- printTimeIO $ run (blurX img)
    writeRepaImg "../../images/prog1-out-repa.png" newImg
