
module Main where

import System.Environment
import ShallowVector
import IO

main = do
    args <- getArgs
    let [inImg,outImg,_] = args
    img1 <- readImgAsVector inImg
    newImg <- printTimeDeep (brightenBy 20 img1)
    writeVectorImage outImg newImg
