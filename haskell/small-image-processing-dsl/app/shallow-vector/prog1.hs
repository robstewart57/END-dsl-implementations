
module Main where

import ShallowVector
import IO

main = do
    img1 <- readImgAsVector "../../images/maisie.png"
    newImg <- printTimeDeep (brightenBy 20 img1)
    writeVectorImage "../../images/prog1-out-vector.png" newImg
