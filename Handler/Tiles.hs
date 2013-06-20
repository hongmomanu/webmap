module Handler.Tiles where

import Import

import qualified Bussiness.Tianditu as Td
import qualified Data.Text as T
import System.Directory

getTilesR :: Handler Html
getTilesR =do
-- 参数过滤，不满足条件返回错误信息
    x_param  <- lookupGetParam "X"
    y_param <- lookupGetParam "Y"
    z_param <- lookupGetParam "L"
    layerId <- lookupGetParam "layerid"
    liftIO $ Td.writeTileCache 1 2 3 4 
    
    let paramList=Td.tilesUlrFilter x_param y_param z_param layerId
-- 判断文件是否存在    
    
    let gncDir="/home/jack/data/"
    let fileName="gnc/1"++"/"++(T.unpack (paramList  !! 2 )) ++"/"++ (T.unpack (paramList  !! 0 ))++"/"++(T.unpack (paramList  !! 1 ))++".png"
    let filePath=gncDir ++ fileName
    result <- liftIO $ doesFileExist filePath
    let url="http://localhost/gnc/1"++"/"++(T.unpack (paramList  !! 2 )) ++"/"++ (T.unpack (paramList  !! 0 ))++"/"++(T.unpack (paramList  !! 1 ))++".png"
    if result then redirect url else $(logDebug) (T.pack "go on")
    $(logDebug) (T.pack "get some thing new")
    mapcaches <-  runDB $ selectFirst [MapcacheX ==. (read (T.unpack (paramList  !! 0 ))),
                         MapcacheY ==. (read (T.unpack (paramList  !! 1 ))),
                         MapcacheZ ==. (read (T.unpack (paramList  !! 2 ))),
                         MapcacheLayerid ==. (read (T.unpack (paramList  !! 3 )))] []
    let Entity mapcacheId mapcache=case mapcaches of
                          Just info -> info
                          Nothing -> error    "no such img"
    sendResponse (typePng, toContent (mapcacheImg mapcache))
    --redirect url
