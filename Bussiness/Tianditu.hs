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
import Database.Persist
import Database.Persist.Sqlite
import Database.Persist.TH
import System.Directory

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
    img  <- liftIO $  safeQueryEasy imgUrl
    mapcacheId <-  runDB $ test  (1 :: Data.Int64) uptime x  y  z  False    (Bys.pack img) (1 :: Data.Int64)
    $(logDebug) (T.pack imgUrl)


test taskid tm x y z issuc img layerid =withSqliteConn ":memory:" $  runSqlConn $ do
    runMigration migrateAll

    insert $ Mapcache taskid tm x y z issuc img layerid
    

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
--参数过滤
getImgUlrFilter z_param maxx_param maxy_param minx_param miny_param layerid_param =
    let z     = case z_param of
                  Just "" -> error "z 无值"
                  Just info -> info
                  Nothing -> error "no LLLL param"
        maxx  = case maxx_param of
                  Just "" -> error "maxx 无值"
                  Just info -> info
                  Nothing -> error "no maxxParam param"          
        maxy  = case maxy_param of
                  Just "" -> error "maxy 无值"
                  Just info -> info
                  Nothing -> error "no maxyParam param" 
        minx  = case minx_param of
                  Just "" -> error "minx 无值"
                  Just info -> info
                  Nothing -> error "no minxParam param"
        miny  = case miny_param of
                  Just "" -> error "miny 无值"
                  Just info -> info
                  Nothing -> error "no minyParam param" 
        layerid = case layerid_param of
                    Just "" -> error "layerid 无值"
                    Just info -> info
                    Nothing -> error "no layeridParam param" 
       

    in [z,maxx,maxy,minx,miny,layerid]


--写入瓦片缓存,不管文件是否存在
writeTileCache layerid x y z = do
    createDirectoryIfMissing  True "/home/jack/test/test"

    writeFile "/home/jack/output.txt" "str"



