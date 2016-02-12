{-# LANGUAGE GADTs #-}

module DeepGADT where

import Prelude hiding ((+),(-))
import qualified Prelude as Prelude
import qualified Data.Vector as V
import Types

data Exp a where
    ConImage   :: VectorImage -> Exp VectorImage
    ConInt     :: Int -> Exp Int
--    ConF       :: Int -> Exp Int
    BrightenBy :: Exp VectorImage -> Exp Int -> Exp VectorImage
    DarkenBy   :: Exp VectorImage -> Exp Int -> Exp VectorImage
    BlurX      :: Exp VectorImage -> Exp VectorImage
    BlurY      :: Exp VectorImage -> Exp VectorImage

integer    = ConInt
image      = ConImage
brightenBy = BrightenBy
(+)        = BrightenBy
(-)        = DarkenBy
blurX      = BlurX
blurY      = BlurY

-- | interpret optimised AST
eval :: Exp a -> a
eval (ConInt i)     = i
eval (ConImage img) = img
eval (BrightenBy exp i) = VectorImage (V.map (onRGB (Prelude.+ 1)) pixels) w h
    where
      VectorImage pixels w h = eval exp
eval (DarkenBy  exp i)  = undefined -- amap ((-) (eval i)) (eval exp)
eval (BlurX exp)      = undefined
eval (BlurY exp)      = undefined

run :: Exp a -> a
run ast = eval (optimiseAST ast)

-- | AST optimiser contains 2 optimisations:
--   (brighten n . darken n) = id
--   (darken n . brighten n) = id
--
-- this simple optimiser traverses from the
-- outer most constructor, inwards.
optimiseAST :: Exp a -> Exp a
optimiseAST (BrightenBy (DarkenBy subExp (ConInt j)) (ConInt i))
         | i == j    = optimiseAST subExp -- eliminate (brighten n . darken n)
         | otherwise = BrightenBy (DarkenBy (optimiseAST subExp) (ConInt j)) (ConInt i)
optimiseAST exp@(DarkenBy (BrightenBy subExp (ConInt j)) (ConInt i))
         | i == j    = optimiseAST subExp -- eliminate (darken n . brighten n)
         | otherwise = DarkenBy (DarkenBy (optimiseAST subExp) (ConInt j)) (ConInt i)
optimiseAST (BlurX exp) = BlurX (optimiseAST exp)
optimiseAST (BlurY exp) = BlurY (optimiseAST exp)
optimiseAST exp@ConImage{} = exp
optimiseAST exp@ConInt{} = exp

-- let arr = Data.Array.array ((1,1),(2,2)) [((1,1),1),((1,2),2),((2,1),3),((2,2),4)] :: Data.Array.Array (Int,Int) Int
