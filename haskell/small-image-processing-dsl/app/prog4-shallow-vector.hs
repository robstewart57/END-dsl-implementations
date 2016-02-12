
module Main where

import ShallowVector
import IO

main = do
    img <- readImgAsVector "../../images/train.png"
    m <- read <$> getLine
    n <- read <$> getLine
    let newImg = (darkenBy n . brightenBy m) img
    return () -- TODO time newImg to normal form.
