module Handler.Echo where

import Import

getEchoR :: String -> Handler RepHtml

getEchoR theText = defaultLayout $(widgetFile "echo")