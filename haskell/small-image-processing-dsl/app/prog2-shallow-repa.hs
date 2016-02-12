
module Main where

import ShallowRepa
import IO

main = do
    img <- readImgAsRepaArray "../../images/train.png"
    newImg <- run ((blurX . blurX) img)
    return () -- TODO time newImg to normal form.
