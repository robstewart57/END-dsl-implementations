{-# LANGUAGE ScopedTypeVariables #-}

module DeepAccelerate where

import Prelude as P
import Data.Array.Accelerate -- hiding (fromIntegral,round)
import qualified Data.Array.Accelerate as A
import Types
-- import qualified Data.Array.Accelerate.LLVM.PTX as PTX
import qualified Data.Array.Accelerate.Interpreter as A

type Stencil3x1 a = (Stencil3 a, Stencil3 a, Stencil3 a)
type Stencil1x3 a = (Stencil3 a, Stencil3 a, Stencil3 a)

run :: A.Acc AccelerateImage -> AccelerateImage
-- run = PTX.run
run = A.run

blurX :: A.Acc AccelerateImage -> A.Acc AccelerateImage
blurX = A.map (\(x::Exp Int) -> (A.round (A.fromIntegral x / 4.0 ::Exp Double)) :: Exp Int)
        . stencil (convolve3x1 kernel) Clamp
  where
    kernel = [ 1, 2, 1 ]

blurY :: A.Acc AccelerateImage -> A.Acc AccelerateImage
blurY = A.map (\(x::Exp Int) -> (A.round (A.fromIntegral x / 4.0 ::Exp Double)) :: Exp Int)
        . stencil (convolve1x3 kernel) Clamp
  where
    kernel = [ 1, 2, 1 ]

convolve1x3 :: (Elt a, IsNum a) => [Exp a] -> Stencil1x3 a -> Exp a
convolve1x3 kernel ((_,a,_), (_,b,_), (_,c,_))
  = P.sum $ P.zipWith (*) kernel [a,b,c]

convolve3x1 :: (Elt a, IsNum a) => [Exp a] -> Stencil3x1 a -> Exp a
convolve3x1 kernel (_, (a,b,c), _)
  = P.sum $ P.zipWith (*) kernel [a,b,c]

brightenBy, darkenBy :: Int
                     -> A.Acc AccelerateImage
                     -> A.Acc AccelerateImage
brightenBy i = A.map (+(A.lift i))
darkenBy   i = A.map (\x -> x-(A.lift i))
