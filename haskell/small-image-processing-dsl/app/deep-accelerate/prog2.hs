
module Main where

import DeepAccelerate
import IO
import Text.Printf

main = do
  img1 <- readImgAsAccelerateArray "../../images/maisie.png"
  newImg <- printTime (run (blurX img1))
  writeAccelerateImg "../../images/prog2-out-accelerate.png" newImg
