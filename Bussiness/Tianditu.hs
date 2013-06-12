module Bussiness.Tianditu
where

import Import

import qualified Data.Text as T
import qualified Data.Map as Map
import qualified Network.HTTP as Http
import qualified Data.Int as Data

import Data.Time

import qualified Data.ByteString.Char8 as Bys
fun1 :: Text -> Text
fun1 x = T.append x x


tileSizeWidth = 256
tileSizeHeight = 256
originLon = -180
originLat = -90
topTileFromX = -180
topTileFromY = 90
calculateGridParams :: Float  -> Float -> Float -> Map.Map  String  Float
calculateGridParams resolution minx maxy =
    let tilelon = resolution * tileSizeWidth
        tilelat = resolution * tileSizeHeight
        offsetlon = minx - originLon
        tilecol = floor (offsetlon / tilelon) :: Integer
        tileoffsetlon  = originLon + (fromIntegral tilecol) * tilelon
        offsetlat   = maxy - (originLat + tilelat)
        tilerow = ceiling ((offsetlat / tilelat) :: Float) :: Integer
        tileoffsetlat = originLat + (fromIntegral tilerow) * tilelat


    in  Map.fromList [("tilelon", tilelon),("tilelat", tilelat),("tileoffsetlon",tileoffsetlon),("tileoffsetlat", tileoffsetlat)]

mapCacheParams :: Int -> Float -> Float -> Float -> Float -> [[Data.Int64]]
mapCacheParams level minx maxx miny maxy =
    let caculateParams = calculateGridParams  (180.0 / (512.0 * (2 ^ (level - 1)) )) minx maxy
        tilelon  = caculateParams Map.! "tilelon"
        tilelat  = caculateParams Map.! "tilelat"
        tileoffsetlon = caculateParams Map.! "tileoffsetlon"
        tileoffsetlat = caculateParams Map.! "tileoffsetlat"

    in [getMapTilesXyNum  x y tilelat tilelon level | x <- [ tileoffsetlon, (tileoffsetlon +tilelon) .. maxx], y <- [tileoffsetlat,(tileoffsetlat - tilelat) .. miny]]

getMapTilesXyNum   tileoffsetlon tileoffsetlat  tilelat tilelon  level =
    let coef = 360 /  2 ^ level
        x_num = round ((tileoffsetlon - topTileFromX) / coef)
        y_num = round ((topTileFromY - (tileoffsetlat + tilelat)) / coef)

    in [x_num,y_num]


getMapTilesFromUrl x y z =do


    let imgUrl= ("http://t2.tianditu.cn/vec_c/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=vec" :: String) ++
                                        ("&TILEMATRIXSET=c&TILEMATRIX=" :: String) ++ (show z) ++ ("&TILEROW=" :: String) ++(show y)++
                                        ("&TILECOL=" :: String ) ++ (show x)

    uptime <- liftIO $ getCurrentTime
    img <- liftIO $ Http.simpleHTTP (Http.getRequest imgUrl) >>= Http.getResponseBody

    mapcacheId <-  runDB $ insert $ Mapcache (1 :: Data.Int64) uptime x  y  z  False  (Bys.pack img)


    -- let img = Http.simpleHTTP (Http.getRequest imgUrl) >>= Http.getResponseBody

    $(logDebug) (T.pack imgUrl)





