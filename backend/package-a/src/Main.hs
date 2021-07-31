{-# LANGUAGE TemplateHaskell #-}
module Main where

import Lib2
import Data.List
import Control.Lens

main :: IO ()
main = print $ head ["test"]

data Test2 = Test
  { testField21 :: Int
  , testField22 :: String
  }

makeLenses ''Test2
