
module Main where

import Prelude hiding ((+),(-))
import DeepGADT
import IO

main = do
    img <- readImgAsVector "../../images/maisie.png"
    m <- read <$> getLine
--    let newImg = run $ darkenBy (int m) (brightenBy (int m) (image img))
    let newImg = run $ (image img + integer m) - integer m
    return () -- TODO time newImg to normal form.
