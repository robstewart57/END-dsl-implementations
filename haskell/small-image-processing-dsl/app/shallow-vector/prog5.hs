
module Main where

import ShallowVector
import IO

main = do
    img1 <- readImgAsVector "../../images/maisie.png"
    newImg <- printTimeDeep ((brightenBy 30 . blurY . blurX) img1)
    writeVectorImage "../../images/prog5-out-vector.png" newImg
