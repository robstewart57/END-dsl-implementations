
module Types where

import Data.Vector

data VectorImage = VectorImage
           { pixels :: Vector (Int,Int,Int)
           , width  :: Int
           , height :: Int
           }

onRGB :: (Int -> Int) -> (Int,Int,Int) -> (Int,Int,Int)
onRGB f (r,g,b) = (f r, f g, f b)
