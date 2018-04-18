module Continuations where

import Spec

getUser :: Request -> (User -> IO Response) -> IO Response
getUser (Request _ _ _ header) cont =
  case lookup "Authorization" header of
    Nothing -> return noToken
    Just token ->
      if is_malformed_token then return (malformedToken token) else
      if is_user_not_found then return (noUser token) else
      cont the_user

getResource :: Request -> (Resource -> IO Response) -> IO Response
getResource (Request path _ _ _) cont =
  is_resource_not_found_io >>= \notFound ->
  if notFound then return (noResource path) else
  the_resource_io >>= cont

execute :: String -> User -> Resource -> (() -> IO Response) -> IO Response
execute body usr src@(Resource path) cont =
  is_permitted_io >>= \permitted ->
  if not permitted then return (notPermitted path) else
  is_executed_io >>= \executed ->
  if not executed then return badConnection else
  cont ()

handlePost :: Request -> IO Response
handlePost req@(Request path method body _) =
  if method /= "POST" then return (notAllowed method) else
  if null body then return noBody else
  getUser req (\usr ->
  getResource req (\src ->
  execute body usr src (\_ ->
  return (success path body))))
