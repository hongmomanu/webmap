{-# LANGUAGE ScopedTypeVariables #-}
module Handler.CheckConnect where

import Import

import Database.HDBC
import Database.HDBC.ODBC
import Database.HDBC.PostgreSQL
import qualified Data.Text as T
import qualified Bussiness.ConnPool as Pol


import Control.Exception (handle, SomeException)


postCheckConnectR :: Handler Value
postCheckConnectR = do
    host <- lookupPostParam "host"
    dbname <- lookupPostParam "dbname"
    user <- lookupPostParam "user"
    password <- lookupPostParam "password"
    databsetype <-lookupPostParam "databsetype"

    let paramList=checkUlrFilter host dbname user password  databsetype

    case paramList!!4 of "0" -> do dbh <- liftIO $ connectPg  (paramList !! 0)  (paramList !! 1)  (paramList !! 2)  (paramList !! 3)
                                   return $ object ["success" .= fst dbh,"msg" .= fst (snd dbh),"tables" .= snd (snd dbh)]
                         "1" -> do dbh <- liftIO $ connectOracle  (paramList !! 0)  (paramList !! 1)  (paramList !! 2)  (paramList !! 3)
                                   return $ object ["success" .= fst dbh,"msg" .= fst (snd dbh),"tables" .= snd (snd dbh)]



    --dbh <- liftIO $ connectPg  (paramList !! 0)  (paramList !! 1)  (paramList !! 2)  (paramList !! 3)
    --return $ object ["success" .= fst dbh,"msg" .= fst (snd dbh),"tables" .= snd (snd dbh)]
    

--连接postgis数据库
connectPg   host dbname user password =
    let dbh=  handle(\(e :: SomeException) ->  return  (False,(show e,[])))
            (do  connPool <- Pol.newConnPool 1 3 (connectPostgreSQL ("host="++ T.unpack(host) ++
                            " dbname="++ T.unpack(dbname) ++" user=" ++ T.unpack(user) ++" password="++ T.unpack(password))) disconnect
                 --conn <-  (connectPostgreSQL ("host="++ T.unpack(host) ++" dbname="++ T.unpack(dbname) ++" user=" ++ T.unpack(user) ++" password="++ T.unpack(password)))
                 --conn <- (snd (Pol.takeConn connPool))
                 Pol.withConn connPool $ \conn -> do tables <- getTables conn
                                                     return (True,("连接成功!",tables)))

    in dbh

--连接oracle数据库
connectOracle host dbname user password =
    let dbh=  handle(\(e :: SomeException) ->  return  (False,(show e,[])))
            (do  connPool <- Pol.newConnPool 1 3 (connectODBC ("Driver={/opt/instantclient/libsqora.so.11.1};Uid="
                            ++ T.unpack(user) ++ ";Pwd=" ++ T.unpack(password) ++";Dbq=" ++ T.unpack(host))) disconnect

                 Pol.withConn connPool $ \conn -> do tables <- getTables conn
                                                     --print tables
                                                     return (True,("连接成功!",tables)))
                 --conn <- (connectODBC ("Driver={/opt/instantclient/libsqora.so.11.1};Uid=" ++ T.unpack(user) ++ ";Pwd=" ++ T.unpack(password) ++";Dbq=" ++ T.unpack(host)))
                 --tables <- getTables conn
                 --print  tables
                 --disconnect conn
                 --return (True,("连接成功!",tables)))
    in dbh




--访问参数过滤
checkUlrFilter host dbname user password databsetype =
    let host_param =case host of
                Just "" -> error "host 无值"
                Just info -> info
                Nothing -> error "no host param"
        dbname_param =case dbname of
                Just "" -> error "dbname 无值"
                Just info -> info
                Nothing -> error "no dbname param"
        user_param =case user of
                Just "" -> error "user 无值"
                Just info -> info
                Nothing -> error "no user param"
        password_param =case password of
                Just "" -> error "password 无值"
                Just info -> info
                Nothing -> error "no password param"
        databsetype_param =case  databsetype of
                Just "" -> error "databsetype 无值"
                Just info -> info
                Nothing -> error "no databsetype param"

    in [host_param,dbname_param,user_param,password_param,databsetype_param]
