
module Main where

import GADT
import IO


-- | essentially no computation
main = do
    img1 <- readImgPlainArray "../../images/train.png"
    print (run (Darken (ConI 10) ((Brighten (ConI 10) (ConImage img1)))))
