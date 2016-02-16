
module Main where

import System.Environment
import ShallowRepa
import IO
import Text.Printf

main = do
    args <- getArgs
    let [inImg,outImg] = args
    img <- readImgAsRepaArray inImg
    m <- read <$> getLine
    n <- read <$> getLine
    newImg <- printTimeIO $ run ((darkenBy n . brightenBy m) img)
    writeRepaImg outImg newImg
