
module Main where

import DeepAccelerate
import IO
import Text.Printf

main = do
  img1 <- readImgAsAccelerateArray "../../images/maisie.png"
  newImg <- printTime (run (brightenBy 20 img1))
  writeAccelerateImg "../../images/prog1-out-accelerate.png" newImg
