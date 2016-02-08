
module Main where

import GADT
import IO

main = do
    img1 <- readImgPlainArray "../../images/train.png"
    print (eval (BlurX (ConImage img1)))
