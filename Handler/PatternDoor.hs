module Handler.PatternDoor where

import Import
import qualified Bussiness.Dbconn as Db
import qualified Bussiness.Pattern as Pa
import qualified Data.Text as T
import Database.HDBC
import Control.Concurrent
import Data.IORef
import Data.Time
import Prelude



--匹配入口
postPatternDoorR :: Handler Value
postPatternDoorR = do
    hosts <- lookupPostParams "host"
    users <- lookupPostParams "user"
    passwords <- lookupPostParams "password"
    dbnames <- lookupPostParams "dbname"
    databasetypes <- lookupPostParams "databsetype"
    mytables <-  lookupPostParams "proptable"
    sqls <- lookupPostParams "sql"
    issplit <- lookupPostParams "issplit"
    mainkey <- lookupPostParams "mainkey"

    --liftIO $ print issplit
    statue <-liftIO $ readIORef Pa.patterStatuesVar
    time <-liftIO $  getCurrentTime
    let statues=statue ++ [[head mytables,head users,T.pack (show time),T.pack(show 1),T.pack(show 0)]]
    liftIO $ writeIORef (Pa.patterStatuesVar) statues
    liftIO $ print statues
    --懒惰加载数据连接
    let prop_db=(Db.connectPg  (hosts !! 0)  (dbnames !! 0)  (users !! 0)  (passwords !! 0),
                    Db.connectOracle  (hosts !! 0)  (dbnames !! 0)  (users !! 0)  (passwords !! 0)
                 )
    let space_db=(Db.connectPg  (hosts !! 1)  (dbnames !! 1)  (users !! 1)  (passwords !! 1),
                    Db.connectOracle  (hosts !! 1)  (dbnames !! 1)  (users !! 1)  (passwords !! 1)
                 )
    --prop_conn <- liftIO $ (fst prop_db)
    --tables <- liftIO $ getTables prop_conn
    --forkIO (writeFile "xyzzy" "seo craic nua!") >> doesFileExist "xyzzy"

    liftIO $ forkIO (Pa.patternBegin prop_db  space_db   (mytables !! 0) (mytables !! 1)  (sqls !! 0) (sqls !! 1) (databasetypes !! 0) (databasetypes !! 1) issplit mainkey (T.pack (show time)))>> print "ok"
    return  $ object ["success" .= True,"msg" .= ("正在处理数据"::Text)]

    --return  $ object ["success" .= True,"msg" .= mytables]


