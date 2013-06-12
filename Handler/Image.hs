module Handler.Image where

import Import

import qualified Bussiness.Tianditu as Td
import qualified Data.ByteString as Str
import qualified Data.Text as T
import qualified Data.Int as Data
import Data.Time
import Data.Maybe
import qualified  Prelude as Pr
import qualified Control.Exception.Peel  as Pe

getImageR :: Handler Html
-- getImageR = error "Not yet implemented: getImageR"
-- $(logDebug) (Td.fun1 "This is a debug log message") sendFile typeJpeg "/Users/jack/Pictures/平沙落雁/200811117508424_2.jpg"
getImageR =do
    x_param  <- lookupGetParam "x"
    let x =case x_param of
                Just "" -> error "x 无值"
                Just info -> info
                Nothing -> error "no x param"

    mapcaches <-  runDB $ selectFirst [MapcacheX ==. (read (T.unpack x))] []
    -- uptime <- liftIO $ getCurrentTime
    -- img <- liftIO $ (Str.readFile "/Users/jack/Pictures/平沙落雁/200811117508424_2.jpg")
    -- mapcacheId<- runDB $ insert $ Mapcache 1 uptime 1 1 1 True  img
    -- mapcache <- runDB $ get404 mapcacheId
    --mapcaches <- runDB $ selectList [][]
      -- $(logDebug)  (T.pack ("x值：" ++ show (Pr.head (Pr.head temp)) ++ "y 值：" ++ show (Pr.last (Pr.head temp)) ))
        -- Td.getMapTilesFromUrl 1 2 3

    let Entity mapcacheId mapcache=case mapcaches of
                                        Just info -> info
                                        Nothing -> error    "no such img"
    --error "Not yet implemented: getImageR"
    --let Entity mapcacheId mapcache =  fromJust mapcaches
    let temp = Td.mapCacheParams 15  118.0 121.0 28.0 31.0

    sequence [Td.getMapTilesFromUrl x y 15| [x,y] <- temp ]

    $(logDebug) (T.pack (show (length temp)))

    sendResponse (typePng, toContent (mapcacheImg mapcache))

