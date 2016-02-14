
module Main where

import ShallowVector
import IO

main = do
    img1 <- readImgAsVector "../../images/maisie.png"
    m <- read <$> getLine
    n <- read <$> getLine
    newImg <- printTimeDeep ((darkenBy n . brightenBy m) img1)
    writeVectorImage "../../images/prog4-out-vector.png" newImg
