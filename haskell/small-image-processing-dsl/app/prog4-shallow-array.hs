
module Main where

import ShallowArray
import IO

main = do
    img <- readImgPlainArray "../../images/train.png"
    m <- read <$> getLine
    n <- read <$> getLine
    let newImg = (darken n . brighten m) img
    return () -- TODO time newImg to normal form.
