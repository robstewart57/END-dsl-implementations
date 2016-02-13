
module Main where

import DeepGADT
import IO

main = do
    img <- readImgAsVector "../../images/train.png"
    let newImg = run (BlurX (ConImage img))
    return () -- TODO time evaluation of newImg to normal form.
