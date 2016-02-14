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

{-# RULES "darkenBy+brightenBy" forall im1 n. darkenBy n (brightenBy n im1) = im1 #-}
{-# RULES "brightenBy+darkenBy" forall im1 n. brightenBy n (darkenBy n im1) = im1 #-}

run :: RepaImage -> IO RepaImageComputed
run = R.computeP

blurX,blurY :: RepaImage -> RepaImage

blurX img =
        (delay
        . R.map (\x -> round ((fromIntegral x) /4.0))
        . mapStencil2 BoundClamp
          [stencil2| 1 2 1 |]) img
{-# NOINLINE blurX #-}

blurY img =
        (delay
        . R.map (\x -> round ((fromIntegral x) /4.0))
        . mapStencil2 BoundClamp
          [stencil2| 1
                     2
                     1 |]) img
{-# NOINLINE blurY #-}

brightenBy,darkenBy :: Int -> Array D (Z :. Int :. Int) Int -> Array D ((Z :. Int) :. Int) Int
brightenBy i = R.map (+i)
{-# NOINLINE brightenBy #-}

darkenBy   i = R.map (\x -> x-i)
{-# NOINLINE darkenBy #-}
