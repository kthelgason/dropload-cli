{-# LANGUAGE OverloadedStrings #-}
module Main where

import           System.Environment
import           System.Exit
import           Network.Wreq
import           Control.Lens
import           Data.Aeson.Lens (key, _String)
import qualified Data.Text.IO (putStrLn)

base_url :: String
base_url = "http://dropload.services.sigsegv.is/api/upload"

-- TODO: Support streaming of large files
upload :: String -> IO ()
upload file = do
  r <- post base_url (partFile "file" file)
  Data.Text.IO.putStrLn $ r ^. responseBody . key "url" . _String

usage :: IO ()
usage = do
  prog <- getProgName
  putStrLn $ "Usage: " ++ prog ++ " [file...]"

exit :: IO a
exit = exitWith ExitSuccess

parse :: [String] -> IO String
parse ["-h"] = usage >> exit
parse [file] = pure file
parse [] = usage >> exit

main :: IO ()
main = getArgs >>= parse >>= upload
