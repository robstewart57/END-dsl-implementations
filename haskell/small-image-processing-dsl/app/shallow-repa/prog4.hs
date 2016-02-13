
module Main where

import ShallowRepa
import IO

main = do
    img <- readImgAsRepaArray "../../images/train.png"
    m <- read <$> getLine
    n <- read <$> getLine
    newImg <- run ((darkenBy n . brightenBy m) img)
    return () -- TODO time newImg to normal form.
