{-# LANGUAGE GADTs #-}

module GADT where

import Data.Array.IArray

type Image = Array (Int,Int) Int

data Exp a where
    ConImage :: Image -> Exp Image
    ConI     :: Int -> Exp Int
    ConF     :: Int -> Exp Int
    Brighten :: Exp Int -> Exp Image -> Exp Image
    Darken   :: Exp Int -> Exp Image -> Exp Image
    BlurX    :: Exp Image -> Exp Image
    BlurY    :: Exp Image -> Exp Image
    MaxPixel :: Exp Image -> Exp Int

-- | interpret optimised AST
eval :: Exp a -> a
eval (ConImage img) = img
eval (Brighten i exp) = amap (+ (eval i)) (eval exp)
eval (Darken   i exp) = amap ((-) (eval i)) (eval exp)
eval (BlurX exp)      = undefined
eval (BlurY exp)      = undefined
eval (MaxPixel exp)   = undefined

run :: Exp a -> a
run ast = eval (optimise ast)

-- | AST optimiser contains 2 optimisations:
--   (brighten n . darken n) = id
--   (darken n . brighten n) = id
optimise :: Exp a -> Exp a
optimise exp@(Brighten (ConF i) (Darken (ConF j) subExp))
         | i == j    = optimise subExp -- eliminate
         | otherwise = optimise exp
optimise exp@(Darken (ConF i) (Brighten (ConF j) subExp))
         | i == j    = optimise subExp -- eliminate
         | otherwise = optimise exp


-- let arr = Data.Array.array ((1,1),(2,2)) [((1,1),1),((1,2),2),((2,1),3),((2,2),4)] :: Data.Array.Array (Int,Int) Int
