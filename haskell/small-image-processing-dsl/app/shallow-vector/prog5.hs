
module Main where

import System.Environment
import ShallowVector
import IO

main = do
    args <- getArgs
    let [inImg,outImg] = args
    img1 <- readImgAsVector inImg
    newImg <- printTimeDeep ((brightenBy 30 . blurY . blurX) img1)
    writeVectorImage outImg newImg
