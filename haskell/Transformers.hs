{-# LANGUAGE FlexibleContexts #-}

module Transformers where

import Spec
import Control.Monad.Except (MonadError, throwError, runExceptT)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Functor.Identity (runIdentity)

implies :: MonadError e m => Bool -> e -> m ()
failure `implies` fallback = if failure then throwError fallback else return ()

getUser :: MonadError Response m => Request -> m User
getUser (Request _ _ _ header) = do
  token <- maybe (throwError noToken) return $ lookup "Authorization" header
  is_malformed_token `implies` malformedToken token
  is_user_not_found `implies` noUser token
  return the_user

getResource :: (MonadError Response m, MonadIO m) => Request -> m Resource
getResource (Request path _ _ _) = do
  liftIO is_resource_not_found_io >>= (`implies` noResource path)
  liftIO the_resource_io

execute :: (MonadError Response m, MonadIO m)
        => String -> User -> Resource -> m ()
execute body usr (Resource path) = do
  liftIO (not <$> is_permitted_io) >>= (`implies` notPermitted path)
  liftIO (not <$> is_executed_io) >>= (`implies` badConnection)

handlePost :: Request -> IO Response
handlePost req = (either id id <$>) . runExceptT $ do
  (method req /= "POST") `implies` notAllowed (method req)
  (null $ body req) `implies` noBody
  usr <- getUser req
  src <- getResource req
  execute (body req) usr src
  return $ success (path req) (body req)
