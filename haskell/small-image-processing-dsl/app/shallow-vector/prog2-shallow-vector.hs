
module Main where

import ShallowVector
import IO

main = do
    img <- readImgAsVector "../../images/train.png"
    let newImg = (blurX . blurX) img
    return () -- TODO time newImg to normal form.
