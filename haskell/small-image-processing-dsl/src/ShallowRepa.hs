{-# LANGUAGE QuasiQuotes #-}
{-# Language RankNTypes #-}
{-# Language TypeOperators #-}
{-# Language FlexibleContexts #-}

module ShallowRepa where

import Data.Array.Repa
import qualified Data.Array.Repa as R
import Data.Array.Repa.Stencil.Dim2
import Data.Array.Repa.Stencil
import Types

run :: RepaImage -> IO RepaImageComputed
run = R.computeP

blurX,blurY :: RepaImage -> RepaImage

blurX img =
        (delay
        . mapStencil2 BoundClamp
          [stencil2| 1 2 1 |]) img
{-# NOINLINE blurX #-}

blurY img =
        delay
        $ mapStencil2 BoundClamp
          [stencil2| 1
                     2
                     1 |] img
{-# NOINLINE blurY #-}

brightenBy,darkenBy :: Int -> Array D (Z :. Int :. Int) Int -> Array D ((Z :. Int) :. Int) Int
brightenBy i = R.map (+i)
darkenBy   i = R.map (\x -> x-i)
