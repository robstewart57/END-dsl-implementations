
module Main where

import DeepGADT
import IO

-- | essentially no computation
main = do
    img1 <- readImgPlainArray "../../images/train.png"
    let newImg = run (Darken (ConI 10) ((Brighten (ConI 10) (ConImage img1)))))
    return () -- TODO time newImg to normal form.
