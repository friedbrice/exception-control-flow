module Test where

import Spec
import qualified Continuations
import qualified Eithers
import qualified Transformers

request1 = Request "path" "POST" "" [("Authorization", "hunter2")]
request2 = Request "path" "POST" "body" [("Nope", "nada")]
request3 = Request "path" "FOO" "body" [("Authorization", "hunter2")]

expected1 = noBody
expected2 = noToken
expected3 = notAllowed "FOO"

assert :: String -> Bool -> IO ()
assert msg p = if p then putStrLn ("\tPassed: " ++ msg) else error msg

testHandler :: String -> (Request -> IO Response) -> IO ()
testHandler name handler = do
  putStrLn $ "Testing " ++ name ++ ":"

  let testCase desc input expected = do 
      actual <- handler input
      putStrLn $ "\t" ++ show actual
      assert desc $ actual == expected

  testCase "should handle requests with no body" request1 expected1
  testCase "should handle requests with no auth" request2 expected2
  testCase "should handle requests with wrong method" request3 expected3

  putStrLn "Passed.\n"

main :: IO ()
main = do
  putStrLn "\nRunning Test Suite\n"
  testHandler "Continuations" Continuations.handlePost
  testHandler "Eithers" Eithers.handlePost
  testHandler "Transformers" Transformers.handlePost
  putStrLn "All tests pass.\n"
