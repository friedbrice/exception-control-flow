module Simple where

import Spec

getUser :: Request -> Either Response User
getUser (Request _ _ _ header) = case lookup "Authorization" header of
  Nothing -> Left noToken
  Just token ->
    if is_malformed_token then Left (malformed token)
    else if is_user_not_found then Left (noUser token)
    else Right the_user

getResource :: Request -> IO (Either Response Resource)
getResource (Request path _ _ _) = do
  notFound <- is_resource_not_found_io
  if notFound then return (Left (noResource path))
  else Right <$> the_resource_io

execute :: String -> User -> Resource -> IO (Either Response ())
execute body usr (Resource path) = do
  permitted <- is_permitted_io
  if not permitted then return (Left (notPermitted path))
  else do
    executed <- is_executed_io
    if not executed then return (Left (badConnection))
    else return (Right ())

handlePost :: Request -> IO {-(Either Response-} Response{-)-}
handlePost req@(Request path method body _) = either id id <$>
  if method /= "POST" then return (Left (notAllowed method))
  else if null body then return (Left noBody)
  else case getUser req of
    Left res -> return (Left res)
    Right usr -> do
      maybeSrc <- getResource req
      case maybeSrc of
        Left res -> return (Left res)
        Right src -> do
          maybeExe <- execute body usr src
          case maybeExe of
            Left res -> return (Left res)
            Right _ -> return (Right (success path body))
