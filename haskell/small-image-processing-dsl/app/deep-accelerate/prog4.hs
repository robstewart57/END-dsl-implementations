
module Main where

import System.Environment
import DeepAccelerate
import IO

main = do
    args <- getArgs
    let [inImg,outImg,_] = args
    img1 <- readImgAsAccelerateArray inImg
    m <- read <$> getLine
    n <- read <$> getLine
    newImg <- printTime (run ((darkenBy n . brightenBy m) img1))
    writeAccelerateImg outImg newImg
