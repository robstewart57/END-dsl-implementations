
module Main where

import System.Environment
import ShallowVector
import IO

main = do
    args <- getArgs
    let [inImg,outImg,_] = args
    img1 <- readImgAsVector inImg
    m <- read <$> getLine
    n <- read <$> getLine
    newImg <- printTimeDeep ((darkenBy n . brightenBy m) img1)
    writeVectorImage outImg newImg
