
module Main where

import DeepAccelerate
import IO
import Text.Printf

main = do
  img1 <- readImgAsAccelerateArray "../../images/maisie.png"
  m <- read <$> getLine
  n <- read <$> getLine
  newImg <- printTime (run ((darkenBy n . brightenBy m) img1))
  writeAccelerateImg "../../images/prog4-out-accelerate.png" newImg
