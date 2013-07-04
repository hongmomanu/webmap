module Handler.Maptodo where

import Import
import qualified Bussiness.Tianditu as Td
import Data.Time
import qualified Data.Text as T

postMaptodoR  :: Handler Value
postMaptodoR = do
    type_param  <- lookupPostParam "type"
    treelevel_param <- lookupPostParam "treelevel"
    key_param <- lookupPostParam "keyid"
    mapower <- lookupPostParam "text"
    owername <- lookupPostParam "name"
    projection <- lookupPostParam "projection"
    spatialreference <- lookupPostParam "spatialreference"
    maptype <- lookupPostParam "maptype"
    
    let paramList=Td.maptodoUrlFilter type_param treelevel_param key_param mapower owername projection spatialreference maptype
    uptime <- liftIO $ getCurrentTime
    liftIO $ print paramList
    mapserverId <-  runDB $ insert $ Mapserver (paramList !! 3) (paramList !! 4) (paramList !! 6) (paramList !! 5) (read (T.unpack (paramList !! 7))) uptime
    
    return $ object ["success" .= True,"results" .= array [object ["text" .= ("天地图全国矢量底图" :: Text)],object ["text" .= ("天地图全国矢量图标" :: Text)]] ]