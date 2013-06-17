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
    let paramList=Td.getImgUlrFilter z_param
    let level =read (T.unpack (paramList  !! 0 )) :: Data.Int64
    let temp = Td.mapCacheParams level  118.0 121.0 28.0 31.0

    sequence [Td.getMapTilesFromUrl x y level| [x,y] <- temp ]
    error "no x param"

