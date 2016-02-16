
module Main where

import System.Environment
import DeepGADT
import IO

main = do
    args <- getArgs
    let [inImg,outImg,_] = args
    img1 <- readImgAsVector inImg
    newImg <- printTime (run (blurX (blurX (image img1))))
    writeVectorImage outImg newImg
