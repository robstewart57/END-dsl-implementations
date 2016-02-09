
module Types where

import Data.Vector

data RelativePosition = Above | Below | LeftOf | RightOf

data VectorImage = VectorImage
           { pixels :: Vector (Int,Int,Int) -- ^ row major order
           , width  :: Int
           , height :: Int
           }

onRGB :: (Int -> Int) -> (Int,Int,Int) -> (Int,Int,Int)
onRGB f (r,g,b) = (f r, f g, f b)
