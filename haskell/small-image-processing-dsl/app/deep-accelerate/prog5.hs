
module Main where

import DeepAccelerate
import IO
import Text.Printf

main = do
  img1 <- readImgAsAccelerateArray "../../images/maisie.png"
  newImg <- printTime (run ((brightenBy 30 . blurY . blurX) img1))
  writeAccelerateImg "../../images/prog5-out-accelerate.png" newImg
