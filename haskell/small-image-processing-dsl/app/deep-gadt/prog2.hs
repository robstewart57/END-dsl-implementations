
module Main where

import System.Environment
import DeepGADT
import IO

main = do
    args <- getArgs
    let [inImg,outImg] = args
    img1 <- readImgAsVector inImg
    newImg <- printTimeDeep (run (blurX (blurX (image img1))))
    writeVectorImage outImg newImg
