
module ShallowVector where

import qualified Data.Vector.Unboxed as V
import Types
import Debug.Trace

{-# RULES "darkenBy.brightenBy" forall im1 n. darkenBy n (brightenBy n im1) = im1 #-}
{-# RULES "brightenBy.darkenBy" forall im1 n. brightenBy n (darkenBy n im1) = im1 #-}

-- TODO: overload + and - to be brightenBy and darkenBy

-- inline the blur functions so that they can be fused when used together,
-- using the fusion optimisations in the vector library.

{-# INLINE blurY #-}
blurY :: VectorImage -> VectorImage
blurY (VectorImage pixels w h) = VectorImage newPixels w h
    where
      newPixels = V.imap blurPixel pixels
      normalise x = round (fromIntegral x / 4.0)
      blurPixel i p
         -- bottom of a column
         | (i+1) `mod` h == 0 =
             normalise ((pixels V.! (i-1)) + p*2 + p)

         -- top of a column
         | i `mod` h == 0 =
             normalise (p + p*2 + (pixels V.! (i+1)))

         -- somewhere in between
         | otherwise =
             normalise (pixels V.! (i-1) + p*2 + (pixels V.! (i+1)))


{-# INLINE blurX #-}
blurX :: VectorImage -> VectorImage
blurX (VectorImage pixels w h) = VectorImage newPixels w h
    where
      newPixels = V.imap blurPixel pixels
      normalise x = round (fromIntegral x / 4.0)
      blurPixel i p
         -- right end of a row
         | (i+1) `mod` w == 0 =
             normalise ((pixels V.! (i-1)) + p*2 + p)

         -- left start to a row
         | i `mod` w == 0 =
             normalise (p + p*2 + (pixels V.! (i+1)))

         -- somewhere in between
         | otherwise =
             normalise (pixels V.! (i-1) + p*2 + (pixels V.! (i+1)))


-- don't inline, so they can be eliminated with the rewrite rule at the top.

{-# NOINLINE brightenBy #-}
{-# NOINLINE darkenBy #-}
brightenBy,darkenBy :: Int -> VectorImage -> VectorImage
brightenBy i (VectorImage pixels w h) = VectorImage (V.map ((\x -> min 255 (x+1))) pixels) w h
darkenBy   i (VectorImage pixels w h) = VectorImage (V.map ((\x -> max 0   (x-1))) pixels) w h
