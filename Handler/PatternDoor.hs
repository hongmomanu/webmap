module Handler.PatternDoor where

import Import

postPatternDoorR :: Handler Value
postPatternDoorR = do
    host <- lookupPostParams "host"
    name <- lookupPostParams "name"
    liftIO $ print host
    liftIO $ print name
    return  $ object ["success" .= True]