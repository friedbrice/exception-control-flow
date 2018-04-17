module Spec where

newtype User = User { getToken :: String }
newtype Resource = Resource { getPath :: String }

data Request = Request
  { path :: String
  , method :: String
  , body :: String
  , header :: [(String, String)]
  }

data Response = Response { code :: Int, content :: String } deriving (Eq, Show)

success path body = Response 200 $
  "Successfully posted " ++ body ++ " to " ++ path

noBody = Response 400 $
  "You must provide a non-empty request body"

noToken = Response 401 $
  "You must provide an authorization header field"

malformedToken token = Response 401 $
  "Provided token is malformed: " ++ token

noUser token = Response 401 $
  "No user found for token: " ++ token

notPermitted path = Response 403 $
  "You do not have permission to post on " ++ path

noResource path = Response 404 $
  "No resource found for path: " ++ path

notAllowed method = Response 405 $
  "Method not allowed: " ++ method

badConnection = Response 503
  "Connection error, please try again later"

is_malformed_token = undefined :: Bool
is_user_not_found = undefined :: Bool
the_user = undefined :: User
is_resource_not_found_io = undefined :: IO Bool
the_resource_io = undefined :: IO Resource
is_permitted_io = undefined :: IO Bool
is_executed_io = undefined :: IO Bool
