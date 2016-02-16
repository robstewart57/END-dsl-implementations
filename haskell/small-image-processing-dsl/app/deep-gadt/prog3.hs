
module Main where

import Prelude hiding ((+),(-))
import System.Environment
import DeepGADT
import IO

main = do
    args <- getArgs
    let [inImg,outImg,_] = args
    m <- read <$> getLine
    img1 <- readImgAsVector inImg
    newImg <- printTime (run ((integer m) - ((integer m) + (image img1))))
    writeVectorImage outImg newImg
