{-# LANGUAGE GADTs #-}

module DeepGADT where

import Prelude hiding ((+),(-))
import qualified Prelude as Prelude
import qualified Data.Vector.Unboxed as V
import Types
import qualified ShallowVector as Shallow -- evaluation with the host language

data Exp a where
    Img        :: VectorImage -> Exp VectorImage
    I          :: Int -> Exp Int
    BrightenBy :: Exp Int -> Exp VectorImage -> Exp VectorImage
    DarkenBy   :: Exp Int -> Exp VectorImage -> Exp VectorImage
    BlurX      :: Exp VectorImage -> Exp VectorImage
    BlurY      :: Exp VectorImage -> Exp VectorImage

integer    = I
image      = Img
(+)        = BrightenBy
(-)        = DarkenBy
blurX      = BlurX
blurY      = BlurY

-- | interpret optimised AST
eval :: Exp a -> a
eval (I i)     = i
eval (Img img) = img
eval (BrightenBy i exp) = Shallow.brightenBy (eval i) (eval exp)
eval (DarkenBy  i exp)  = Shallow.darkenBy (eval i) (eval exp)
eval (BlurX exp)        = Shallow.blurX (eval exp)
eval (BlurY exp)        = Shallow.blurY (eval exp)

run :: Exp a -> a
run ast = eval (optimiseAST ast)

-- | AST optimiser contains 2 optimisations:
--   (brighten n . darken n) = id
--   (darken n . brighten n) = id
--
-- this simple optimiser traverses from the
-- outer most constructor, inwards.
optimiseAST :: Exp a -> Exp a
optimiseAST (BrightenBy (I i) (DarkenBy (I j) subExp))
         | i == j    = optimiseAST subExp -- eliminate (brighten n . darken n)
         | otherwise = BrightenBy (I i) (DarkenBy (I j) (optimiseAST subExp))
optimiseAST exp@(DarkenBy (I i) (BrightenBy (I j) subExp))
         | i == j    = optimiseAST subExp -- eliminate (darken n . brighten n)
         | otherwise = DarkenBy (I i) (BrightenBy (I j) (optimiseAST subExp))

optimiseAST (BrightenBy i exp) = (BrightenBy i (optimiseAST exp))
optimiseAST (DarkenBy i exp) = (DarkenBy i (optimiseAST exp))
optimiseAST (BlurX exp) = BlurX (optimiseAST exp)
optimiseAST (BlurY exp) = BlurY (optimiseAST exp)
optimiseAST exp@Img{} = exp
optimiseAST exp@I{} = exp
