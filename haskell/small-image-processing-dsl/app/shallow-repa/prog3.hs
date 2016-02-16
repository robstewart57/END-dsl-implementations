
module Main where

import System.Environment
import ShallowRepa
import IO
import Text.Printf

main = do
    args <- getArgs
    let [inImg,outImg,_] = args
    img <- readImgAsRepaArray inImg
    m <- read <$> getLine
    newImg <- printTimeIO $ run ((darkenBy m . brightenBy m) img)
    writeRepaImg outImg newImg
