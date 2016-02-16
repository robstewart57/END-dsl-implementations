
module Main where

import System.Environment
import DeepAccelerate
import IO

main = do
    args <- getArgs
    let [inImg,outImg] = args
    img1 <- readImgAsAccelerateArray inImg
    m <- read <$> getLine
    newImg <- printTime (run ((darkenBy m . brightenBy m) img1))
    writeAccelerateImg outImg newImg
