
module ShallowArray where

import qualified Data.Vector as V
import Types

blurX, blurY :: VectorImage -> VectorImage
blurX = undefined
-- blurX img = img // newElems
--     where
--       rows = undefined
--       {- blur in X direction -}
--       newElems = map ( undefined  ) rows

blurY = undefined

brighten,darken :: Int -> VectorImage -> VectorImage
brighten i (VectorImage pixels w h) = VectorImage (V.map (onRGB (+1)) pixels) w h
darken   i (VectorImage pixels w h) = VectorImage (V.map (onRGB (\x -> x-1)) pixels) w h
