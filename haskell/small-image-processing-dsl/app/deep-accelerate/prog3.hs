
module Main where

import DeepAccelerate
import IO
import Text.Printf
import System.IO

main = do
  img1 <- readImgAsAccelerateArray "../../images/maisie.png"
  m <- read <$> getLine
  newImg <- printTime (run ((darkenBy m . brightenBy m) img1))
  writeAccelerateImg "../../images/prog3-out-accelerate.png" newImg
