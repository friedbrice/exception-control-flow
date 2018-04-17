{-# LANGUAGE FlexibleContexts #-}

module Transformers where

import Spec
import Control.Monad.Except (ExceptT, MonadError, throwError, runExceptT)
import Control.Monad.IO.Class (MonadIO, liftIO)

implies :: MonadError e m => Bool -> e -> m ()
failure `implies` fallback = undefined

getUser :: MonadError Response m => Request -> m User
getUser (Request _ _ _ header) = undefined

getResource :: (MonadError Response m, MonadIO m) => Request -> m Resource
getResource (Request path _ _ _) = undefined

execute :: (MonadError Response m, MonadIO m)
        => String -> User -> Resource -> m ()
execute body usr (Resource path) = undefined

handlePost :: Request -> IO Response
handlePost req = undefined
