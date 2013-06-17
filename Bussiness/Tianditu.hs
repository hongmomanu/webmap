module Bussiness.Tianditu
where

import Import

import qualified Data.Text as T
import qualified Data.Map as Map
import qualified Network.HTTP as Http
import qualified Data.Int as Data
import System.Timeout
import Data.Maybe
import qualified Network.HTTP.Types as H
import qualified Control.Exception as E
import Network.HTTP.Conduit -- the main module
import Network
import Control.Concurrent (threadDelay,forkIO)

import Data.Time
import Data.ByteString.Lazy as LBS
import System.Random

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

mapCacheParams :: Data.Int64 -> Float -> Float -> Float -> Float -> [[Data.Int64]]
mapCacheParams level minx maxx miny maxy =
    let caculateParams = calculateGridParams  (180.0 / (512.0 * (2 ^ (level - 2)) )) minx maxy
        tilelon  = caculateParams Map.! "tilelon"
        tilelat  = caculateParams Map.! "tilelat"
        tileoffsetlon = caculateParams Map.! "tileoffsetlon"
        tileoffsetlat = caculateParams Map.! "tileoffsetlat"

    in [getMapTilesXyNum  x y tilelat tilelon level | x <- [ tileoffsetlon, (tileoffsetlon +tilelon) .. maxx], y <- [tileoffsetlat,(tileoffsetlat - tilelat) .. miny]]

getMapTilesXyNum   tileoffsetlon tileoffsetlat  tilelat tilelon  level =
    let coef = 360 /  2 ^ level
        x_num = round ((tileoffsetlon - topTileFromX) / coef)
        y_num = round ((topTileFromY - tileoffsetlat) / coef)

    in [x_num,y_num]


safeQuery req = E.catch (withManager $ httpLbs req) (\e -> print (e :: E.SomeException) >> threadDelay 1000 >> safeQuery req)
safeQueryEasy imgUrl = E.catch (Http.simpleHTTP (Http.getRequest imgUrl) >>= Http.getResponseBody) (\e -> print (e :: E.SomeException) >> threadDelay 1 >> safeQueryEasy imgUrl)



getMapTilesFromUrl x y z =do


    randomServerNum <- liftIO $ randomRIO (0::Int, 7::Int)
    let imgUrl= ("http://t" ++ (show randomServerNum) ++ ".tianditu.cn/vec_c/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=vec" :: String) ++
                                            ("&TILEMATRIXSET=c&TILEMATRIX=" :: String) ++ (show z) ++ ("&TILEROW=" :: String) ++(show y)++
                                            ("&TILECOL=" :: String ) ++ (show x)

    uptime <- liftIO $ getCurrentTime

    --req <- parseUrl "http://t0.tianditu.cn/vec_c/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=vec&TILEMATRIXSET=c&TILEMATRIX=13&TILEROW=1349&TILECOL=6781"
    --let req2=req {method = "GET",requestHeaders=[("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20100101 Firefox/16.0") :: H.Header]}
    --res  <- liftIO $  ( safeQuery   req2)
    --res <- withManager $ httpLbs req2
    --let img =responseBody res

    --maybeImg <- liftIO $ timeout 100000 ((Http.simpleHTTP (Http.getRequest imgUrl)) >>= Http.getResponseBody)
    --let img = fromMaybe "" maybeImg
    --liftIO $ print img
    --img <- liftIO $ Http.simpleHTTP (Http.getRequest imgUrl) >>= Http.getResponseBody
    img  <- liftIO $  safeQueryEasy imgUrl
    mapcacheId <-  runDB $ insert $ Mapcache (1 :: Data.Int64) uptime x  y  z  False    (Bys.pack img) (1 :: Data.Int64)
    --mapcacheId <-  safeInsertImg  (1 :: Data.Int64) uptime x  y  z  False    (Bys.pack img) (1 :: Data.Int64)

    -- let img = Http.simpleHTTP (Http.getRequest imgUrl) >>= Http.getResponseBody

    $(logDebug) (T.pack imgUrl)



imgsaveInsert taskid tm x y z issuc img layerid= do
    E.catch (insert $ Mapcache taskid tm x y z issuc img layerid)(\e -> print (e :: E.SomeException) >> threadDelay 1 >> imgsaveInsert taskid tm x y z issuc img layerid)
    print "haha"

tilesUlrFilter x_param y_param z_param layerid_param =
    let x =case x_param of
                Just "" -> error "x 无值"
                Just info -> info
                Nothing -> error "no x param"
        y =case y_param of
                Just "" -> error "y 无值"
                Just info -> info
                Nothing -> error "no y param"
        z =case z_param of
                Just "" -> error "z 无值"
                Just info -> info
                Nothing -> error "no z param"
        layerid =case layerid_param of
                Just "" -> error "layerid 无值"
                Just info -> info
                Nothing -> error "no layerid param"

    in [x,y,z,layerid]

getImgUlrFilter z_param =
    let z =case z_param of
                Just "" -> error "z 无值"
                Just info -> info
                Nothing -> error "no z param"

    in [z]






