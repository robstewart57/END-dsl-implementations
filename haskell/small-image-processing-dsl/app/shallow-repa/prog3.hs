
module Main where

import ShallowRepa
import IO

main = do
    img <- readImgAsRepaArray "../../images/train.png"
    newImg <- run ((brightenBy 10 . blurY . blurX) img)
    return () -- TODO time newImg to normal form.
