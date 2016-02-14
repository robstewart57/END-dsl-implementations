{-# Language RankNTypes #-}
{-# Language TypeOperators #-}
{-# Language BangPatterns #-}

module IO where

-- import Data.Array
import Prelude hiding (traverse)
import Data.Vector hiding (force)
import Data.Array.Repa
import Types
import System.CPUTime
import Data.Array.Repa.IO.DevIL
import Data.Word
import qualified Data.Array.Repa as R
import Debug.Trace
import System.Directory
import Control.Exception
import Control.DeepSeq
import Data.Array.Repa.Repr.ForeignPtr
import System.IO.Error hiding (catch)

time :: IO a -> IO (Double,a)
time action = do
  start <- getCPUTime
  a <- action
  end   <- getCPUTime
  let diff = (fromIntegral (end - start)) / (10^12)
  return (diff,a)

-- TODO: use bang pattern on read image
readImgAsVector :: String -> IO VectorImage
readImgAsVector = undefined

readImgAsRepaArray :: String -> IO RepaImage
readImgAsRepaArray fname = do
  !img <- readImg
  return (delay img)
    where
      readImg =
          runIL $ do
            (RGB a) <- readImage fname
            img <- computeP $ traverse a (\(Z :. x :. y :. _) -> (Z :. x :. y)) luminosity :: IL (Array U DIM2 Word8)
            promote img

-- writeImage :: FilePath -> Image -> IL ()
writeRepaImg :: String -> RepaImageComputed -> IO ()
writeRepaImg fname img = do
  removeIfExists fname
  im <- demote img
  runIL $ do
    writeImage fname (Grey im)

removeIfExists :: FilePath -> IO ()
removeIfExists fileName = removeFile fileName `catch` handleExists
  where handleExists e
          | isDoesNotExistError e = return ()
          | otherwise = throwIO e

luminosity :: (DIM3 -> Word8) -> DIM2 -> Word8
luminosity f (Z :. i :. j) = ceiling $ (0.21::Double) * r + 0.71 * g + 0.07 * b
    where
        r = fromIntegral $ f (Z :. i :. j :. 0)
        g = fromIntegral $ f (Z :. i :. j :. 1)
        b = fromIntegral $ f (Z :. i :. j :. 2)

promote :: Monad m => Array U DIM2 Word8 -> m (Array U DIM2 Double)
promote arr
 = computeP $ R.map ffs arr
 where  {-# INLINE ffs #-}
        ffs     :: Word8 -> Double
        ffs x   =  fromIntegral (fromIntegral x :: Int)
{-# NOINLINE promote #-}

demote  :: Monad m => Array U DIM2 Double -> m (Array F DIM2 Word8)
demote arr
 = computeP $ R.map ffs arr

 where  {-# INLINE ffs #-}
        ffs     :: Double -> Word8
        ffs x   =  fromIntegral (truncate x :: Int)
{-# NOINLINE demote #-}
