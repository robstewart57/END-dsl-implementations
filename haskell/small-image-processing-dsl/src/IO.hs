{-# Language RankNTypes #-}
{-# Language TypeOperators #-}
{-# Language BangPatterns #-}

module IO where

-- import Data.Array
import Prelude hiding (traverse)
import Data.Vector hiding (force)
import qualified Data.Vector as V
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
import Data.Array.Accelerate.IO
import qualified Data.Array.Accelerate as A
import Text.Printf
import qualified Codec.Picture as Codec
import Control.DeepSeq

printDiff start end = do
    let diff = (fromIntegral (end - start)) / (10^12)
    printf "%0.3f\n" (diff :: Double)

-- | time monadic computation.
printTimeIO :: IO a -> IO a
printTimeIO action = do
  start <- getCPUTime
  a <- action
  end   <- getCPUTime
  printDiff start end
  return a

-- see about the following benchmark
-- https://github.com/AccelerateHS/accelerate/issues/208

-- | time evaluation of pure computation.
printTime :: a -> IO a
printTime f = do
  start <- getCPUTime
  end <- seq f getCPUTime
  printDiff start end
  return f

printTimeDeep :: (NFData a) => a -> IO a
printTimeDeep f = do
  start <- getCPUTime
  end <- deepseq f getCPUTime
  printDiff start end
  return f

writeVectorImage :: String -> VectorImage -> IO ()
writeVectorImage fname vecImg = Codec.writePng fname img
    where
      img = Codec.generateImage (\x y -> (fromIntegral $ (V.!) (pixels vecImg) ((width vecImg)*y + x))::Word8) (width vecImg) (height vecImg)

readImgAsVector :: String -> IO VectorImage
readImgAsVector fname = do
    (Right !img) <- Codec.readImage fname
    case img of
     Codec.ImageRGB8 rgbImg -> do
          let Codec.Image imgWidth imgHeight _ = rgbImg
              positions = Prelude.concatMap (\h -> Prelude.map (\w -> (w,h)) [0..imgWidth-1]) [0..imgHeight-1]
              vec = fromList (Prelude.map (\(x,y) -> let (Codec.PixelRGB8 r g b) = Codec.pixelAt rgbImg x y
                                                     in rgbToGreyPixel r g b) positions)
          return $ VectorImage vec imgWidth imgHeight
     _ -> error "readImgAsVector: unsupported image type."

rgbToGreyPixel :: Word8 -> Word8 -> Word8 -> Int
rgbToGreyPixel r g b = ceiling $ (0.21::Double) * fromIntegral r + 0.71 * fromIntegral g + 0.07 * fromIntegral b

readImgAsAccelerateArray :: String -> IO (A.Acc AccelerateImage)
readImgAsAccelerateArray fname = do
  arr <- readImgAsManifestRepaArray fname
  return (A.use (fromRepa arr))

readImgAsRepaArray :: String -> IO RepaImage
readImgAsRepaArray fname = do
  arr <- readImgAsManifestRepaArray fname
  return (delay arr)

readImgAsManifestRepaArray :: String -> IO (Array A (Z :. Int :. Int) Int)
readImgAsManifestRepaArray fname = do
  !img <- readImg
  return img
    where
      readImg =
          runIL $ do
            (RGB a) <- readImage fname
            img <- computeP $ traverse a (\(Z :. x :. y :. _) -> (Z :. x :. y)) luminosity :: IL (Array A DIM2 Int)
            return img

writeAccelerateImg :: String -> AccelerateImage -> IO ()
writeAccelerateImg fname img = do
  repaImage <- copyP (toRepa img)
  writeRepaImg fname repaImage

-- writeRepaImg :: String -> RepaImageComputed -> IO ()
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

luminosity :: (DIM3 -> Word8) -> DIM2 -> Int
luminosity f (Z :. i :. j) = ceiling $ (0.21::Double) * r + 0.71 * g + 0.07 * b
    where
        r = fromIntegral $ f (Z :. i :. j :. 0)
        g = fromIntegral $ f (Z :. i :. j :. 1)
        b = fromIntegral $ f (Z :. i :. j :. 2)

demote  :: Monad m => Array U DIM2 Int -> m (Array F DIM2 Word8)
demote arr
 = computeP $ R.map ffs arr

 where  {-# INLINE ffs #-}
        ffs     :: Int -> Word8
        ffs x   =  fromIntegral (x :: Int)
{-# NOINLINE demote #-}
