{-# Language TypeOperators #-}
{-# Language RankNTypes #-}
{-# Language FlexibleContexts #-}
{-# LANGUAGE DeriveGeneric #-}

module Types where

import Data.Vector
import Data.Array.Repa (Array,D,U,Z,(:.))
import qualified Data.Array.Repa as R
import Data.Array.Repa.Eval (Load)
import qualified Data.Array.Accelerate as A
import Control.DeepSeq
import GHC.Generics (Generic)

type AccelerateImage = A.Array A.DIM2 Int

data RelativePosition = Above | Below | LeftOf | RightOf

type RepaImage = Array D (Z :. Int :. Int) Int
type RepaImageComputed = Array U (Z :. Int :. Int) Int

data VectorImage = VectorImage
           { pixels :: Vector Int -- ^ row major order
           , width  :: Int
           , height :: Int
           } deriving (Generic)

instance NFData VectorImage

-- onRGB :: (Int -> Int) -> (Int,Int,Int) -> (Int,Int,Int)
-- onRGB f (r,g,b) = (f r, f g, f b)
