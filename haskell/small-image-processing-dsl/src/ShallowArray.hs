
module ShallowArray where

import qualified Data.Vector as V
import Types

blurX, blurY :: VectorImage -> VectorImage
blurX img@(VectorImage pixels w h) = VectorImage (V.imap blurAtPosition pixels) w h
    where
      blurAtPosition idx p@(r,g,b)
          | leftEdgePixel  img idx =
              blur (r,g,b)
                   (r,g,b)
                   (rgbAt LeftOf pixels idx)
          | rightEdgePixel img idx =
              blur (r,g,b)
                   (rgbAt RightOf pixels idx)
                   (r,g,b)
          | otherwise =
              blur (r,g,b)
                   (rgbAt LeftOf pixels idx)
                   (rgbAt RightOf pixels idx)

blurY img@(VectorImage pixels w h) = VectorImage (V.imap blurAtPosition pixels) w h
    where
      blurAtPosition idx p@(r,g,b)
          | topEdgePixel  img idx =
              blur (r,g,b)
                   (r,g,b)
                   (rgbAt Below pixels idx)
          | bottomEdgePixel img idx =
              blur (r,g,b)
                   (rgbAt Above pixels idx)
                   (r,g,b)
          | otherwise =
              blur (r,g,b)
                   (rgbAt Above pixels idx)
                   (rgbAt Below pixels idx)

blur :: (Int,Int,Int) -> (Int,Int,Int) -> (Int,Int,Int) -> (Int,Int,Int)
blur (r,g,b) (rBefore,gBefore,bBefore) (rAfter,gAfter,bAfter) = (newR,newG,newB)
    where
      newR = floor (fromIntegral (r * 2 + rBefore + rAfter) / 4.0)
      newG = floor (fromIntegral (g * 2 + gBefore + gAfter) / 4.0)
      newB = floor (fromIntegral (b * 2 + bBefore + bAfter) / 4.0)

leftEdgePixel, rightEdgePixel, topEdgePixel, bottomEdgePixel :: VectorImage -> Int -> Bool
leftEdgePixel   = undefined
rightEdgePixel  = undefined
topEdgePixel    = undefined
bottomEdgePixel = undefined

rgbAt :: RelativePosition -> V.Vector (Int,Int,Int) -> Int -> (Int,Int,Int)
rgbAt  LeftOf vec idx = vec V.! (idx-1)
rgbAt  RightOf vec idx = vec V.! (idx+1)
rgbAt  Above vec idx = undefined
rgbAt  Below vec idx = undefined


brightenBy,darkenBy :: Int -> VectorImage -> VectorImage
brightenBy i (VectorImage pixels w h) = VectorImage (V.map (onRGB (+1)) pixels) w h
darkenBy   i (VectorImage pixels w h) = VectorImage (V.map (onRGB (\x -> x-1)) pixels) w h
