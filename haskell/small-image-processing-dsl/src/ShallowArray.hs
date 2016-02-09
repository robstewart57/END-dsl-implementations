
module ShallowArray where

import Data.Array.IArray

type Image = Array (Int,Int) Int

blurX, blurY :: Image -> Image
blurX = undefined
blurY = undefined

brighten,darken :: Int -> Image -> Image
brighten i = amap (+i)
darken   i = amap (\p -> p-i)
