
module ShallowRepa where

import Data.Array.Repa
import qualified Data.Array.Repa as R
import Types

run :: RepaImage -> IO RepaImageComputed
run = R.computeP

blurX,blurY :: RepaImage -> RepaImage
blurX = undefined

blurY = undefined

brightenBy,darkenBy :: Int -> RepaImage -> RepaImage
brightenBy i img = R.map (onRGB (+1)) img
darkenBy   i img = R.map (onRGB (\x -> x-i)) img
