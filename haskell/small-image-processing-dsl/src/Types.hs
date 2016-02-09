{-# Language TypeOperators #-}

module Types where

import Data.Vector
import Data.Array.Repa (Array,D,U,Z,(:.))
import qualified Data.Array.Repa as R

data RelativePosition = Above | Below | LeftOf | RightOf

type RepaImage = Array D (Z :. Int :. Int) (Int,Int,Int)
type RepaImageComputed = Array U (Z :. Int :. Int) (Int,Int,Int)

data VectorImage = VectorImage
           { pixels :: Vector (Int,Int,Int) -- ^ row major order
           , width  :: Int
           , height :: Int
           }

onRGB :: (Int -> Int) -> (Int,Int,Int) -> (Int,Int,Int)
onRGB f (r,g,b) = (f r, f g, f b)
