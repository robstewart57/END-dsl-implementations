
module Main where

import System.Environment
import DeepAccelerate
import IO

main = do
    args <- getArgs
    let [inImg,outImg] = args
    img1 <- readImgAsAccelerateArray inImg
    newImg <- printTime (run ((blurX . blurX) img1))
    writeAccelerateImg outImg newImg
