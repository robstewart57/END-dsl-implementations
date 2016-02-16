
module Main where

import System.Environment
import DeepAccelerate
import IO

main = do
    args <- getArgs
    let [inImg,outImg,_] = args
    img1 <- readImgAsAccelerateArray inImg
    newImg <- printTime (run ((brightenBy 30 . blurY . blurX) img1))
    writeAccelerateImg outImg newImg
