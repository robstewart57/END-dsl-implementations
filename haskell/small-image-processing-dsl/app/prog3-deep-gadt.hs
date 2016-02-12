module Main where

import Prelude hiding ((+),(-))
import DeepGADT
import IO

main = do
    img <- readImgAsVector "../../images/train.png"
--    let newImg = run (BrightenBy (BlurY (BlurX (ConImage img))) (ConInt 50))
    let newImg = run $ blurY (blurX (image img)) + integer 50
    return () -- TODO time evaluation of newImg to normal form.
