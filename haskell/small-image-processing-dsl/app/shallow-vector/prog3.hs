
module Main where

import ShallowVector
import IO

main = do
    img1 <- readImgAsVector "../../images/maisie.png"
    m <- read <$> getLine
    newImg <- printTimeDeep ((darkenBy m . brightenBy m) img1)
    writeVectorImage "../../images/prog3-out-vector.png" newImg
