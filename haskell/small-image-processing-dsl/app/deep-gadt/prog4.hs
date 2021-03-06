
module Main where

import Prelude hiding ((+),(-))
import System.Environment
import DeepGADT
import IO

main = do
    args <- getArgs
    let [inImg,outImg] = args
    m <- read <$> getLine
    n <- read <$> getLine
    img1 <- readImgAsVector inImg
    newImg <- printTimeDeep (run ((integer n) - ((integer m) + (image img1))))
    writeVectorImage outImg newImg
