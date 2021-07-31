{-# LANGUAGE TemplateHaskell #-}
module Lib2 where

import Control.Lens

lib :: String
lib = "string from lib"

data Test = Test
  { testField1 :: Int
  , testField2 :: String
  }

makeLenses ''Test
