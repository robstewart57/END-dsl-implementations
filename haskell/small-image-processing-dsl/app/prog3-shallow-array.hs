
module Main where

import ShallowArray
import IO

main = do
    img <- readImgPlainArray "../../images/train.png"
    let newImg = (brighten 10 . blurY . blurX) img
    return () -- TODO time newImg to normal form.
