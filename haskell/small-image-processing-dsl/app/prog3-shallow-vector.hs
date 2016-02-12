
module Main where

import Prelude hiding ((+),(-))
import ShallowVector
import IO

main = do
    img <- readImgAsVector "../../images/train.png"
    let newImg = (brightenBy 10 . blurY . blurX) img
    return () -- TODO time newImg to normal form.
