module Eithers where

import Spec
import Control.Monad (join)

implies :: Bool -> e -> Either e ()
failure `implies` fallback = if failure then Left fallback else Right ()

implies' :: IO Bool -> e -> IO (Either e ())
failures `implies'` fallback = (`implies` fallback) <$> failures

tunnel :: Either e (IO (Either e a)) -> IO (Either e a)
tunnel eitherIoEither = join <$> sequenceA eitherIoEither

getUser :: Request -> Either Response User
getUser (Request _ _ _ header) = do
  token <- maybe (Left noToken) Right $ lookup "Authorization" header
  is_malformed_token `implies` malformedToken token
  is_user_not_found `implies` noUser token
  return the_user

getResource :: () -> Request -> IO (Either Response Resource)
getResource method (Request path _ _ _) = do
  let doResource = (\_ -> the_resource_io) :: () -> IO Resource
  notFound <- is_resource_not_found_io `implies'` noResource path
  doResource `traverse` notFound

execute :: () -> String -> User -> Resource -> IO (Either Response ())
execute method body usr (Resource path) = do
  let doExecuted = (\_ -> is_executed_io) :: () -> IO Bool
  permitted <- (not <$> is_permitted_io) `implies'` notPermitted path
  executed <- doExecuted `traverse` permitted
  return ((not <$> executed) >>= (`implies` badConnection))

handlePost :: Request -> IO Response
handlePost req@(Request path method body _) = either id id <$> result where
  chkMth = (method /= "POST") `implies` notAllowed method
  errBdy = null body `implies` noBody >> return body
  errUsr = getUser req
  precon = chkMth >> errBdy >> errUsr >> return ()
  result = do
    errSrc <- tunnel (getResource <$> precon <*> pure req)
    errExe <- tunnel (execute <$> precon <*> errBdy <*> errUsr <*> errSrc)
    return (errExe >> return (success path body))
