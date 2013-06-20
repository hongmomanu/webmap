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
    z_param <- lookupGetParam "L"
    maxx_param <- lookupGetParam "maxx"
    maxy_param <- lookupGetParam "maxy"
    minx_param <- lookupGetParam "minx"
    miny_param <- lookupGetParam "miny"
    layerid_param <- lookupGetParam "layerid"
    let paramList=Td.getImgUlrFilter z_param maxx_param maxy_param minx_param miny_param layerid_param 
    let level =read (T.unpack (paramList  !! 0 )) :: Data.Int64
    let maxx =read (T.unpack (paramList  !! 1 )) :: Float
    let maxy =read (T.unpack (paramList  !! 2 )) :: Float
    let minx=read (T.unpack (paramList  !! 3 )) :: Float
    let miny=read (T.unpack (paramList  !! 4 )) :: Float
    let layerid=read (T.unpack (paramList  !! 5 )) :: Float
    --liftIO $ print level
    let temp = Td.mapCacheParams level  minx maxx miny maxy

    sequence [Td.getMapTilesFromUrl x y level| [x,y] <- temp ]
    --error "no x param"
    defaultLayout $ do
        aDomId <- newIdent
        setTitle "Welcome To Yesod!"
        $(widgetFile "homepage")

