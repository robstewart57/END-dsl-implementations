
module Main where

import ShallowVector
import IO

main = do
    img1 <- readImgAsVector "../../images/maisie.png"
    newImg <- printTimeDeep ((blurX . blurX) img1)
    writeVectorImage "../../images/prog2-out-vector.png" newImg
