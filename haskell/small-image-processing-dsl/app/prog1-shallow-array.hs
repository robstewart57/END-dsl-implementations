
module Main where

import ShallowArray
import IO

main = do
    img <- readImgPlainArray "../../images/train.png"
    let newImg = blurX img
    return () -- TODO time newImg to normal form.
