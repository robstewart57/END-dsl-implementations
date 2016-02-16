
module Main where

import Prelude hiding ((+),(-))
import System.Environment
import DeepGADT
import IO

main = do
    args <- getArgs
    let [inImg,outImg,_] = args
    img1 <- readImgAsVector inImg
    newImg <- printTime (run ((integer 30) + (blurY (blurX (image img1)))))
    writeVectorImage outImg newImg
